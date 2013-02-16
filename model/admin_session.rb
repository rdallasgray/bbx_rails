module Bbx
  module Model
    class AdminSession < ActiveRecord::Base
      belongs_to :user
      
      default_scope :order => 'created_at DESC'
      scope :current, lambda { where("logged_in_at < ? AND logged_out_at IS NULL", Time.now) }

      attr_accessible :logged_in_at, :logged_out_at, :user_id

      before_save :set_login_time_if_new

      def close
        self.logged_out_at = Time.now
        save
      end

      private

      def set_login_time_if_new
        self.logged_in_at = Time.now if new_record?
      end
    end
  end
end
