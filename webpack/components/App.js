import React from 'react';
import Calendar from './Calendar';

class App extends React.Component{
  render(){
    const { dayBase, year, month } = this.props;
    return(
      <Calendar
        date={`${year}-${month}-${dayBase}`}
      />
    );
  }
}

export default App;
