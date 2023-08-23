import React from "react";
import Punches from "../../../../app/javascript/packs/components/Punches";
import { render, screen } from "@testing-library/react";
import "@testing-library/jest-dom";

describe("when sheet is not empty", () => {
  const sheet = [
    {
      from: "2023-07-31T05:00:00.000-03:00",
      to: "2023-07-31T09:00:00.000-03:00",
      project_id: 3,
      delta: 4,
    },
    {
      from: "2023-07-31T10:00:00.000-03:00",
      to: "2023-07-31T13:00:00.000-03:00",
      project_id: 3,
      delta: 3,
    },
  ];

  it("renders list with worked intervals", () => {
    render(<Punches sheet={sheet} />);

    expect(screen.queryByRole("list")).toBeInTheDocument();
    expect(screen.queryByText("05:00 - 09:00")).toBeInTheDocument();
    expect(screen.queryByText("10:00 - 13:00")).toBeInTheDocument();
  });

  it("renders total worked hours", () => {
    render(<Punches sheet={sheet} />);

    expect(screen.queryByText("Total: 7h")).toBeInTheDocument();
  });
});

describe("when sheet is empty", () => {
  const sheet = [];

  it("doesn't renders list", () => {
    const { container } = render(<Punches sheet={sheet} />);

    expect(container.firstChild).toBeNull();
  });
});
