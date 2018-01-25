import React from 'react';

class Task extends React.Component {

  _checkStatus() {
    if (this.props.task.status == 'failed') return <span>{this.props.strings.error}: {this.props.task.error_message}</span>;
    else return this.props.task.status;
  }

  _checkDownloading() {
    if (this.props.task.status == 'done') return <a download={this.props.task.result_short_filename} href={'/uploads/task/result_file/' + this.props.task.id + '/' + this.props.task.result_short_filename}>{this.props.strings.download}</a>;
  }

  _checkTranslation() {
    let locale = '';
    if (this.props.strings.language != 'en') locale = '/' + this.props.strings.language;
    if (this.props.task.status == 'done') return <a href={locale + '/tasks/' + this.props.task.id}>{this.props.strings.goto}</a>;
  }

  _handleDelete(event) {
    event.preventDefault;
    this.props.onDelete(this.props.task);
  }

  render() {
    return (
      <tr className='task' id={'task_' + this.props.task.id}>
        <td>{this.props.task.short_filename}</td>
        <td>{this.props.task.to}</td>
        <td className={this.props.task.status}>{this._checkStatus()}</td>
        <td>{this._checkDownloading()}</td>
        <td>{this._checkTranslation()}</td>
        <td><a onClick={this._handleDelete.bind(this)}>X</a></td>
      </tr>
    );
  }
}

export default Task;