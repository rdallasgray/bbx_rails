module Bbx
  module Model
    class Description < ActiveRecord::Base
      extend Bbx::Resource::WithSubject

      validates :text, :length => { :maximum => 2000 }

      default_scope :order => 'created_at DESC'

      attr_accessible :text
    end
  end
end
