import React from 'react'

const extensions = {'Ruby on Rails': '.yml', 'ReactJS': '.json', 'Laravel': '.json', '.NET': '.resx', 'iOS': '.strings', 'Android': '.xml', 'Yii': '.php'}

export default class TaskNew extends React.Component {
  constructor() {
    super()
    this.state = {
      framework: null,
      extension: null,
      localeFrom: '',
      localeTo: '',
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

  _handleFramework(event) {
    this.setState({framework: event.target.value, extension: extensions[event.target.value]})
  }

  _handleLocaleFrom(event) {
    this.setState({localeFrom: event.target.value})
  }

  _handleLocaleTo(event) {
    this.setState({localeTo: event.target.value})
  }

  _handleUploadFile(event) {
    const data = new FormData()
    data.append('file', event.target.files[0])
    data.append('framework', this.state.framework)
    this.setState({data: data, fileName: event.target.files[0].name})
  }

  _prepareFrameworks() {
    return this.props.frameworks.map((framework) => {
      return (
        <option value={framework.name} key={framework.id}>{framework.name}</option>
      )
    })
  }

  _prepareLocales() {
    return this.props.locales.map((locale) => {
      return (
        <option value={locale.code} key={locale.id}>{locale.names[this.props.strings._language]}</option>
      )
    })
  }

  render() {
    return (
      <form className='task_form' onSubmit={this._handleSubmit.bind(this)}>
        <div className='task_form_fields grid-x'>
          <div className='cell small-12 medium-6'>
            <p>Выберите фреймворк</p>
            <select defaultValue={true} className='input_field' onChange={this._handleFramework.bind(this)}>
              <option disabled value></option>
              {this._prepareFrameworks()}
            </select>
          </div>
          <div className='cell small-12 medium-6'>
            <p>Загрузите файл для локализации</p>
            <div className='file_uploader'>
              <label>
                <input type='file' accept={this.state.extension} onChange={this._handleUploadFile.bind(this)} disabled={this.state.framework == null} />
                <span>{this.state.fileName || this.props.strings.select}</span>
              </label>
            </div>
          </div>
          <div className='cell small-12 medium-6'>
            <p>Язык оригинала</p>
            <select defaultValue={true} className='input_field' onChange={this._handleLocaleFrom.bind(this)}>
              <option value>Автоопределение</option>
              {this._prepareLocales()}
            </select>
          </div>
          <div className='cell small-12 medium-6'>
            <p>Язык перевода</p>
            <select defaultValue={true} className='input_field' onChange={this._handleLocaleTo.bind(this)}>
              <option disabled value></option>
              {this._prepareLocales()}
            </select>
          </div>
          <div className='cell small-12 medium-2 medium-offset-10'>
            <button type='submit' className='button'>{this.props.strings.localize}</button>
          </div>
        </div>
      </form>
    )
  }
}
