import './opal.rb';
import { OpalDriver } from 'gamefic-driver';

let start = function() {
    var state = Opal.gvars.character.$state();
    var response = JSON.parse(state.$to_json());
    return response;
};

let receive = function (input) {
    Opal.gvars.character.$queue().$push(input);
};

let update = function () {
    Opal.gvars.plot.$update();
    Opal.gvars.plot.$ready();
    var state = Opal.gvars.character.$state();
    var response = JSON.parse(state.$to_json());
    return response;
};

const engine = {
    start: start,
    receive: receive,
    update: update
};
  
const driver = new OpalDriver(engine);
export { driver };
