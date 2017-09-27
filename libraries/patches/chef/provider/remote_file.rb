
require 'digest/sha1'

class Chef
  class Provider
    class RemoteFile < Chef::Provider::File

      def checksum(file)
        if @new_resource.checksum.nil? or @new_resource.checksum.size == 64
          Chef::Digester.checksum_for_file(file)
        elsif @new_resource.checksum.size == 40
          checksum_file(file, Digest::SHA1.new)
        else
          Chef::Application.fatal! "unable to determine the what type of checksum #{@new_resource.checksum} is"
        end
      end

      def checksum_file(file, digest)
        ::File.open(file, 'rb') { |f| checksum_io(f, digest) }
      end

      def checksum_io(io, digest)
        while chunk = io.read(1024 * 8)
          digest.update(chunk)
        end
        digest.hexdigest
      end
    end
  end
end
