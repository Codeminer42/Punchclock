import React from 'react';

 const Navbar = ({ onPrev, onNext, hasNext, children, base }) => {
  const nextButton = hasNext && <a onClick={() => {onNext(base)}}> ❯ </a>

  return (
    <h1>
      <a onClick={() => {onPrev(base)}}> ❮ </a>
        {children}
        {nextButton}
    </h1>
  );
};

export default Navbar;
