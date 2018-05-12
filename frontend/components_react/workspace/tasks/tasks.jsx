import React from 'react'
import Task from 'components_react/workspace/tasks/task'
import LocalizedStrings from 'react-localization'
import I18nData from '../../tasks_box/i18n_data.json'
const $ = require('jquery')

let strings = new LocalizedStrings(I18nData)

export default class Tasks extends React.Component {
  constructor() {
    super()
    this.state = {
      tasksList: []
    }
  }

  componentWillMount() {
    this._fetchPageData()
    strings.setLanguage(this.props.locale)
  }

  _fetchPageData() {
    let url = `/${this.props.locale}/workspace.json`
    if(this.props.locale == 'en') url = `/workspace.json`
    $.ajax({
      method: 'GET',
      url: url,
      success: (data) => {
        this.setState({tasksList: data.tasks})
      }
    })
  }

  _deleteTask(task) {
    $.ajax({
      method: 'DELETE',
      url: `../tasks/${task.id}.json`,
      success: (data) => {
        const tasks = [... this.state.tasksList]
        const taskIndex = tasks.indexOf(task)
        tasks.splice(taskIndex, 1)
        this.setState({tasksList: tasks})
      }
    })
  }

  _prepareTasksBox() {
    if(this.state.tasksList.length <= 0) return false
    return (
      <div id='workspace_tasks'>
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
              {this._prepareTasksList()}
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
        {this._prepareTasksBox()}
      </main>
    )
  }
}
