module Bbx
  module Resource
    module Imageable

      def has_images?
        !self.images.empty?
      end

      def media
        return nil if !self.has_images?
        self.images.first.media
      end
    end
  end
end
