# frozen_string_literal: true

class Question < ApplicationRecord
  extend Enumerize
  attr_reader :raw_answer_options

  belongs_to :questionnaire
  has_many   :answers

  validates_presence_of :title, :kind
  validate :raw_answer_options_must_be_present, if: :answer_options_needed?

  enumerize :kind, in: { 
    multiple_choice: 0 
    },  scope: :shallow,
        predicates: true

  def raw_answer_options=(answer)
    self.answer_options = answer.split(';').map(&:strip).reject(&:empty?)
  end

  def raw_answer_options_must_be_present
    errors.add(:raw_answer_options, :blank) unless answer_options.present?
  end

  def answer_options_to_string
    answer_options.join('; ')
  end

  def answer_options_needed?
    multiple_choice?
  end
end
