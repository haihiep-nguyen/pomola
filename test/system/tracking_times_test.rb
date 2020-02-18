require "application_system_test_case"

class TrackingTimesTest < ApplicationSystemTestCase
  setup do
    @tracking_time = tracking_times(:one)
  end

  test "visiting the index" do
    visit tracking_times_url
    assert_selector "h1", text: "Tracking Times"
  end

  test "creating a Tracking time" do
    visit tracking_times_url
    click_on "New Tracking Time"

    fill_in "End at", with: @tracking_time.end_at
    fill_in "Start at", with: @tracking_time.start_at
    fill_in "Task", with: @tracking_time.task_id
    click_on "Create Tracking time"

    assert_text "Tracking time was successfully created"
    click_on "Back"
  end

  test "updating a Tracking time" do
    visit tracking_times_url
    click_on "Edit", match: :first

    fill_in "End at", with: @tracking_time.end_at
    fill_in "Start at", with: @tracking_time.start_at
    fill_in "Task", with: @tracking_time.task_id
    click_on "Update Tracking time"

    assert_text "Tracking time was successfully updated"
    click_on "Back"
  end

  test "destroying a Tracking time" do
    visit tracking_times_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tracking time was successfully destroyed"
  end
end
