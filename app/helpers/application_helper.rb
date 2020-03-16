module ApplicationHelper
  def get_hms(total_seconds)
    total_seconds = 0 unless total_seconds.present?
    seconds = (total_seconds % 60).round
    reduce_seconds = total_seconds - seconds
    minutes = ((reduce_seconds / 60) % 60).round
    reduce_minutes = reduce_seconds - minutes.minute.seconds
    hours = (reduce_minutes / (60 * 60)).round
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

  def hms(total_seconds)
    hms = get_hms(total_seconds)
    "#{hms[:hours]}:#{hms[:minutes]}:#{hms[:seconds]}"
  end
end
