class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def command
    command = task_params[:command]
    result = parse_command(command)
    @error = false
    @message
    if result
      if result[:action] == 'create_task'
        @task_category = result[:category]
        @task_category = '@uncategorized' unless @task_category.present?
        @task_description = result[:task_description]
        @task_serial = 1
        @last_serial = Task.last.try(:serial)
        @task_serial = @last_serial + 1 if @last_serial.present?
        ActiveRecord::Base.transaction do
          @category = Category.find_by(name: @task_category)
          @user = User.last
          unless @category.present?
            @category = Category.new(name: @task_category, user: @user)
            if @category.save

            else
              @error = true
              @message = @category.errors.full_messages.to_sentence
              raise ActiveRecord::Rollback
            end
          end
          @new_task = Task.new(serial: @task_serial,
                              description: @task_description,
                              category: @category,
                              user_id: 1,
                              status: :waiting)
          if @new_task.save

          else
            @error = true
            @message = @new_task.errors.full_messages.to_sentence
            raise ActiveRecord::Rollback
          end
        end
      elsif result[:action] == 'begin_task'
        task_serial = result[:task]
        @task = Task.find_by(serial: task_serial)
        @task_tracking_times = @task.tracking_times.pluck(:id)
        current_starting = @task.tracking_times.find_by(status: :starting)
        if current_starting.nil?
          ActiveRecord::Base.transaction do
            if @task_tracking_times.size == 0
              @task.start_at = Time.zone.now
            end
            @task.status = :in_progress
            if @task.save
              @start_at = Time.zone.now
              task_new_tracking = @task.tracking_times.new(start_at: Time.zone.now)
              if task_new_tracking.save
                @start_at = Time.zone.now
                @message = 'continue'
              else
                @error = true
                @message = task_new_tracking.errors.full_messages.to_sentence.inspect
              end
            else
              @error = true
              @message = @task.errors.full_messages.to_sentence
              raise ActiveRecord::Rollback
            end
          end
        else
          @error = true
          @message = 'started before'
        end
      elsif result[:action] == 'stop_task'
        task_serial = result[:task]
        @task = Task.find_by(serial: task_serial)
        current_starting = @task.tracking_times.find_by(status: :starting)
        ActiveRecord::Base.transaction do
          if current_starting.present?
            if current_starting.update(status: :finished, end_at: Time.zone.now)
              @end_at = current_starting.end_at
              @message = "stop tracking on #{task_serial}"
            else
              @error = true
              @message = current_starting.errors.full_messages.to_sentence
              raise ActiveRecord::Rollback
            end
          else
            @error = true
            @message = 'cannot find any tracking time'
            raise ActiveRecord::Rollback
          end
        end
      elsif result[:action] == 'check_task'
        task_serial = result[:task]
        @task = Task.find_by(serial: task_serial)
        if @task.status == 'done'
          @error = true
          @message = 'task done before'
        else
          current_starting = @task.tracking_times.find_by(status: :starting)
          ActiveRecord::Base.transaction do
            if current_starting.present?
              if current_starting.update(status: :finished, end_at: Time.zone.now)
                @end_at = current_starting.end_at
                if @task.update(end_at: Time.zone.now, status: :done)
                  @end_at = @task.end_at
                  @message = "task #{task_serial} checked"
                else
                  @error = true
                  @message = @task.errors.full_message.to_sentence.inspect
                  raise ActiveRecord::Rollback
                end
              else
                @error = true
                @message = current_starting.errors.full_messages.to_sentence
                raise ActiveRecord::Rollback
              end
            else
              if @task.update(end_at: Time.zone.now, status: :done)
                @end_at = @task.end_at
                @message = "task #{task_serial} checked"
              else
                @error = true
                @message = @task.errors.full_message.to_sentence.inspect
                raise ActiveRecord::Rollback
              end
            end
          end
        end
      elsif result[:action] == 'edit_task'
        task_serial = result[:task]
        @task = Task.find_by(serial: task_serial)
        ActiveRecord::Base.transaction do
          if @task.present?
            if @task.update(description: result[:task_description])
              @message = 'changed description'
            else
              @error = true
              @message = @task.errors.full_messages.to_sentence.inspect
              raise ActiveRecord::Rollback
            end
          else
            @error = true
            @message = 'cannot find task'
            raise ActiveRecord::Rollback
          end
        end
      elsif result[:action] == 'delete_task'
        task_serial = result[:task]
        @task = Task.find_by(serial: task_serial)
        ActiveRecord::Base.transaction do
          if @task.present?
            if @task.destroy
            else
              @error = true
              @message = @task.errors.full_messages.to_sentence
              raise ActiveRecord::Rollback
            end
          else
            @error = true
            @message = 'cannot find task'
            raise ActiveRecord::Rollback
          end
        end
      end
    else
      @error = true
    end
    if @error
      respond_to do |format|
        format.js {render 'shared/error', locals: {error: @error, message: @message}}
      end
    else
      if result[:action] == 'create_task'
        respond_to do |format|
          format.js {render 'tasks/new', locals: {task: @new_task, category: @new_task.category}}
        end
      elsif result[:action] == 'begin_task'
        respond_to do |format|
          format.js {render 'tasks/update', locals: {task: @task, start_at: @start_at, message: @message}}
        end
      elsif result[:action] == 'stop_task'
        respond_to do |format|
          format.js {render 'tasks/update', locals: {task: @task, end_at: @end_at, message: @message}}
        end
      elsif result[:action] == 'check_task'
        respond_to do |format|
          format.js {render 'tasks/update', locals: {task: @task, end_at: @end_at, message: @message}}
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:name, :description, :start_at, :end_at, :user_id, :category_id, :command)
    end
end
