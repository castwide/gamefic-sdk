import React from 'react';
import { Output, CommandLink, CommandForm } from 'react-gamefic';

export class PauseScene extends React.Component {
	render() {
		return (
			<div className="PauseScene">
				<Output {...this.props} />
				<CommandLink command="">Continue</CommandLink>
			</div>
		);
	}
}
