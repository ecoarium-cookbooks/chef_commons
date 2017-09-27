
require 'digest/sha1'

class Chef
  class Resource
    class File < Chef::Resource
      def checksum(args=nil)
        set_or_return(
          :checksum,
          args,
          :kind_of => String
        )
      end
    end
  end
end
