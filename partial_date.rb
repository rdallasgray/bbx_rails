module Bbx
  class PartialDate

    def initialize(date_string)
      @input_date_string = date_string
    end

    def date
      partial_date_from_string(@input_date_string)
    end

    def time
      partial_time_from_string(@input_date_string)
    end

    def datetime
      partial_datetime_from_string(@input_date_string)
    end

    def to_date
      full_datetime_string = datetime
      return nil if full_datetime_string == self.class.nil_datetime
      date_format_parts = self.class.date_format_parts.select do |k, v|
        @valid_date_parts[k]
      end
      date_format = date_format_parts.values.join("-")
      time_format = @valid_date_parts.length == 3 ? self.class.time_format : ""
      format = [date_format, time_format].join(" ")
      date_string = @valid_date_parts.values.join("-")
      time_string = time_format.empty? ? "" : time
      datetime_string = [date_string, time_string].join(" ")
      Rails.logger.info "#{datetime_string}, #{format}"
      DateTime.strptime(datetime_string, format)
    end
    
    def valid?
      !to_date.nil?
    end
    
    def valid_date_parts(date_string=@input_date_string)
      @valid_date_parts ||=
        begin
          return {} unless date_string =~ self.class.date_pattern
          parts = date_string.split("-")
          valid_parts = { :year => parts[0] }
          valid_parts[:month] = parts[1] if valid_month?(parts[1])
          valid_parts[:day] = parts[2] if valid_date?(date_string)
          valid_parts
        end
    end

    def valid_time_parts(time=nil)
      @valid_time_parts ||=
        begin
          return {} unless time =~ self.class.time_pattern
          parts = time.split(":")
          valid_parts = {}
          if valid_hour?(parts[0])
            valid_parts[:hour] = parts[0]
            valid_parts[:meridian] = meridian(parts[0])
            if valid_minute_or_second?(parts[1])
              valid_parts[:minute] = parts[1]
              valid_parts[:second] = parts[2] if valid_minute_or_second?(parts[2])
            end
          end
          valid_parts
        end
    end
    
    private

    def self.date_format_parts
      { :year => "%Y", :month => "%m", :day => "%d" }
    end

    def self.time_format_parts
      { :hour => "%H", :minute => "%M", :second => "%S" }
    end

    def self.date_format
      @date_format ||= self.date_format_parts.values.join("-")
    end

    def self.time_format
      @time_format ||= self.time_format_parts.values.join(":")
    end

    def self.date_pattern
      /[1-2]\d{3}-\d\d-\d\d/
    end

    def self.time_pattern
      /[0-2]\d:\d\d:\d\d/    
    end
    
    def self.nil_date_parts
      { :year => "0000", :month => "00", :day => "00" }
    end

    def self.nil_time_parts
      { :hour => "00", :minute => "00", :second => "00" }
    end

    def self.nil_date
      @nil_date ||= self.nil_date_parts.values.join("-")
    end

    def self.nil_time
      @nil_time ||= self.nil_time_parts.values.join(":")
    end

    def self.nil_datetime
      @nil_datetime ||= "#{self.nil_date} #{self.nil_time}"
    end
    
    def meridian(hour)
      if hour.to_i < 12 then "am" else "pm" end
    end
    
    def partial_date_from_string(date_string)
      @partial_date ||=
        begin
          date_string = self.class.date_pattern.match(date_string).to_s
          date_parts = self.class.nil_date_parts.merge(valid_date_parts(date_string))
          date_parts.values.join("-")
        end
    end

    def partial_time_from_string(time_string)
      @partial_time ||=
        begin
          time_string = normalize(time_string).split(" ")[-1]
          return self.class.nil_time unless time_string =~ self.class.time_pattern
          time_parts = self.class.nil_time_parts.merge(valid_time_parts(time_string))
          time_parts.values.join(":")
        end
    end

    def normalize(datetime_string)
      datetime_string.gsub(/[T|Z]/, " ").gsub(/[^\d]*$/, "")
    end

    def partial_datetime_from_string(datetime_string)
      @partial_datetime ||=
        begin
          datetime_string = normalize(datetime_string)
          parts = datetime_string.split(" ")
          date = partial_date_from_string(parts[0])
          time_part = parts[1] || ""
          time = partial_time_from_string(time_part)
          "#{date} #{time}"
        end
    end
    
    def valid_month?(month)
      (1..12).include?(month.to_i)
    end

    def valid_date?(date_string)
      begin
        date = Date.strptime(date_string, self.class.date_format)
        date.strftime(self.class.date_format) == date_string
      rescue
        false
      end
    end

    def valid_hour?(hour)
      (0..23).include?(hour.to_i)
    end

    def valid_minute_or_second?(m_or_s)
      (0..59).include?(m_or_s.to_i)
    end
  end
end
