import React from 'react';
import LocalizedStrings from 'react-localization';
import I18nData from './i18n_data.json';

let strings = new LocalizedStrings(I18nData);

class TasksBox extends React.Component {

    constructor() {
        super();
        this.state = {
            tasksList: []
        }
    }

    _fetchTasksList() {
        $.ajax({
            method: 'GET',
            url: `api/v1/tasks.json?access_token=${this.props.access_token}`,
            success: (tasks) => {
                this.setState({tasksList: tasks.tasks});
            }
        });
        this._checkCompleting();
    }

    componentWillMount() {
        this._fetchTasksList();
        strings.setLanguage(this.props.locale);
    }

    componentDidMount() {
        this._timer = setInterval(() => this._fetchTasksList(), 5000);
        this.setState({intervalId: this._timer});
    }

    componentWillUnmount() {
        clearInterval(this.state.intervalId);
    }

    _checkCompleting() {
        let amount = 0;
        this.state.tasksList.map((task) => {
            if (task.status == 'active') amount = amount + 1;
        });
        if (amount == 0) clearInterval(this.state.intervalId);
    }

    _checkStatus(task) {
        let status = task.status;
        if (task.status == 'failed') status = <span>{strings.error}: {task.error_message}</span>;
        return <td className={task.status}>{status}</td>
    }

    _checkDownloading(task) {
        let link;
        if (task.status == 'done') link = <a download={task.result_short_filename} href={'/uploads/task/result_file/' + task.id + '/' + task.result_short_filename}>{strings.download}</a>
        return <td>{link}</td>;
    }

    _checkTranslation(task) {
        let link;
        let locale = '';
        if (this.props.locale != 'en') locale = '/' + this.props.locale;
        if (task.status == 'done') link = <a href={locale + '/tasks/' + task.id}>{strings.goto}</a>
        return <td>{link}</td>;
    }

    _prepareTasksList() {
        return this.state.tasksList.map((task) => {
            return (
                <tr className='task' id={"task_" + task.id} key={task.id}>
                    <td>{task.short_filename}</td>
                    <td>{task.from}</td>
                    <td>{task.to}</td>
                    {this._checkStatus(task)}
                    {this._checkDownloading(task)}
                    {this._checkTranslation(task)}
                </tr>
            );
        });
    }

    render() {
        const tasks = this._prepareTasksList();
        return (
            <div>
                <p>{strings.tasks}</p>
                <table>
                    <thead>
                        <tr>
                            <th>{strings.file}</th>
                            <th>{strings.from}</th>
                            <th>{strings.to}</th>
                            <th>{strings.status}</th>
                            <th>{strings.download}</th>
                            <th>{strings.translation}</th>
                        </tr>
                    </thead>
                    <tbody>
                        {tasks}
                    </tbody>
                </table>
            </div>
        );
    }
}

export default TasksBox;