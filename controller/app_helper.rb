module Bbx
  module Controller
    module AppHelper

      def self.extended(base)
        base.class_eval do
          include Bbx::DigestAuth
          include InstanceMethods
          before_filter :authenticate, :only => [:create, :update, :destroy, :new]
          rescue_from Exception, with: :render_500
          rescue_from ActionController::RoutingError, with: :render_404
          rescue_from ActionController::UnknownController, with: :render_404
          rescue_from AbstractController::ActionNotFound, with: :render_404 # To prevent Rails 3.2.8 deprecation warnings
          rescue_from ActiveRecord::RecordNotFound, with: :render_404
        end
      end

      module InstanceMethods

        protected
        
        def render_500(exception = nil)
          render_exception(500, 'Internal server error', exception)
        end

        def render_404(exception = nil)
          render_exception(404, 'Not found', exception)
        end

        def render_exception(status = 500, message = 'Internal server error', exception)
          @status = status
          @message = message

          if exception
            Rails.logger.fatal "\n#{exception.class.to_s} (#{exception.message})"
            Rails.logger.fatal exception.backtrace.join("\n")
          else
            Rails.logger.fatal "No route matches [#{env['REQUEST_METHOD']}] #{env['PATH_INFO'].inspect}"
          end

          respond_to do |format|
            format.json { render :json => { :error => @message }, :status => @status }
            format.html { render :template => "errors/error", status: @status }
          end
        end
      end
    end
  end
end
