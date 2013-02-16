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
        
        def simple_list_from_resource(resource, label_method = :to_s)
          if resource.respond_to?('map')
            resource.map do |element|
              { :id => element.id, :label => element.send(label_method) }
            end
          else
            { :id => resource.id, :label => resource.send(label_method) }
          end
        end

        def parent_resource
          if (@parent_resource == nil)
            foreign_keys = params.keys.select do |k|
              # key is foreign if it matches *_id and is not included in the wrapped params
              /\w+_id$/ =~ k && (!params[resource_symbol] || !params[resource_symbol].include?(k))
            end
            if (!foreign_keys.empty?)
              parent_key = foreign_keys[0]
              class_name = parent_key[0..-4].classify
              @parent_resource = Kernel.const_get(class_name).find(params[parent_key])
            else
              @parent_resource = false
            end
          end
          @parent_resource
        end

        def resource_class
          @resource_class ||= Kernel.const_get(controller_name.classify)
        end

        def resource_symbol
          @resource_symbol ||= resource_class.name.downcase.to_sym
        end

        def new_resource
          resource_class.new
        end
        
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
