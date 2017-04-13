import React from 'react';

export default function WeekNames({weekdays}) {
  return <thead><tr>{weekdays.map((n, i)=> <th key={i}>{n}</th>)}</tr></thead>
}
