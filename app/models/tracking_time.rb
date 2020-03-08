class TrackingTime < ApplicationRecord
  belongs_to :task

  enum status: %w[starting finished]
end
