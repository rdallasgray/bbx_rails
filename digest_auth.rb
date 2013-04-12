module ActionController::HttpAuthentication::Digest
  alias_method :validate_nonce, :old_validate_nonce

  def validate_nonce(secret_key, request, value, seconds_to_timeout=5*60)
    old_validate_nonce(secret_key, request, value, seconds_to_timeout=50*60)
  end
end

module Bbx
  module DigestAuth

    private

    def authenticate
      Rails.logger.debug "authenticating"
      authenticate_with_privilege_level :staff
    end
    
    def authenticate_with_privilege_level(role_name)
      authenticate_user {|user| user.has_privilege_level?(role_name)}
    end

    def authenticate_user(&check_privilege)
      if !user_authenticated?(check_privilege)
        request_http_digest_authentication(User::DIGEST_REALM)
      end
    end

    def user_authenticated?(check_privilege)
      user = nil
      result = authenticate_with_http_digest(User::DIGEST_REALM) do |username|
        user = User.find_by_username(username)
        return nil if user.nil?
        user.password
      end
      result = result && check_privilege.call(user) unless check_privilege.nil?
      @current_user = user if result
    end
  end
end
