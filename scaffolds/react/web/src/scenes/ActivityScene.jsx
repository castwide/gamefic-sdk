import React from 'react';
import { Output, CommandForm } from 'react-gamefic';

export class ActivityScene extends React.Component {
	render() {
		return (
			<div className="ActivityScene">
				<Output {...this.props} />
				<CommandForm prompt={this.props.state.prompt} />
			</div>
		);
	}
}
