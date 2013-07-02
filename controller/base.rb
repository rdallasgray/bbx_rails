module Bbx
  module Controller
    class Base < ApplicationController
      include SimpleListFromResource
      include ResourceHelpers
      respond_to :json

      def index
        collection = resource_collection
        collection = simple_list_from_resource(collection) if (params[:list])
        respond(collection_symbol, collection)
      end

      def show
        resource = single_resource
        resource = simple_list_from_resource(resource) if (params[:list])
        respond(resource_symbol, resource)
      end

      def new
        resource = new_resource
        respond(resource_symbol, resource)
      end

      def create
        resource = create_in_collection(params[resource_symbol])
        respond(resource_symbol, resource)
      end

      def update
        resource = single_resource
        resource.attributes = params[resource_symbol]
        resource.save
        respond(resource_symbol, resource)
      end

      def destroy
        resource = single_resource
        resource.destroy
        respond(resource_symbol, resource)
      end
    end
  end
end
