module HolidaysHelper
  def parse_date_range(date_range)
    dates = date_range.split(' - ')

    start_date = Date.parse(dates[0])
    end_date = Date.parse(dates[1])

    return [start_date] if start_date == end_date

    (start_date..end_date).to_a
  end
end
