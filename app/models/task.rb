class Task < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :category
  attr_accessor :command

  enum status: %i[waiting in_progress done]
end
