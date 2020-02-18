class TrackingTimesController < ApplicationController
  before_action :set_tracking_time, only: [:show, :edit, :update, :destroy]

  # GET /tracking_times
  # GET /tracking_times.json
  def index
    @tracking_times = TrackingTime.all
  end

  # GET /tracking_times/1
  # GET /tracking_times/1.json
  def show
  end

  # GET /tracking_times/new
  def new
    @tracking_time = TrackingTime.new
  end

  # GET /tracking_times/1/edit
  def edit
  end

  # POST /tracking_times
  # POST /tracking_times.json
  def create
    @tracking_time = TrackingTime.new(tracking_time_params)

    respond_to do |format|
      if @tracking_time.save
        format.html { redirect_to @tracking_time, notice: 'Tracking time was successfully created.' }
        format.json { render :show, status: :created, location: @tracking_time }
      else
        format.html { render :new }
        format.json { render json: @tracking_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tracking_times/1
  # PATCH/PUT /tracking_times/1.json
  def update
    respond_to do |format|
      if @tracking_time.update(tracking_time_params)
        format.html { redirect_to @tracking_time, notice: 'Tracking time was successfully updated.' }
        format.json { render :show, status: :ok, location: @tracking_time }
      else
        format.html { render :edit }
        format.json { render json: @tracking_time.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracking_times/1
  # DELETE /tracking_times/1.json
  def destroy
    @tracking_time.destroy
    respond_to do |format|
      format.html { redirect_to tracking_times_url, notice: 'Tracking time was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tracking_time
      @tracking_time = TrackingTime.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tracking_time_params
      params.require(:tracking_time).permit(:task_id, :start_at, :end_at)
    end
end
