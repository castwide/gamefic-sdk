import React from 'react';
import { render } from 'react-dom';
import { Console, Terminal } from 'react-gamefic';

import { driver } from 'driver';

import { Activity, Pause, MultipleChoice, Conclusion } from './scenes';
import 'react-gamefic/styles/ebook';
import './style.css';

const sceneComponents = {
	Activity: Activity,
	Pause: Pause,
	MultipleChoice: MultipleChoice,
	YesOrNo: MultipleChoice,
	Conclusion: Conclusion
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
