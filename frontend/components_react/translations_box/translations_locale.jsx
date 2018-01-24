import React from 'react';
const $ = require("jquery");

class TranslationsLocale extends React.Component {

    constructor() {
        super();
        this.state = {
            selectedOption: null,
            locales: []
        }
    }

    componentWillMount() {
        this._fetchLocales();
    }

    _fetchLocales() {
        $.ajax({
            method: 'GET',
            url: `api/v1/locales.json`,
            success: (data) => {
                this.setState({locales: data.locales});
            }
        });
    }

    _handleOptionChange(event) {
        this.setState({selectedOption: event.target.value});
        this.props.onSelectOption(event.target.value);
    }

    _prepareLocales() {
        return this.state.locales.map((option) => {
            return (
                 <div className='radio' key={option.id}>
                    <label>
                        <input type='radio' value={option.code} checked={this.state.selectedOption === option.code} onChange={this._handleOptionChange.bind(this)} />
                        {option.names[this.props.strings.language]}
                     </label>
                </div>
            );
        });
    }

    render() {
        return (
            <div>
                <form>
                    {this._prepareLocales()}
                </form>
            </div>
        );
    }
}

export default TranslationsLocale;