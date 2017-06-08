import React from 'react';
import TranslationsLocale from 'components/translations_box/translations_locale';
import LocalizedStrings from 'react-localization';
import I18nData from './i18n_data.json';

let strings = new LocalizedStrings(I18nData);
let alphabet = {en: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X','Y', 'Z'], ru: ['А', 'Б', 'В', 'Г', 'Д', 'Е', 'Ё', 'Ж', 'З', 'И', 'Й', 'К', 'Л', 'М', 'Н', 'О', 'П', 'Р', 'С', 'Т', 'У', 'Ф', 'Х', 'Ц', 'Ч', 'Ш', 'Щ', 'Э', 'Ю', 'Я'], da: []};

class TranslationsBox extends React.Component {

    constructor() {
        super();
        this.state = {
            locale: null,
            letter: null,
            translationsList: []
        }
    }

    componentWillMount() {
        strings.setLanguage(this.props.locale);
    }

    _fetchTranslations(letter) {
        $.ajax({
            method: 'GET',
            url: `api/v1/translations.json?access_token=${this.props.access_token}&language=${this.state.locale}&letter=${letter}`,
            success: (data) => {
                console.log(data.words);
                this.setState({translationsList: data.words, letter: letter});
            }
        });
    }

    _selectOption(value) {
        this.setState({locale: value, letter: null});
    }

    _selectLetter(event) {
        this._fetchTranslations(event.target.text);
    }

    _prepareAlphabetLinks() {
        if(alphabet[this.state.locale] != null) {
            return alphabet[this.state.locale].map((letter, index) => {
                return (
                    <a onClick={this._selectLetter.bind(this)} key={index}>{letter}</a>
                );
            });
        }
    }

    _prepareWord(translations) {
        return translations.map((translation) => {
            return (
                <span className='translation_name' key={translation.id}>{translation.result_text}</span>
            );
        });
    }

    _prepareTranslations() {
        if(this.state.letter != null) {
            if(this.state.translationsList.length == 0) {
                return <p>No translations</p>;
            }
            else {
                return this.state.translationsList.map((word) => {
                    return (
                        <div className='translation' key={word.id}>
                            <p>{word.text}</p>
                            <p>Translations are:</p>
                            {this._prepareWord(word.translations)}
                        </div>
                    );
                });
            }
        }
    }

    render() {
        return (
            <div>
                <TranslationsLocale locale={this.props.locale} onSelectOption={this._selectOption.bind(this)} />
                <div>{this._prepareAlphabetLinks()}</div>
                <div>{this._prepareTranslations()}</div>
            </div>
        );
    }
}

export default TranslationsBox;