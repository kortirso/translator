import React from 'react';
import LocalizedStrings from 'react-localization';
import I18nData from './i18n_data.json';

let strings = new LocalizedStrings(I18nData);

class TranslationsBox extends React.Component {

    constructor() {
        super();
        this.state = {

        }
    }

    componentWillMount() {
        strings.setLanguage(this.props.locale);
    }

    componentDidMount() {

    }

    render() {
        return (
            <div>

            </div>
        );
    }
}

export default TranslationsBox;