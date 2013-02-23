module Bbx
  module Controller
    module SimpleListFromResource
      def simple_list_from_resource(resource, label_method = :to_s)
        if resource.respond_to?('map')
          resource.map do |element|
            { :id => element.id, :label => element.send(label_method) }
          end
        else
          { :id => resource.id, :label => resource.send(label_method) }
        end
      end
    end
  end
end
