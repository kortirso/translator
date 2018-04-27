import React from 'react'

class SelectBox extends React.Component {
  _onChange(event) {
    this.props.onChangeValue(event.target.value)
  }

  _checkDefaultValue() {
    if(this.props.withoutDisabling) return <option value>{this.props.withoutDisabling}</option>
    return <option disabled value></option>
  }

  render() {
    return (
      <div className='cell small-12 medium-6'>
        <p>{this.props.label}</p>
        <select defaultValue={true} className='input_field' onChange={this._onChange.bind(this)}>
          {this._checkDefaultValue()}
          {this.props.options}
        </select>
      </div>
    )
  }
}

export default SelectBox