module Bbx
  module Controller
    module Downloadable
      def download
        resource = resource_class.find(params[:id])
        send_media(resource)
      end

      def create
        if request.raw_post.empty?
          render :nothing => true, :status => :no_content and return
        else
          resource = new_resource
          # accommodate both the bxtension param 'file_data', and a testable param
          resource.media = params[:file_data] || params[resource_symbol][:media]
          # force render :json --otherwise we get a 406
          @image = resource
          if (resource.save)
            render json: resource.to_json, status: :created, location: url_for(resource)
          else
            render json: resource.errors.full_messages, status: :unprocessable_entity
          end
        end
      end

      private

      def filename_for(resource)
        extension = File.extname(resource.media.url(:original, :timestamp => false))
        subject = resource.subject.to_s.gsub(/[^\w]/, '').underscore
        "#{resource.id}_#{subject}#{extension}"
      end

      def send_media(resource)
        send_data(get_data(resource),
                  :filename => filename_for(resource),
                  :type     => resource.media_content_type,
                  :x_sendfile => true)
      end

      def get_data(resource)
        open(URI.join(request.url, resource.media.url)).read
      end
    end
  end
end
