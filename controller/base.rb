module Bbx
  module Controller
    class Base < ApplicationController
      respond_to :json

      def index
        collection = resource_collection
        collection = simple_list_from_resource(collection) if (params[:list])
        set_resource_instance_variable(collection_symbol, collection)
        respond_with collection
      end

      def show
        resource = single_resource
        resource = simple_list_from_resource(resource) if (params[:list])
        set_resource_instance_variable(resource_symbol, resource)
        respond_with resource
      end

      def new
        resource = new_resource
        set_resource_instance_variable(resource_symbol, resource)
        respond_with resource
      end
      
      def create
        resource = collection_source.create(params[resource_symbol])
        set_resource_instance_variable(resource_symbol, resource)
        respond_with resource
      end

      def update
        resource = single_resource
        resource.update_attributes(params[resource_symbol])
        set_resource_instance_variable(resource_symbol, resource)
        respond_with resource
      end

      def destroy
        resource = single_resource
        resource.destroy
        set_resource_instance_variable(resource_symbol, resource)
        respond_with resource
      end

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

      def resource_class
        @resource_class ||= Kernel.const_get(controller_name.classify)
      end

      def resource_symbol
        @resource_symbol ||= resource_class.name.downcase.to_sym
      end

      def collection_symbol
        resource_symbol.to_s.pluralize.to_sym
      end

      def set_resource_instance_variable(sym, resource)
        instance_variable_set("@#{sym.to_s}", resource)
      end

      def new_resource
        collection_source.new
      end

      def collection_source
        resource_class
      end

      def single_resource
        resource_class.find(params[:id])
      end

      def resource_collection
        collection_source.all
      end
    end
  end
end
