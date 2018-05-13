import React from 'react'
import Position from 'components_react/workspace/task/position'
import LocalizedStrings from 'react-localization'
import I18nData from '../../tasks_box/i18n_data.json'
const $ = require('jquery')

let strings = new LocalizedStrings(I18nData)

export default class Task extends React.Component {
  constructor() {
    super()
    this.state = {
      task: {},
      positions: [],
      editable: false
    }
  }

  componentWillMount() {
    this._fetchPageData()
    strings.setLanguage(this.props.locale)
  }

  _fetchPageData() {
    $.ajax({
      method: 'GET',
      url: `${this.props.task_id}.json`,
      success: (data) => {
        this.setState({task: data.task, positions: data.task.positions})
      }
    })
  }

  _deleteTask() {
    $.ajax({
      method: 'DELETE',
      url: `${this.props.task_id}.json`,
      success: (data) => {
      }
    })
  }

  _preparePositions() {
    if(!this.state.editable) return false
    return this.state.positions.map((position) => {
      return <Position position={position} key={position.id} />
    })
  }

  render() {
    const task = this.state.task
    return (
      <main id='task'>
        <h2>Task#{task.id}</h2>
        <a className='button small' onClick={() => this.setState({editable: !this.state.editable})}>Edit translations</a>
        {!this.state.editable &&
          <table className='statistics'>
            <tbody>
              <tr>
                <td>Framework</td>
                <td>{task.framework_name}</td>
              </tr>
              <tr>
                <td>Original language</td>
                <td>{task.from}</td>
              </tr>
              <tr>
                <td>Language of translation</td>
                <td>{task.to}</td>
              </tr>
              <tr>
                <td>Status</td>
                <td>{task.status}</td>
              </tr>
              <tr>
                <td>Amount of sentences</td>
                <td>{task.sentences_amount}</td>
              </tr>
              <tr>
                <td>Created at</td>
                <td>{task.created_at}</td>
              </tr>
              <tr>
                <td>Updated at</td>
                <td>{task.updated_at}</td>
              </tr>
              <tr>
                <td>Controls</td>
                <td>
                  <a download={task.file_name} className='button small expanded' href={task.link_to_source_file}>Download source file</a>
                  <a download={task.result_file_name} className='button small expanded' href={task.link_to_file}>Download result file</a>
                  <a className='button small alert expanded' onClick={this._deleteTask.bind(this)}>Delete task</a>
                </td>
              </tr>
            </tbody>
          </table>
        }
        {this._preparePositions()}
      </main>
    )
  }
}
