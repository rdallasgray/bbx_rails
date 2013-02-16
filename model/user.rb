require 'digest/md5'

module Bbx
  module Model
    class User < ActiveRecord::Base
      DIGEST_REALM = 'user@example.com'
      
      belongs_to :role
      has_many   :admin_sessions
      
      validates :username, :presence => true, :uniqueness => true
      validates :password, :presence => true
      validates :role_id, :presence => true
      validate  :role_exists

      default_scope :order => 'username'
      
      attr_accessible :username, :password, :role_id

      before_save { |user| digest_encrypt_password(user) }

      def role_name
        role.name
      end

      def has_privilege_level?(role_name)
        role = Role.find_by_name(role_name.to_s)
        privilege_level = role.privilege_level
        self.role.privilege_level <= privilege_level
      end

      def most_recent_admin_session
        self.admin_sessions.first
      end

      def current_admin_session
        self.admin_sessions.current.first
      end

      def as_json(options = nil)
        hash = super(options)
        hash[:password] = ""
        hash
      end

      private

      def digest_encrypt_password(user)
        if password_changed? || username_changed?
          username = user.username || self.username
          self.password = Digest::MD5.hexdigest([username, self.class::DIGEST_REALM, user.password].join(':')).to_s
        end
      end
      
      def role_exists
        role = Role.find(self.role_id)
      rescue
        errors.add(:role_id, "was not found")
      end
    end
  end
end
