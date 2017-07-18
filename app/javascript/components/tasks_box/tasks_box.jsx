import React from 'react';
import Tasks from 'components/tasks_box/tasks';
import TaskNew from 'components/tasks_box/task_new';
import LocalizedStrings from 'react-localization';
import I18nData from './i18n_data.json';

let strings = new LocalizedStrings(I18nData);

class TasksBox extends React.Component {

    constructor() {
        super();
        this.state = {

        }
    }

    componentWillMount() {
        strings.setLanguage(this.props.locale);
    }

    render() {
        return (
            <div className='row'>
                <div className='columns small-12 medium-8 large-6'>
                    <div className='block'>
                        <TaskNew strings={strings} />
                    </div>
                </div>
                <div className='columns small-12'>
                    <div className='block'>
                        <Tasks access_token={this.props.access_token} email={this.props.email} strings={strings} />
                    </div>
                </div>
            </div>
        );
    }
}

export default TasksBox;