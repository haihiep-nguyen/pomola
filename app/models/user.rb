class User < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tasks, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :tracking_times, through: :tasks, dependent: :destroy

  def time_spent_today
    tracking_times.track_today.where(status: :finished)&.map { |i| (i.end_at - i.start_at) }.inject(0) { |sum, x| sum + x }
  end
end
