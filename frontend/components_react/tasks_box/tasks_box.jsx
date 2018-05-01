import React from 'react'
import Task from 'components_react/tasks_box/task'
import TaskNew from 'components_react/tasks_box/task_new'
import LocalizedStrings from 'react-localization'
import I18nData from './i18n_data.json'
const $ = require('jquery')

let strings = new LocalizedStrings(I18nData)

export default class TasksBox extends React.Component {
  constructor() {
    super()
    this.state = {
      tasksList: [],
      locales: [],
      frameworks: [],
      intervalId: null
    }
  }

  componentWillMount() {
    this._fetchPageData()
    this._runTimer()
    strings.setLanguage(this.props.locale)
  }

  componentWillUnmount() {
    this._stopTimer()
  }

  _runTimer() {
    if(this.state.intervalId != null) return false
    this._timer = setInterval(() => this._fetchTasksList(), 5000)
    this.setState({intervalId: this._timer})
  }

  _stopTimer() {
    clearInterval(this.state.intervalId)
    this.setState({intervalId: null})
  }

  _checkCompleting() {
    let amount = 0
    this.state.tasksList.map((task) => {
      if (task.status == 'verification' || task.status == 'active') amount = amount + 1
    })
    if(amount == 0) this._stopTimer()
  }

  _fetchTasksList() {
    $.ajax({
      method: 'GET',
      url: '/tasks.json',
      success: (data) => {
        this.setState({tasksList: data.tasks})
      }
    })
    this._checkCompleting()
  }

  _fetchPageData() {
    let url = `/${this.props.locale}?format=json`
    if(this.props.locale == 'en') url = `/?format=json`
    $.ajax({
      method: 'GET',
      url: url,
      success: (data) => {
        this.setState({tasksList: data.tasks, locales: data.locales, frameworks: data.frameworks})
      }
    })
    this._checkCompleting()
  }

  _deleteTask(task) {
    $.ajax({
      method: 'DELETE',
      url: `tasks/${task.id}.json`,
      success: (data) => {
        const tasks = [... this.state.tasksList]
        const taskIndex = tasks.indexOf(task)
        tasks.splice(taskIndex, 1)
        this.setState({tasksList: tasks})
      }
    })
  }

  _addTask(data) {
    $.ajax({
      method: 'POST',
      url: 'tasks.json',
      data: data,
      contentType: false,
      processData: false,
      success: (newTask) => {
        this.setState({tasksList: [newTask.task].concat(this.state.tasksList)})
        this._runTimer()
      }
    })
  }

  _prepareTasksBox() {
    if(this.state.tasksList.length <= 0) return false 
    const tasks = this._prepareTasksList()
    return (
      <div id='existed_tasks'>
        <h2>{strings.tasks}</h2>
        <section>
          <table className='stack'>
            <thead>
              <tr>
                <th>{strings.file}</th>
                <th>{strings.direction}</th>
                <th>{strings.status}</th>
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

  _prepareTasksList() {
    return this.state.tasksList.map((task) => {
      return <Task task={task} strings={strings} key={task.id} onDelete={this._deleteTask.bind(this)} />
    })
  }

  render() {
    return (
      <main>
        <section className='block' id='new_file_block'>
          <h2>{strings.start}</h2>
          <TaskNew frameworks={this.state.frameworks} locales={this.state.locales} strings={strings} addTask={this._addTask.bind(this)} />
        </section>
        {this._prepareTasksBox()}
      </main>
    )
  }
}
