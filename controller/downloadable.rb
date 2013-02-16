module Bbx
  module Controller
    module Downloadable
      def download
        resource = resource_class.find(params[:id])
        extension = File.extname(resource.media.url(:original, :timestamp => false))
        filename = "#{resource.id}_#{resource.subject.to_s.gsub(/[^\w]/, '').underscore}#{extension}"
        data = open(URI.join(request.url, resource.media.url))
        send_data(data.read,
                  :filename => filename,
                  :type     => resource.media_content_type,
                  :x_sendfile => true)
      end
  
      def create
        if request.raw_post.empty?
          render :nothing => true, :status => :no_content and return
        else
          resource = new_resource
          # accommodating both the standard param name coming from bxtension and a testable param
          resource.media = params[:file_data] || params[resource_symbol][:media]
          if (resource.save)
            render :json => resource.to_json, :status => :created, :location => url_for(resource)
          else
            render :json => resource.errors.full_messages, :status => :unprocessable_entity
          end
        end
      end
    end
  end
end
