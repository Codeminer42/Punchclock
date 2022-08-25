import moment from 'moment';
import { compareHours, prev, next, current, innerRange, startDate } from "../../../../app/javascript/packs/utils/calendar";

const formattedDate = (date) => date.format('YYYY-MM-DD');
const CURRENT_DATE = '2022-08-15'



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

  describe("current", () => {
    beforeAll(() => {
      jest.useFakeTimers('modern').setSystemTime(new Date(CURRENT_DATE))
    })
    afterAll(() => {
      jest.useRealTimers()
    })

    it('returns current date', () => {
      const result = current()
      const formattedResult = formattedDate(result)

      expect(formattedResult).toBe(CURRENT_DATE)
    })
    it('returns current date in UTC', () => {
      expect(current().isUTC()).toBe(true)
    })
  })

  describe("prev", () => {
    const baseDate = moment('2022-08-01').utc()
    it('returns previous month in same day', () => {
      const result = prev(baseDate)
      const formattedResult = formattedDate(result)

      expect(formattedResult).toBe('2022-07-01')
    });
  });

  describe("next", () => {
    const baseDate = moment('2022-08-01').utc()
    it('returns next month in same day', () => {
      const result = next(baseDate)
      const formattedResult = formattedDate(result)

      expect(formattedResult).toBe('2022-09-01')
    });
  });

  describe("innerRange", () => {
    beforeAll(() => {
      jest.useFakeTimers('modern').setSystemTime(new Date(CURRENT_DATE))
    })
    afterAll(() => {
      jest.useRealTimers()
    })

    describe('when the base date month is the same as current date', () => {
      const baseDate = moment('2022-08-01').utc()
      it('returns a range from base date until current date', () => {
        const [from, to] = innerRange(baseDate)
        const formattedFromResult = formattedDate(from)
        const formattedToResult = formattedDate(to)

        expect(formattedFromResult).toBe('2022-08-01')
        expect(formattedToResult).toBe(CURRENT_DATE)
      });
    });

    describe("when the base date is one or more month(s) older than current date", () => {
      const baseDate = moment('2022-06-01').utc()
      it('returns a range from base date until one day before next month', () => {
        const [from, to] = innerRange(baseDate)
        const formattedFromResult = formattedDate(from)
        const formattedToResult = formattedDate(to)

        expect(formattedFromResult).toBe('2022-06-01')
        expect(formattedToResult).toBe('2022-06-30')
      });
    })
  });

  describe('startDate', () => {
    it('returns the date of first day of the week relative to base date', () => {
      const baseDate = moment('2022-07-1', 'YYYY-MM-DD').utc()

      const result = startDate(baseDate)
      const formattedResult = formattedDate(result)
      expect(formattedResult).toBe('2022-06-26')
    });
  });
});
