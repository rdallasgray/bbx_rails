module Bbx
  module Controller
    class SingleWithParent < WithParent

      protected

      def single_resource
        if parent_resource
          parent_resource.send(resource_symbol)
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
