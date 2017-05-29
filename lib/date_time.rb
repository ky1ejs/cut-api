module RelativeDate
  def relative_time_string(options = {})
    options = {scope: :'datetime.distance_in_words'}.merge!(options)

    distance_in_days = (self.to_datetime.beginning_of_day - DateTime.now)
    abs_distance_in_days = distance_in_days.abs.floor
    abs_distance_in_days += 1 if distance_in_days > 0

    I18n.with_options locale: options[:locale], scope: options[:scope] do |locale|
      case abs_distance_in_days
      when 0...1 then 'today'
      when 1...2 then distance_in_days > 0 ? 'tomorrow' : 'yesterday'
      when 2...28
        days = locale.t :x_days, count: abs_distance_in_days
        distance_in_days > 0 ? "in #{days}" : "#{days} ago"
      when 28...365
        months = locale.t :x_months, count: abs_distance_in_days / 28
        distance_in_days > 0 ? "in #{months}" : "#{months} ago"
      else
        years = locale.t :about_x_years, count: abs_distance_in_days / 365
        distance_in_days > 0 ? "in #{years}" : "#{years} ago"
      end
    end
  end
end

class DateTime
  include RelativeDate
end

class Date
  include RelativeDate
end

class Time
  include RelativeDate
end
