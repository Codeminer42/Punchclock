import React from "react";
import Punch from "./Punch";
import { isEmpty } from "lodash";

const Punches = ({ sheet }) => {
  if (isEmpty(sheet)) return null;

  const totalWorkedHours = sheet.reduce(
    (total, current) => (total += current.delta),
    0
  );

  return (
    <ul className="punches">
      {sheet.map((punch, i) => (
        <Punch key={i} punch={punch} />
      ))}
      <li>Total: {totalWorkedHours}h</li>
    </ul>
  );
};

export default Punches;
