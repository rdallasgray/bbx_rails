module Bbx
  module Model
    class Venue < ActiveRecord::Base
      validates :name, :presence => true, :length => { :maximum => 255 }
      validates :city, :presence => true, :length => { :maximum => 255 }
      validates :url,  :length => { :maximum => 255 }
      validates :name, :uniqueness => { :scope => :city }

      default_scope :order => 'name'

      attr_accessible :city, :name, :url
      
      def to_s
        "#{name}, #{city}"
      end
    end
  end
end
