module Bbx
  module Controller
    class WithParent < Base

      protected

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

      def collection_source
        parent_resource ? parent_resource.send(collection_symbol) : resource_class
      end
    end
  end
end

