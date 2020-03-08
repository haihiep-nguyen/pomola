class Task < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :category
  attr_accessor :command
  has_many :tracking_times, dependent: :destroy
  accepts_nested_attributes_for :tracking_times, allow_destroy: true

  enum status: %i[waiting in_progress done]
end
