import React from 'react';
import LocalizedStrings from 'react-localization';
import I18nData from './i18n_data.json';

let strings = new LocalizedStrings(I18nData);

class Task extends React.Component {

    constructor() {
        super();
        this.state = {
            task: {}
        }
    }

    componentWillMount() {
        this.setState({task: this.props.task});
        strings.setLanguage(this.props.locale);
    }

    _checkStatus() {
        if (this.state.task.status == 'failed') return <span>{strings.error}: {this.state.task.error_message}</span>;
        else return this.state.task.status;
    }

    _checkDownloading() {
        if (this.state.task.status == 'done') return <a download={this.state.task.result_short_filename} href={'/uploads/task/result_file/' + this.state.task.id + '/' + this.state.task.result_short_filename}>{strings.download}</a>;
    }

    _checkTranslation() {
        let locale = '';
        if (this.props.locale != 'en') locale = '/' + this.props.locale;
        if (this.state.task.status == 'done') return <a href={locale + '/tasks/' + this.state.task.id}>{strings.goto}</a>;
    }

    _handleDelete(event) {
        event.preventDefault;
        this.props.onDelete(this.state.task);
    }

    render() {
        return (
            <tr className='task' id={'task_' + this.state.task.id}>
                <td>{this.state.task.short_filename}</td>
                <td>{this.state.task.from} - {this.state.task.to}</td>
                <td className={this.state.task.status}>{this._checkStatus()}</td>
                <td>{this._checkDownloading()}</td>
                <td>{this._checkTranslation()}</td>
                <td><a onClick={this._handleDelete.bind(this)}>X</a></td>
            </tr>
        );
    }
}

export default Task;