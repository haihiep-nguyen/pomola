class HomeController < ApplicationController
  # before_action :authenticate_user!

  def index
    return redirect_to signin_path unless current_user.present?
    @tasks = current_user.tasks.includes(:category).where(archived: false).order(created_at: :asc).group_by(&:category)
    @archived_tasks = current_user.tasks.includes(:category).where(archived: true).order(created_at: :asc).group_by(&:category)

    @today_tasks = current_user.tracking_times.includes(:task).track_today.order(created_at: :asc)
  end
end
