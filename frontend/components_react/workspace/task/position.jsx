import React from 'react'

export default class Position extends React.Component {
  render() {
    const position = this.props.position
    console.log(position)
    return (
      <div className='position'>
        <div className='value'>
          <label>Base value from source</label>
          <textarea readOnly value={position.base_value} rows='3' />
        </div>
        <div className='value'>
          <label>Current value for translation</label>
          <textarea value={position.current_value} rows='3' />
        </div>
      </div>
    )
  }
}
