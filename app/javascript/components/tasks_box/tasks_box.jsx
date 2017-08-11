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

    componentWillMount() {
        this._fetchTasksList();
        this._runTimer();
        strings.setLanguage(this.props.locale);
    }

    componentWillUnmount() {
        clearInterval(this.state.intervalId);
    }

    _runTimer() {
        this._timer = setInterval(() => this._fetchTasksList(), 5000);
        this.setState({intervalId: this._timer});
    }

    _checkCompleting() {
        let amount = 0;
        this.state.tasksList.map((task) => {
            if (task.status == 'active') amount = amount + 1;
        });
        if (amount == 0) clearInterval(this.state.intervalId);
    }

    _checkEndpoint() {
        if (this.props.email == '') return 'guest';
        else return 'tasks';
    }

    _checkEmail() {
        if (this.props.email == '') return '';
        else return `&email=${this.props.email}`;
    }

    _fetchTasksList() {
        $.ajax({
            method: 'GET',
            url: `api/v1/${this._checkEndpoint()}.json?access_token=${this.props.access_token}${this._checkEmail()}`,
            success: (data) => {
                this.setState({tasksList: data.tasks});
            }
        });
        this._checkCompleting();
    }

    _deleteTask(task) {
        $.ajax({
            method: 'DELETE',
            url: `api/v1/${this._checkEndpoint()}/${task.id}.json?access_token=${this.props.access_token}${this._checkEmail()}`,
            success: (data) => {
                const tasks = [... this.state.tasksList];
                const taskIndex = tasks.indexOf(task);
                tasks.splice(taskIndex, 1);
                this.setState({tasksList: tasks});
            }
        })
    }

    _addTask(data) {
        $.ajax({
            method: 'POST',
            url: `/api/v1/${this._checkEndpoint()}.json?access_token=${this.props.access_token}${this._checkEmail()}`,
            data: data,
            contentType: false,
            processData: false,
            success: (newTask) => {
                this.setState({tasksList: [newTask.task].concat(this.state.tasksList)});
                this._runTimer();
            }
        });
    }

    _prepareTasksBox() {
        if (this.state.tasksList.length > 0) {
            const tasks = this._prepareTasksList();
            return (
                <div className='columns small-10 small-offset-1 end'>
                    <section className='block'>
                        <table className='stack'>
                            <thead>
                                <tr>
                                    <th>{strings.file}</th>
                                    <th>{strings.direction}</th>
                                    <th>{strings.status}</th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                {tasks}
                            </tbody>
                        </table>
                    </section>
                </div>
            )
        }
    }

    _prepareTasksList() {
        return this.state.tasksList.map((task) => {
            return (
                <Task task={task} strings={strings} key={task.id} onDelete={this._deleteTask.bind(this)} />
            );
        });
    }

    render() {
        return (
            <main className='platforms without_back'>
                <div className='row'>
                    <div className='columns small-10 medium-8 small-offset-1 medium-offset-2'>
                        <section className='block' id='new_file_block'>
                            <TaskNew access_token={this.props.access_token} email={this.props.email} strings={strings} addTask={this._addTask.bind(this)} />
                        </section>
                    </div>
                    {this._prepareTasksBox()}
                </div>
            </main>
        );
    }
}

export default TasksBox;