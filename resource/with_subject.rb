module Bbx
  module Resource
    module WithSubject

      def self.extended(base)
        base.class_eval do
          include InstanceMethods
          belongs_to :subject, :polymorphic => true
          validates :subject_type, :presence => true
          validates :subject_id,   :presence => true
          validate  :subject_exists
        end
      end

      module InstanceMethods

        private

        def subject_exists
          subject_class = Kernel.const_get(self.subject_type)
          subject = subject_class.find(self.subject_id)
        rescue
          errors.add(:subject_id, "was not found")
        end
      end
    end
  end
end
