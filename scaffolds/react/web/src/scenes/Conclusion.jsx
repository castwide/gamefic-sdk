import React from 'react';
import { ConclusionScene, Output } from 'react-gamefic';

export class Conclusion extends React.Component {
	render() {
		return (
			<ConclusionScene>
				<Output {...this.props} transcribe={true} />
			</ConclusionScene>
		);
	}
}
