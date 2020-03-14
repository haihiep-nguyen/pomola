class Category < ApplicationRecord
  belongs_to :user, optional: true
  has_many :tasks

  validates_uniqueness_of :name, scope: :user
end
