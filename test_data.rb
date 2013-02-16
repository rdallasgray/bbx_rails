module Bbx
  module TestData
    def self.zero_pad(i)
      i.to_s.rjust(2, '0')
    end

    def self.random_year(seed)
      seed % 20 + 1994
    end
    
    def self.random_date(seed = 0)
      year = random_year(seed)
      month = zero_pad(seed % 12 + 1)
      "#{year}-#{month}-#{zero_pad(rand(27) + 1)}"
    end

    def self.random_date_range
      d = random_date(rand(16))
      f = "%Y-%m-%d"
      sys_date = Date.strptime(d, f)
      sys_date_to = sys_date + 6.weeks
      [d, sys_date_to.strftime(f)]
    end

    def self.random_datetime(seed = 0)
      "#{random_date(seed)} #{zero_pad(rand(11) + 1)}:#{zero_pad(rand(59))}:#{zero_pad(rand(59))}"
    end

    def self.random_image
      path = "test/fixtures/test_images/seeds/"
      fixture_file_upload(Rails.root.join("#{path}#{zero_pad(rand(19) + 1)}.jpg"), 'image/jpeg;')
    end

    def self.random_bool
      num = rand(2)
      num == 1 ? true : false
    end
  end
end
