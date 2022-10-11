# frozen_string_literal: true

class DefaultSpreadsheet
  def initialize(objects)
    @objects = objects
    @package = Axlsx::Package.new
    @book = @package.workbook
  end

  def generate_xlsx
    @book.add_worksheet(name: 'worksheet') do |sheet|
      add_header(sheet)
      add_body(sheet)
    end
  end

  def to_string_io
    generate_xlsx

    @package.to_stream.read.force_encoding('UTF-8')
  end

  def header
    raise StandardError 'Not Implemented'
  end

  def body(_object)
    raise StandardError 'Not Implemented'
  end

  private

  def add_header(sheet)
    header_style = @book.styles.add_style b: true
    sheet.add_row header, style: header_style
  end

  def add_body(sheet)
    @objects.each do |object|
      sheet.add_row body(object)
    end

    sheet
  end

  def translate_date(date)
    return if date.nil?

    I18n.l(date, format: :long)
  end

  def translate_enumerize(enumerize)
    enumerize&.text
  end
end
