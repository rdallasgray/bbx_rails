module Bbx
  module Controller
    class SingleWithParent < WithParent

      protected

      def create_in_collection(attributes)
        parent_resource.send("create_#{resource_symbol.to_s}".to_sym, attributes)
      end

      def single_resource
        if parent_resource
          parent_resource.send(resource_symbol) or new_resource
        else
          resource_class.find(params[:id])
        end
      end

      def new_resource
        if parent_resource
          parent_resource.send("build_#{resource_symbol.to_s}".to_sym)
        else
          collection_source.new
        end
      end
    end
  end
end
