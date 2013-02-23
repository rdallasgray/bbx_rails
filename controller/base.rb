module Bbx
  module Controller
    class Base < ApplicationController
      include SimpleListFromResource
      include ResourceHelpers
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
    end
  end
end
