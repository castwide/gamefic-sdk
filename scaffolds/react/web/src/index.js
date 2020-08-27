import React from 'react';
import { render } from 'react-dom';
import { Console, Terminal } from 'react-gamefic';

import { driver } from 'driver';

import { ActivityScene, PauseScene, MultipleChoiceScene, ConclusionScene } from './scenes';
import 'react-gamefic/styles/ebook';
import './style.css';

const sceneComponents = {
	Activity: ActivityScene,
	Pause: PauseScene,
	MultipleChoice: MultipleChoiceScene,
	YesOrNo: MultipleChoiceScene,
	Conclusion: ConclusionScene
}

render(
	<Console driver={driver}>
		<Terminal sceneComponents={sceneComponents} autoScroll={true} />
	</Console>,
	document.getElementById('root')
);

driver.start().then((state) => {
	driver.notify(state);
});
