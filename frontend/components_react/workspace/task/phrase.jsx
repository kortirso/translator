import React from 'react'
const $ = require('jquery')

export default class Phrase extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      currentValue: props.phrase.current_value
    }
  }

  _renderTranslations() {
    return this.props.phrase.word.translations.map((translation, index) => {
      return (
        <div className='translation' key={index}>
          <p>{translation}</p>
          <a className='button small choose_phrase' onClick={this._updatePhrase.bind(this, translation)}>Choose</a>
        </div>
      )
    })
  }

  _updatePhrase(value) {
    $.ajax({
      method: 'PATCH',
      url: `../phrases/${this.props.phrase.id}.json`,
      data: {phrase: {current_value: value}},
      success: (data) => {
        console.log(data)
      }
    })
  }

  render() {
    const phrase = this.props.phrase
    return (
      <div className='phrase'>
        <label>Base value from source</label>
        <textarea readOnly defaultValue={phrase.word.text} rows='3' />
        <label>Current value for translation</label>
        <div className='text_area'>
          <textarea value={this.state.currentValue} rows='3' onChange={(text) => this.setState({currentValue: text})} />
          <a className='button small save_phrase' onClick={this._updatePhrase.bind(this, this.state.currentValue)}>Save</a>
        </div>
        <h4>Possible translations</h4>
        {this._renderTranslations()}
      </div>
    )
  }
}
