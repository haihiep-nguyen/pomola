require 'test_helper'

class TrackingTimesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tracking_time = tracking_times(:one)
  end

  test "should get index" do
    get tracking_times_url
    assert_response :success
  end

  test "should get new" do
    get new_tracking_time_url
    assert_response :success
  end

  test "should create tracking_time" do
    assert_difference('TrackingTime.count') do
      post tracking_times_url, params: { tracking_time: { end_at: @tracking_time.end_at, start_at: @tracking_time.start_at, task_id: @tracking_time.task_id } }
    end

    assert_redirected_to tracking_time_url(TrackingTime.last)
  end

  test "should show tracking_time" do
    get tracking_time_url(@tracking_time)
    assert_response :success
  end

  test "should get edit" do
    get edit_tracking_time_url(@tracking_time)
    assert_response :success
  end

  test "should update tracking_time" do
    patch tracking_time_url(@tracking_time), params: { tracking_time: { end_at: @tracking_time.end_at, start_at: @tracking_time.start_at, task_id: @tracking_time.task_id } }
    assert_redirected_to tracking_time_url(@tracking_time)
  end

  test "should destroy tracking_time" do
    assert_difference('TrackingTime.count', -1) do
      delete tracking_time_url(@tracking_time)
    end

    assert_redirected_to tracking_times_url
  end
end
