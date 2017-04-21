import React from 'react';

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
            url: `tasks.json`,
            success: (tasks) => {
                this.setState({tasksList: tasks.tasks});
            }
        });
    }

    componentWillMount() {
        this._fetchTasksList();
    }

    _prepareTasksList() {
        return this.state.tasksList.map((task) => {
            return (
                <tr className='task' id={"task_" + task.id} key={task.id}>
                    <td>{task.short_filename}</td>
                    <td>{task.from}</td>
                    <td>{task.to}</td>
                    <td className={task.status} >{task.status}</td>
                    <td><a download={task.result_short_filename} href={'/uploads/task/result_file/' + task.id + '/' + task.result_short_filename}>Download</a></td>
                </tr>
            );
        });
    }

    render() {
        const tasks = this._prepareTasksList();
        return (
            <div>
                <p>Your Current Tasks</p>
                <table>
                    <thead>
                        <tr>
                            <th>File</th>
                            <th>From</th>
                            <th>To</th>
                            <th>Status</th>
                            <th>Download</th>
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