import React from 'react';
import TranslationsLocale from 'components/translations_box/translations_locale';
import LocalizedStrings from 'react-localization';
import I18nData from './i18n_data.json';

let strings = new LocalizedStrings(I18nData);

class TranslationsBox extends React.Component {

    constructor() {
        super();
        this.state = {
            locale: null
        }
    }

    componentWillMount() {
        strings.setLanguage(this.props.locale);
    }

    _selectOption(value) {
        this.setState({locale: value})
    }

    render() {
        return (
            <div>
                <TranslationsLocale locale={this.props.locale} onSelectOption={this._selectOption.bind(this)} />
            </div>
        );
    }
}

export default TranslationsBox;