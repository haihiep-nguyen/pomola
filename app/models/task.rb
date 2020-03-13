class Task < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :category
  attr_accessor :command
  has_many :tracking_times, dependent: :destroy
  accepts_nested_attributes_for :tracking_times, allow_destroy: true

  enum status: %i[waiting in_progress done]

  attr_accessor :time_counting
  validates_uniqueness_of :serial, scope: :user

  def time_counting
    total_time = 0
    has_running = false
    if self.tracking_times.present?
      time_tracked = self.tracking_times.where(status: :finished)
      if time_tracked.present?
        tracked_second = 0
        time_tracked.each do |item|
          tracked_second += (item.end_at - item.start_at)
        end
        total_time += tracked_second
      end
      time_tracking = self.tracking_times.find_by(status: :starting)
      if time_tracking.present?
        has_running = true
        total_time += Time.now - time_tracking.start_at
      end
    end
    return {total_time: total_time, has_running: has_running}
  end
end
