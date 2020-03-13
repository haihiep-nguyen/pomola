class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = current_user.tasks.where(archived: false).order(created_at: :asc).group_by(&:category)
    @archived_tasks = current_user.tasks.where(archived: true).order(created_at: :asc)
  end
end
