import React from 'react'
import Phrase from 'components_react/workspace/task/phrase'
const $ = require('jquery')

export default class Position extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      position: props.position,
      currentValue: props.position.current_value,
      editMode: false,
      additionalMode: false,
      phrases: []
    }
  }

  _saveCurrentValue() {
    this.setState({editMode: false})
  }

  _fetchPhrases() {
    $.ajax({
      method: 'GET',
      url: `${this.props.taskId}/phrases/${this.state.position.id}.json`,
      success: (data) => {
        console.log(data)
        this.setState({phrases: data.phrases, additionalMode: true})
      }
    })
  }

  _renderPhrases() {
    return this.state.phrases.map((phrase) => {
      return <Phrase phrase={phrase} key={phrase.id} />
    })
  }

  render() {
    const position = this.state.position
    return (
      <div className='position'>
        <div className='value'>
          <label>Base value from source</label>
          <textarea readOnly value={position.base_value} rows='3' />
        </div>
        <div className='value'>
          <label>Current value for translation</label>
          <textarea readOnly={!this.state.editMode} value={this.state.currentValue} onChange={(event) => this.setState({currentValue: event.target.value})} rows='3' />
          {this.state.editMode &&
            <a className='button small save_changes' onClick={this._saveCurrentValue.bind(this)}>Save changes</a>
          }
        </div>
        <div className='controls'>
          <label>Controls</label>
          <a className='button small' onClick={() => this.setState({editMode: !this.state.editMode})}>Change edit mode</a>
          <a className='button small' onClick={this._fetchPhrases.bind(this)}>Show additional information</a>
        </div>
        {this.state.additionalMode &&
          <div className='additional'>
            <h3>Composite phrases</h3>
            <p>You can change translation for each separate part of the sentence without special characters</p>
            <div className='phrases'>
              {this._renderPhrases()}
            </div>
          </div>
        }
      </div>
    )
  }
}
