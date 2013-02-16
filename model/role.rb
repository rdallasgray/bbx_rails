module Bbx
  module Model
    class Role < ActiveRecord::Base
      has_many :users

      validates_uniqueness_of :name

      default_scope :order => 'privilege_level'
      
      attr_accessible :name, :privilege_level

      def to_sym
        name.to_sym
      end

      def to_s
        name
      end
    end
  end
end
