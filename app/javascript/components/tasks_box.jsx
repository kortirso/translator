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
            url: `api/v1/tasks.json?access_token=${this.props.access_token}`,
            success: (tasks) => {
                this.setState({tasksList: tasks.tasks});
            }
        });
    }

    componentWillMount() {
        this._fetchTasksList();
    }

    _checkDownloading(task) {
        let link;
        if (task.status == 'done') link = <a download={task.result_short_filename} href={'/uploads/task/result_file/' + task.id + '/' + task.result_short_filename}>Download</a>
        return <td>{link}</td>;
    }

    _checkTranslation(task) {
        let link;
        if (task.status == 'done') link = <a href={'/tasks/' + task.id}>Go to translation</a>
        return <td>{link}</td>;
    }

    _prepareTasksList() {
        return this.state.tasksList.map((task) => {
            return (
                <tr className='task' id={"task_" + task.id} key={task.id}>
                    <td>{task.short_filename}</td>
                    <td>{task.from}</td>
                    <td>{task.to}</td>
                    <td className={task.status} >{task.status}</td>
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
                <p>Your Current Tasks</p>
                <table>
                    <thead>
                        <tr>
                            <th>File</th>
                            <th>From</th>
                            <th>To</th>
                            <th>Status</th>
                            <th>Download</th>
                            <th>Translation</th>
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