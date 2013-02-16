module Bbx
  module Controller
    class AdminController < ApplicationController
      include Bbx::DigestAuth
      respond_to :json
      before_filter :except => 'index' do
        authenticate
      end

      def index
        redirect_to '/Bxs/app/xul/main.xul'
      end

      def login
        if @current_user.admin_sessions.create
          render :json => { id: @current_user.id }, :status => :ok
        else 
          render :json => @current_user.admin_sessions.errors, :status => :internal_server_error
        end
      end

      def logout
        if @current_user.current_admin_session.close
          render :nothing => true, :status => :ok
        else 
          render :json => @current_user.admin_sessions.errors, :status => :internal_server_error
        end
      end
    end
  end
end
