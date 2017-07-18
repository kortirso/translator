import React from 'react';

class TaskNew extends React.Component {

    constructor() {
        super();
        this.state = {

        }
    }

    _handleSubmit(event) {
        event.preventDefault();
        this.props.addTask();
    }

    render() {
        return (
            <div>
                <form className='task_form' onSubmit={this._handleSubmit.bind(this)}>
                    <div className='task_form_fields'>
                        <h6>{this.props.strings.select}</h6>
                        <select value='da' className='input_field'>
                            <option value="da">Danish</option>
                            <option value="en">English</option>
                            <option value="ru">Russian</option>
                          </select>
                        <h6>{this.props.strings.select_file}</h6>
                    </div>
                    <div className='task_form_actions'>
                        <button type='submit' className='button'>Localize</button>
                    </div>
                </form>
            </div>
        );
    }
}

export default TaskNew;