import React from 'react';
import { Output } from 'react-gamefic';
import { CommandLink } from 'react-gamefic';

export class MultipleChoiceScene extends React.Component {
	renderChoices() {
		if (this.props.state.options) {
			const listItems = this.props.state.options.map((opt, index) => {
				return (
					<li key={index}>
						<CommandLink command={opt}>{opt}</CommandLink>
					</li>
				);
			});
			return (
				<nav>
					<ol>
						{listItems}
					</ol>
				</nav>
			);
		} else {
			console.warn("Error: Multiple choice scene does not have any options");
			return '';
		}
	}

	render() {
		return (
			<div className="MultipleChoiceScene">
				<Output {...this.props} />
				<label>{this.props.state.prompt}</label>
				{this.renderChoices()}
			</div>
		);
	}
}
