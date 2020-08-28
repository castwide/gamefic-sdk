import React from 'react';
import { ActivityScene, Output, CommandForm } from 'react-gamefic';

export class Activity extends React.Component {
	render() {
		return (
			<ActivityScene>
				<Output {...this.props} transcribe={true} />
				<CommandForm prompt={this.props.state.prompt} />
			</ActivityScene>
		);
	}
}
