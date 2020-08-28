import React from 'react';
import { MultipleChoice, ChoiceList } from 'react-gamefic';

export class MultipleChoice extends React.Component {
	render() {
		return (
			<MultipleChoiceScene>
				<Output {...this.props} transcribe={true} />,
				<ChoiceList options={this.props.state.options} prompt={this.props.state.prompt} />
			</MultipleChoiceScene>
		);
	}
}
