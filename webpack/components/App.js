import React from 'react';
import Calendar from './Calendar';
import { dayBase } from '../application';

class App extends React.Component{
  render(){
    return(
      <Calendar
        date={`${this.props.match.params.year}-${this.props.match.params.month}-${dayBase}`}
      />
    );
  }
}

export default App;
