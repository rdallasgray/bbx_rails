module Bbx
  module Controller
    module ResourceHelpers
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
      
