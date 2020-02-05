import React from 'react';

 const Navbar = ({ onPrev, onNext, hasNext, children, base, totalHours }) => {
  let nextButton = hasNext? <a className="ml-1" onClick={() => {onNext(base)}}> ❯ </a> : null;

  return (
    <div className="d-flex align-items-center">
      <h2>
        <a className="mr-1" onClick={() => {onPrev(base)}}> ❮ </a>
        {children}
        {nextButton}
      </h2>
      <h6 className="ml-2"> Horas: <b>{totalHours}</b></h6>
    </div>
  );
};

export default Navbar;
