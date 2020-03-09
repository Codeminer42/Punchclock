import React from 'react';

 const Navbar = ({ onPrev, onNext, hasNext, children, base, totalHours }) => {
  return (
    <div className="d-flex align-items-center">
      <h2>
        <a className="nav-arrow mr-1" onClick={() => {onPrev(base)}}> ❮ </a>
        {children}
        {hasNext && <a className="nav-arrow ml-1" onClick={() => {onNext(base)}}> ❯ </a>}
      </h2>
      <h6 className="ml-2">Horas: <b>{totalHours}</b></h6>
    </div>
  );
};

export default Navbar;
