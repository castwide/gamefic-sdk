import React from 'react';
import { render } from 'react-dom';
import { Console, Terminal } from 'react-gamefic';
import { driver } from 'driver';
import 'react-gamefic/styles/ebook';
import './style.css';

render(
	<Console driver={driver}>
		<Terminal />
	</Console>,
	document.getElementById('root')
);
