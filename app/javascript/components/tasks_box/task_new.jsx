import React from 'react';

class TaskNew extends React.Component {

    constructor() {
        super();
        this.state = {
            locales: [],
            locale: 'da',
            data: {}
        }
    }

    componentWillMount() {
        this._fetchLocales();
    }

    _fetchLocales() {
        $.ajax({
            method: 'GET',
            url: `api/v1/locales.json`,
            success: (data) => {
                this.setState({locales: data.locales});
            }
        });
    }

    _handleSubmit(event) {
        event.preventDefault();
        let data = this.state.data;
        data.append('to', this.state.locale);
        this.props.addTask(data);
    }

    _handleLocale(event) {
        this.setState({locale: event.target.value});
    }

    _handleUploadFile(event) {
        const data = new FormData();
        data.append('file', event.target.files[0]);
        this.setState({data: data});
    }

    _prepareOptions() {
        return this.state.locales.map((option) => {
            return (
                <option value={option.code} key={option.id}>{option.names[this.props.strings.language]}</option>
            );
        });
    }

    _prepareDefaultValue() {
        if (this.state.locales.length > 0) return this.state.locales[0].names[this.props.strings.language];
    }

    render() {
        const options = this._prepareOptions();
        const defaultValue = this._prepareDefaultValue();
        return (
            <div>
                <form className='task_form' onSubmit={this._handleSubmit.bind(this)}>
                    <div className='task_form_fields'>
                        <h6>{this.props.strings.select}</h6>
                        <select defaultValue={defaultValue} className='input_field' onChange={this._handleLocale.bind(this)}>
                            {options}
                          </select>
                        <h6>{this.props.strings.select_file}</h6>
                        <input type="file" onChange={this._handleUploadFile.bind(this)} />
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