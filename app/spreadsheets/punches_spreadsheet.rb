# frozen_string_literal: true

class PunchesSpreadsheet
  def initialize(punches)
    @punches = punches
    @book = Spreadsheet::Workbook.new
    @sheet = @book.create_worksheet name: 'Punches'
  end

  def generate_xls
    set_header
    create_body

    data_to_send = StringIO.new
    @book.write data_to_send
    data_to_send.string
  end

  private

  def create_body
    @punches.each.with_index do |punch, index|
      @sheet.row(index + 1).concat [punch.user.name,
                                    punch.project.name,
                                    punch.when,
                                    punch.from,
                                    punch.to,
                                    punch.delta,
                                    I18n.t(punch.extra_hour),
                                    punch.comment]
    end
  end

  def set_header
    @sheet.row(0).concat %W[#{User.human_attribute_name('name')}
                            #{Punch.human_attribute_name('project')}
                            #{Punch.human_attribute_name('when')}
                            #{Punch.human_attribute_name('from')}
                            #{Punch.human_attribute_name('to')}
                            #{Punch.human_attribute_name('delta')}
                            #{Punch.human_attribute_name('extra_hour')}
                            #{Punch.human_attribute_name('comment')}]

    @sheet.row(0).default_format = Spreadsheet::Format.new weight: :bold
  end
end
