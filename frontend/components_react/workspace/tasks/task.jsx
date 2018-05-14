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
            <span>
              <a className='button small' href={`workspace/tasks/${task.id}`}>View task</a>
              <a download={task.result_file_name} className='button small' href={task.link_to_file}>{this.props.strings.download}</a>
            </span>
          }
          {(task.status == 'done' || task.status == 'failed') &&
            <a className='button small alert' onClick={this._handleDelete.bind(this)}>Delete task</a>
          }
        </td>
      </tr>
    )
  }
}
