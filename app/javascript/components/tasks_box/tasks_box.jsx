import React from 'react';
import Task from 'components/tasks_box/task';
import TaskNew from 'components/tasks_box/task_new';
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
            url: `api/v1/tasks.json?access_token=${this.props.access_token}&email=${this.props.email}`,
            success: (data) => {
                this.setState({tasksList: data.tasks});
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

    _deleteTask(task) {
        $.ajax({
            method: 'DELETE',
            url: `api/v1/tasks/${task.id}.json?access_token=${this.props.access_token}`,
            success: (data) => {
                if(data.status == 'success') {
                    const tasks = [... this.state.tasksList];
                    const taskIndex = tasks.indexOf(task);
                    tasks.splice(taskIndex, 1);
                    this.setState({tasksList: tasks});
                }
            }
        })
    }

    _prepareTasksList() {
        return this.state.tasksList.map((task) => {
            return (
                <Task task={task} strings={strings} key={task.id} onDelete={this._deleteTask.bind(this)} />
            );
        });
    }

    render() {
        const tasks = this._prepareTasksList();
        return (
            <div className='row'>
                <div className='columns small-12 medium-8 large-6'>
                    <div className='block'>
                        <TaskNew access_token={this.props.access_token} email={this.props.email} strings={strings} />
                    </div>
                </div>
                <div className='columns small-12'>
                    <div className='block'>
                        <p>{strings.tasks}</p>
                        <table>
                            <thead>
                                <tr>
                                    <th>{strings.file}</th>
                                    <th>{strings.direction}</th>
                                    <th>{strings.status}</th>
                                    <th>{strings.download}</th>
                                    <th>{strings.translation}</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                {tasks}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        );
    }
}

export default TasksBox;