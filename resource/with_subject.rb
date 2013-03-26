module Bbx
  module Resource
    module WithSubject

      def self.extended(base)
        base.class_eval do
          belongs_to :subject, :polymorphic => true
        end
      end
    end
  end
end
