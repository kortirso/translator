import React from 'react';

class TaskNew extends React.Component {

    constructor() {
        super();
        this.state = {
            locales: [],
            locale: '',
            data: {},
            fileName: ''
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
                this.setState({locales: data.locales, locale: data.locales[0]['code']});
            }
        });
    }

    _handleSubmit(event) {
        event.preventDefault();
        if (this.state.fileName != '') {
            let data = this.state.data;
            data.append('to', this.state.locale);
            this.props.addTask(data);
        }
    }

    _handleLocale(event) {
        this.setState({locale: event.target.value});
    }

    _handleUploadFile(event) {
        const data = new FormData();
        data.append('file', event.target.files[0]);
        this.setState({data: data, fileName: event.target.files[0].name});
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
            <form className='task_form' onSubmit={this._handleSubmit.bind(this)}>
                <div className='task_form_fields row'>
                    <div className='columns small-12 medium-4'>
                        <div className='file_uploader'>
                            <label>
                                <input type="file" onChange={this._handleUploadFile.bind(this)} />
                                <span>{this.props.strings.select}</span>
                            </label>
                        </div>
                        <h6>{this.state.fileName}</h6>
                    </div>
                    <div className='columns small-12 medium-4'>
                        <select defaultValue={defaultValue} className='input_field' onChange={this._handleLocale.bind(this)}>
                            {options}
                        </select>
                    </div>
                    <div className='columns small-12 medium-4'>
                        <button type='submit' className='button'>{this.props.strings.localize}</button>
                    </div>
                </div>
            </form>
        );
    }
}

export default TaskNew;