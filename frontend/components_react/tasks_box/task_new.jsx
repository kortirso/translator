import React from 'react'
import SelectBox from 'components_react/tasks_box/select_box'

const extensions = {'Ruby on Rails': '.yml', 'ReactJS': '.json', 'Laravel': '.json', '.NET': '.resx', 'iOS': '.strings', 'Android': '.xml', 'Yii': '.php'}

export default class TaskNew extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      framework: null,
      extension: null,
      localeFrom: '',
      localeFromFull: props.strings.auto,
      localeTo: '',
      localeToFull: '',
      data: {},
      fileName: ''
    }
  }

  _handleSubmit(event) {
    event.preventDefault();
    if (this.state.fileName != '' && this.state.localeTo != '') {
      let data = this.state.data
      data.append('from', this.state.localeFrom)
      data.append('to', this.state.localeTo)
      this.props.addTask(data)
    }
  }

  _handleFramework(value) {
    this.setState({framework: value, extension: extensions[value]})
  }

  _handleLocaleFrom(value) {
    this.setState({localeFrom: value[1], localeFromFull: value[0]})
  }

  _handleLocaleTo(value) {
    this.setState({localeTo: value[1], localeToFull: value[0]})
  }

  _handleUploadFile(event) {
    const data = new FormData()
    data.append('file', event.target.files[0])
    data.append('framework', this.state.framework)
    this.setState({data: data, fileName: event.target.files[0].name})
  }

  render() {
    const strings = this.props.strings
    return (
      <form className='task_form' onSubmit={this._handleSubmit.bind(this)}>
        <div className='task_form_fields grid-x'>
          <SelectBox label={strings.framework + ' *'} frameworks={this.props.frameworks} selected={this.state.framework} onChangeValue={this._handleFramework.bind(this)} />
          <div className='cell small-12 medium-6'>
            <p>{strings.loadFile + ' *'}</p>
            <div className='file_uploader'>
              <label>
                <input type='file' accept={this.state.extension} onChange={this._handleUploadFile.bind(this)} disabled={this.state.framework == null} />
                <span>{this.state.fileName || strings.select}</span>
              </label>
            </div>
          </div>
          <SelectBox label={strings.original} locales={this.props.locales} selected={this.state.localeFromFull} withoutDisabling={strings.auto} onChangeValue={this._handleLocaleFrom.bind(this)} />
          <SelectBox label={strings.translation + ' *'} locales={this.props.locales} selected={this.state.localeToFull} onChangeValue={this._handleLocaleTo.bind(this)} />
          <div className='cell small-12 medium-3 medium-offset-9'>
            <button type='submit' className='button'>{strings.localize}</button>
          </div>
        </div>
      </form>
    )
  }
}
