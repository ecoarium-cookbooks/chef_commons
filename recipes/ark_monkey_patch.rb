

class ::Chef::Resource::Ark
  def checksum(args=nil)
    set_or_return(
      :checksum,
      args,
      :kind_of => String
    )
  end
end