import React from 'react';
import { PauseScene, Output, CommandLink } from 'react-gamefic';

export class Pause extends React.Component {
	render() {
		return (
			<PauseScene>
				<Output {...this.props} transcribe={true} />
				<CommandLink command="">Continue</CommandLink>
			</PauseScene>
		);
	}
}
