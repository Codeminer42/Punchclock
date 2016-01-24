import React from 'react';
import Punch from './Punch';

export default function Punches({sheet}) {
  return <ul className="punches">
    { sheet.map( (punch, i)=> <Punch key={i} punch={punch} /> )}
  </ul>
}
