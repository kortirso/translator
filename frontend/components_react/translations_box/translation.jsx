import React from 'react';

class Translation extends React.Component {

    constructor() {
        super();
        this.state = {
            translation: {}
        }
    }

    componentWillMount() {
        this.setState({verified: this.props.translation.verified});
    }

    _handleChange() {
        this.props.updateVerification(this.props.translation.id, !this.state.verified);
        this.setState({verified: !this.state.verified});
    }

    render() {
        return (
            <div className='translation_text'>
                <input type='checkbox' value='1' defaultChecked={this.state.verified} name='translation[open_all_day]' id={'translation_' + this.props.translation.id} onChange={this._handleChange.bind(this)} />
                <label htmlFor={'translation_' + this.props.translation.id}>{this.props.translation.result_text}</label>
            </div>
        );
    }
}

export default Translation;