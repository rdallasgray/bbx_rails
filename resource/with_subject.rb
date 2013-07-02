module Bbx
  module Resource
    module WithSubject

      def self.extended(base)
        base.class_eval do
          belongs_to :subject, :polymorphic => true
          validates :subject_id, :presence => true
          validates :subject_type, :presence => true
          validates :subject, :associated => true
        end
      end
    end
  end
end
