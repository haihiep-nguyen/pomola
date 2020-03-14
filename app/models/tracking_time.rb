class TrackingTime < ApplicationRecord
  belongs_to :task

  enum status: %w[starting finished]
  scope :track_today, ->() {where('date(tracking_times.start_at) = CURRENT_DATE OR date(tracking_times.end_at) = CURRENT_DATE')}

end
