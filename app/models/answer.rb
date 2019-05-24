# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :evaluation
  belongs_to :question

  validates_presence_of :evaluation, :question, :response
end
