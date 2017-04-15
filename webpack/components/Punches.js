import React from 'react';
import Punch from './Punch';

class Punches extends React.Component{
  render(){
    return(
      <ul className="punches">
        { this.props.sheet.map((punch, i) =>
         <Punch key={i} punch={punch} />
        )}
      </ul>
    );
  }
}

export default Punches;
