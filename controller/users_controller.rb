module Bbx
  module Controller
    class UsersController < Base
      before_filter :except => [:create, :destroy] do
        authenticate_with_privilege_level :staff
      end
      before_filter :only => [:create, :destroy] do
        authenticate_with_privilege_level :admin
      end
      before_filter :only => [:update] do
        sanitize_protected_attrs
      end
      
      private

      def sanitize_protected_attrs
        Rails.logger.info "Current user: #{@current_user.role_name}"
        unless @current_user.has_privilege_level?(:admin)
          Rails.logger.info "Current user may not change role."
          params.delete :role_id
          params[:user].delete :role_id if (params[:user])
        end
        unless @current_user.has_privilege_level?(:admin) || @current_user.id.to_i == params[:id].to_i
          Rails.logger.info "Current user may not change password."
          params.delete :password
          params[:user].delete :password if (params[:user])
        end
      end
    end
  end
end
