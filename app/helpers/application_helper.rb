module ApplicationHelper
  def get_hms(total_seconds)
    hours = (total_seconds / (60 * 60)).round
    minutes = ((total_seconds / 60) % 60).round
    seconds = (total_seconds % 60).round
    if seconds == 60
      minutes += 1
      seconds = 0
    end
    if minutes == 60
      hours += 1
      minutes = 0
    end
    return {
        hours: hours.to_s.rjust(2,'0'),
        minutes: minutes.to_s.rjust(2,'0'),
        seconds: seconds.to_s.rjust(2,'0')
    }
  end
end
