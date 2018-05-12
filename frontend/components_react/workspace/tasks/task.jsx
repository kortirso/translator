import React from 'react'

export default class Task extends React.Component {
  _checkStatus(task) {
    if (task.status == 'failed') return <span>{this.props.strings.error}: {task.error_message}</span>
    return task.status
  }

  _handleDelete(event) {
    event.preventDefault
    this.props.onDelete(this.props.task)
  }

  render() {
    const task = this.props.task
    return (
      <tr className='task' id={'task_' + task.id}>
        <td>{task.result_file_name}</td>
        <td>{task.from}-{task.to}</td>
        <td className={task.status}>{this._checkStatus(task)}</td>
        <td>
          {task.status == 'done' &&
            <a download={task.result_file_name} className='button' href={task.link_to_file}>{this.props.strings.download}</a>
          }
          {(task.status == 'done' || task.status == 'failed') &&
            <a className='button alert' onClick={this._handleDelete.bind(this)}>X</a>
          }
        </td>
      </tr>
    )
  }
}
