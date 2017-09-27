require 'chef/http'

class Chef
  class HTTP

    def stream_to_tempfile(url, response)
      tf = Tempfile.open("chef-rest")
      if Chef::Platform.windows?
        tf.binmode # required for binary files on Windows platforms
      end
      Chef::Log.debug("Streaming download from #{url.to_s} to tempfile #{tf.path}")
      # Stolen from http://www.ruby-forum.com/topic/166423
      # Kudos to _why!

      stream_handler = StreamHandler.new(middlewares, response)

      response.read_body do |chunk|
        tf.write(stream_handler.handle_chunk(chunk))
      end
      tf.close
      tf
    rescue Exception
      tf.close!
      raise
    end

    class StreamHandler
      def handle_chunk(next_chunk)
        @stream_handlers.reverse.inject(next_chunk) do |chunk, handler|
          handler.handle_chunk(chunk)
        end
      end
    end
  end
end
