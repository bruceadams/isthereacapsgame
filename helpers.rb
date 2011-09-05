# vi: set fileencoding=utf-8 :
class Caps < Sinatra::Base
  helpers do
    def get_named_day(day_name)
      date = DateTime.strptime(DateTime.now.strftime("%Y%m%d"), fmt="%Y%m%d")
      date = date.next_day
      until date.strftime("%A").upcase == day_name.upcase
        date = date.next_day
      end

      return date
    end

    def get_today
      date = DateTime.now
      return DateTime.strptime(date.strftime("%Y%m%d"), fmt="%Y%m%d")
    end

    def get_tomorrow
      return get_today.next_day
    end

    def get_by_string(wanted)
      begin
        return DateTime.strptime(wanted, fmt="%Y%m%d")
      rescue ArgumentError
        return
      end
    end

    def next_game_from(start)
      start = start.next_day
      # Next game is the first game, if we're before the season starts
      return FIRST_GAME if start < FIRST_GAME

      # Otherwise, keep looking at tomorrow until we have a winner
      while start <= LAST_GAME
        return start if SCHEDULE[start]
        start = start.next_day
      end
    end

    def same_day?(wanted)
      today = DateTime.now.strftime("%A")
      return (today.upcase == wanted.upcase) ? "next" : ""
    end

    def current_page_is?(this_page)
      return request.env['PATH_INFO'] == this_page
    end

    def ovis_birthday?
      return true if @date.strftime("%m%d") == '0917'
    end
  end
end

# Hell if I will install ActiveSupport for just this
# See http://xrl.us/bmbted
class Fixnum
  def ordinalize
    if (11..13).include?(self % 100)
      "#{self}th"
    else
      case self % 10
        when 1; "#{self}st"
        when 2; "#{self}nd"
        when 3; "#{self}rd"
        else    "#{self}th"
      end
    end
  end
end
