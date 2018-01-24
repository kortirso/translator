import React from 'react';

let extensions = {'Ruby on Rails': '.yml', 'ReactJS': '.json', 'Laravel': '.json', '.NET': '.resx', 'iOS': '.strings', 'Android': '.xml', 'Yii': '.php'}

class TaskNew extends React.Component {

    constructor() {
        super();
        this.state = {
            framework: null,
            extension: null,
            locale: null,
            data: {},
            fileName: ''
        }
    }

    _handleSubmit(event) {
        event.preventDefault();
        if (this.state.fileName != '' && this.state.locale != null) {
            let data = this.state.data;
            data.append('to', this.state.locale);
            this.props.addTask(data);
        }
    }

    _handleFramework(event) {
        this.setState({framework: event.target.value, extension: extensions[event.target.value]});
    }

    _handleLocale(event) {
        this.setState({locale: event.target.value});
    }

    _handleUploadFile(event) {
        const data = new FormData();
        data.append('file', event.target.files[0]);
        data.append('framework', this.state.framework);
        this.setState({data: data, fileName: event.target.files[0].name});
    }

    _prepareFrameworks() {
        return this.props.frameworks.map((framework) => {
            return (
                <option value={framework.name} key={framework.id}>{framework.name}</option>
            );
        });
    }

    _prepareLocales() {
        return this.props.locales.map((option) => {
            return (
                <option value={option.code} key={option.id}>{option.names[this.props.strings.language]}</option>
            );
        });
    }

    render() {
        const frameworks = this._prepareFrameworks();
        const locales = this._prepareLocales();
        return (
            <form className='task_form' onSubmit={this._handleSubmit.bind(this)}>
                <div className='task_form_fields row'>
                    <div className='columns small-12 medium-4'>
                        <select defaultValue={true} className='input_field' onChange={this._handleFramework.bind(this)}>
                            <option disabled value>Select Framework</option>
                            {frameworks}
                        </select>
                    </div>
                    <div className='columns small-12 medium-4'>
                        <div className='file_uploader'>
                            <label>
                                <input type='file' accept={this.state.extension} onChange={this._handleUploadFile.bind(this)} disabled={this.state.framework == null} />
                                <span>{this.props.strings.select}</span>
                            </label>
                        </div>
                    </div>
                    <div className='columns small-12 medium-4'>
                        <select defaultValue={true} className='input_field' onChange={this._handleLocale.bind(this)} disabled={this.state.framework == null || this.state.fileName == ''}>
                            <option disabled value>Select Language</option>
                            {locales}
                        </select>
                    </div>
                    <div className='columns small-12 medium-4 medium-offset-4'>
                        <h6>{this.state.fileName}</h6>
                    </div>
                    <div className='columns small-12 medium-4 end'>
                        <button type='submit' className='button'>{this.props.strings.localize}</button>
                    </div>
                </div>
            </form>
        );
    }
}

export default TaskNew;