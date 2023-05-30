class TalkDecorator < Draper::Decorator
  delegate_all

  def date
    model.date.to_date.to_fs(:date)
  end
end
