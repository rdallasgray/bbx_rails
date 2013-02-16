module Bbx
  module Resource
    module Dated

      def self.extended(base)
        base.class_eval do
          include InstanceMethods
          attr_accessor :active_years
          attr_accessor :last_active_year
          after_save    :invalidate_active_years
          after_save    :invalidate_last_active_year
          after_destroy :invalidate_active_years
          after_destroy :invalidate_last_active_year
        end
      end

      def date_today
        Date.today.strftime("%Y-%m-%d")
      end

      def time_now
        DateTime.now.strftime("%Y-%m-%d %H:%M:S")
      end

      def active_years
        @active_years ||= get_active_years
      end

      def active_years=(years)
        @active_years = years
      end

      def last_active_year
        @last_active_year ||= get_last_active_year
      end

      def last_active_year=(year)
        @last_active_year = year
      end

      def by_year
        all.group_by {|resource| resource.year }
      end

      private

      def validates_partial_date(*attrs)
        validates_each(attrs) do |record, attr, value|
          unless ::Bbx::PartialDate.new(value).valid?
            record.errors.add(attr, "must be a valid partial date")
          end
        end
      end
      
      def year_source
        @year_source ||= :begins_on
      end
      
      def get_active_years
        years = []
        all.each do |resource|
          year = resource.year
          years << year if year && resource.linkable?
        end
        years.uniq
      end

      def get_last_active_year
        active_years.first
      end

      module InstanceMethods

        def year
          pattern = /^[1-2]\d{3}/
          source_name = self.class.send(:year_source)
          source = self.send(source_name.to_sym)
          pattern.match(source).to_s if source =~ pattern
        end

        def invalidate_active_years
          self.class.active_years = nil
        end

        def invalidate_last_active_year
          self.class.last_active_year = nil
        end
      end
    end
  end
end
