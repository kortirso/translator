import React from 'react';
import Task from 'components/tasks_box/task';

class Tasks extends React.Component {

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
                <Task task={task} strings={this.props.strings} key={task.id} onDelete={this._deleteTask.bind(this)} />
            );
        });
    }

    render() {
        const tasks = this._prepareTasksList();
        return (
            <div>
                <p>{this.props.strings.tasks}</p>
                <table>
                    <thead>
                        <tr>
                            <th>{this.props.strings.file}</th>
                            <th>{this.props.strings.direction}</th>
                            <th>{this.props.strings.status}</th>
                            <th>{this.props.strings.download}</th>
                            <th>{this.props.strings.translation}</th>
                            <th></th>
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

export default Tasks;