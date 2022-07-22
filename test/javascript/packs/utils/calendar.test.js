import { compareHours } from "../../../../app/javascript/packs/utils/calendar";

describe("calendar", () => {
  describe("compareHours", () => {
    describe("When first hour is greater than second", () => {
      it("returns false", () => {
        const result = compareHours({
          firstHour: "18:00",
          secondHour: "17:00",
        });

        expect(result).toBeFalsy();
      });
    });

    describe("When first hour is less than second", () => {
      it("returns true", () => {
        const result = compareHours({
          firstHour: "17:00",
          secondHour: "18:00",
        });

        expect(result).toBeTruthy();
      });
    });
  });
});
