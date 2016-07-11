require 'mime/types'

module Moneywire
  module Resources
    class Uploads < BaseResource
      use_resource 'uploads'
      DEFAULT_BOUNDARY = 'MultipartBoundaryMW'.freeze

      def required_documents(document_type, file_path)
        uri = "#{self.class.resource_name}/required-documents/#{document_type}"
        uri += "?actingFor=#{acting_for}" if acting_for
        request_handler.post(
          full_file_upload_uri_for(uri),
          request_body(file_path),
          file_upload_options
        )
      end

      private

      def file_upload_options
        { headers: { 'Content-Type' => "multipart/form-data; boundary=#{DEFAULT_BOUNDARY}" } }
      end

      def full_file_upload_uri_for(uri)
        Moneywire.file_upload_uri_for(environment) + uri
      end

      def request_body(file_path)
        filename = File.basename(file_path)
        file_content = File.open(file_path, 'rb', &:read)

        "--#{DEFAULT_BOUNDARY}\r\n" \
        "Content-Disposition: form-data; name=\"file\"; filename=\"#{filename}\"\r\n" \
        "Content-Type: #{mime_for(file_path)}\r\n" \
        "#{file_content}\r\n" \
        "--#{DEFAULT_BOUNDARY}--"
      end

      def mime_for(path)
        mime = MIME::Types.type_for(path)
        mime.empty? ? 'text/plain' : mime[0].content_type
      end
    end
  end
end
