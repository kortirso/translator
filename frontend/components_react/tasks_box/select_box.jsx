import React from 'react'

class SelectBox extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      isVisible: false
    }
  }

  _onChange(event) {
    this.props.onChangeValue(event.target.value)
  }

  _checkDefaultValue() {
    if(this.props.withoutDisabling) return <span value='' onClick={this._onSelectOption.bind(this, [this.props.withoutDisabling, ''])}>{this.props.withoutDisabling}</span>
  }

  _prepareOptions() {
    if(this.props.frameworks) return this._prepareFrameworks()
    return this._prepareLocales()
  }

  _prepareFrameworks() {
    return this.props.frameworks.map((framework) => {
      return <span value={framework.name} key={framework.id} onClick={this._onSelectOption.bind(this, framework.name)}>{framework.name}</span>
    })
  }

  _prepareLocales() {
    return this.props.locales.map((locale, index) => {
      return <span value={locale[1]} key={index} onClick={this._onSelectOption.bind(this, locale)}>{locale[0]}</span>
    })
  }

  _makeVisible() {
    this.setState({isVisible: !this.state.isVisible})
  }

  _onSelectOption(value) {
    this.props.onChangeValue(value)
    this.setState({isVisible: false})
  }

  render() {
    return (
      <div className='cell small-12 medium-6'>
        <p>{this.props.label}</p>
        <div className='select_box'>
          <div className='selected' onClick={this._makeVisible.bind(this)}>
            <span>{this.props.selected}</span>
          </div>
          {this.state.isVisible &&
            <div className='selector'>
              {this._checkDefaultValue()}
              {this._prepareOptions()}
            </div>
          }
        </div>
      </div>
    )
  }
}

export default SelectBox