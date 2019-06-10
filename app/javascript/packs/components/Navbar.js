import React from 'react';

 const Navbar = ({ onPrev, onNext, hasNext, children, base }) => {
  let nextButton = hasNext? <a onClick={() => {onNext(base)}}> ❯ </a> : null;

  return (
    <h1>
      <a onClick={() => {onPrev(base)}}> ❮ </a>
        {children}
        {nextButton}
    </h1>
  );
};

export default Navbar;
