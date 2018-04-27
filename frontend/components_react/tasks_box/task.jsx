import React from 'react'

class Task extends React.Component {
  _checkStatus() {
    if (this.props.task.status == 'failed') return <span>{this.props.strings.error}: {this.props.task.error_message}</span>
    else return this.props.task.status
  }

  _checkDownloading() {
    if (this.props.task.status == 'done') return <a download={this.props.task.result_file_name} className='button' href={this.props.task.link_to_file}>{this.props.strings.download}</a>
  }

  _handleDelete(event) {
    event.preventDefault
    this.props.onDelete(this.props.task)
  }

  render() {
    return (
      <tr className='task' id={'task_' + this.props.task.id}>
        <td>{this.props.task.result_file_name}</td>
        <td>{this.props.task.from}-{this.props.task.to}</td>
        <td className={this.props.task.status}>{this._checkStatus()}</td>
        <td>{this._checkDownloading()}</td>
        <td><a onClick={this._handleDelete.bind(this)}>X</a></td>
      </tr>
    )
  }
}

export default Task