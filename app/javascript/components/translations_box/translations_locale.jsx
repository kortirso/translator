import React from 'react';
import LocalizedStrings from 'react-localization';
import I18nData from './i18n_data.json';

let strings = new LocalizedStrings(I18nData);

class TranslationsLocale extends React.Component {

    constructor() {
        super();
        this.state = {
            selectedOption: null
        }
    }

    componentWillMount() {
        strings.setLanguage(this.props.locale);
    }

    _handleOptionChange(event) {
        this.setState({selectedOption: event.target.value});
        this.props.onSelectOption(event.target.value);
    }

    render() {
        return (
            <div>
                <form>
                    <div className='radio'>
                        <label>
                            <input type='radio' value='en' checked={this.state.selectedOption === 'en'} onChange={this._handleOptionChange.bind(this)} />
                            English
                         </label>
                    </div>
                    <div className='radio'>
                        <label>
                            <input type='radio' value='ru' checked={this.state.selectedOption === 'ru'} onChange={this._handleOptionChange.bind(this)} />
                            Russian
                        </label>
                    </div>
                    <div className='radio'>
                        <label>
                            <input type='radio' value='da' checked={this.state.selectedOption === 'da'} onChange={this._handleOptionChange.bind(this)} />
                            Danish
                        </label>
                    </div>
                </form>
            </div>
        );
    }
}

export default TranslationsLocale;