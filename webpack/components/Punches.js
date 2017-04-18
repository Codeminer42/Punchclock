import React from 'react';
import Punch from './Punch';

const Punches = ({ sheet }) => {
  return (
    <ul className="punches">
      { sheet.map((punch, i) =>
       <Punch key={i} punch={punch} />
      )}
    </ul>
  );
};

export default Punches;
