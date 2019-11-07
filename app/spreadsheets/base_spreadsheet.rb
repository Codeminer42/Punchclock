# frozen_string_literal: true

class BaseSpreadsheet
  def initialize(objects)
    @objects = objects
    @book = Spreadsheet::Workbook.new
    @sheet = @book.create_worksheet name: 'worksheet'
  end

  def generate_xls
    set_header
    create_body
    @sheet
  end

  def to_string_io
    generate_xls
    data_to_send = StringIO.new
    @book.write data_to_send
    data_to_send.string
  end

  def header
    raise StandardError 'Not Implemented'
  end

  def body(_object)
    raise StandardError 'Not Implemented'
  end

  private

  def create_body
    @objects.each.with_index do |object, index|
      @sheet.row(index + 1).concat body(object)
    end
  end

  def set_header
    row = @sheet.row(0)
    row.concat(header)

    row.default_format = Spreadsheet::Format.new weight: :bold
  end
end
