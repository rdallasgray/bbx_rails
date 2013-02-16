module Bbx
  module Controller
    module Downloadable
      def download
        resource = resource_class.find(params[:id])
        extension = File.extname(resource.media.url(:original, :timestamp => false))
        filename = "#{resource.id}_#{resource.subject.to_s.gsub(/[^\w]/, '').underscore}#{extension}"
        data = open(resource.media.url)
        send_data(data.read,
                  :filename => filename,
                  :type     => resource.media_content_type,
                  :x_sendfile => true)
      end
    end
  end
end
