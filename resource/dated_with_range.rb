module Bbx
  module Resource
    module DatedWithRange
      
      def begins_on=(date)
        write_attribute(:begins_on, ::Bbx::PartialDate.new(date).date)
      end
      
      def ends_on=(date)
        write_attribute(:ends_on, ::Bbx::PartialDate.new(date).date)
      end

      private
      
      def ends_on_after_begins_on
        return true if self.ends_on == '0000-00-00' || self.ends_on.nil?
        begins = ::Bbx::PartialDate.new(self.begins_on).to_date
        ends = ::Bbx::PartialDate.new(self.ends_on).to_date
        unless !begins.nil? && !ends.nil? && begins <= ends
          errors.add(:ends_on, "must be after begins_on, or blank")
        end
      end
    end
  end
end
