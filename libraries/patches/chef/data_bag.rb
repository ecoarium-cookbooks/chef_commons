require 'pp'
require 'chef/data_bag'
require 'chef/data_bag_item'
require 'chef/dsl/data_query'

class Chef
  class DataBag

    redef_const :NEW_VALID_NAME, /^:*[\.\-[:alnum:]_]+$/

    def self.validate_name!(name)
      unless name =~ NEW_VALID_NAME
        raise Exceptions::InvalidDataBagName, "DataBags must have a name matching #{NEW_VALID_NAME.inspect}, you gave #{name.inspect}"
      end
    end

    def name(arg=nil)
      set_or_return(
        :name,
        arg,
        :regex => NEW_VALID_NAME
      )
    end

    def self.load_as_node(name)
      raise Chef::Exceptions::Application, "the chef_commons data bags replacement has not been populated. Please ensure data bags have been written to node[:data_bags]" if Chef::Node.node[:data_bags].nil?

      name = name.to_sym if name.class == String

      data_bag = Chef::Node.node[:data_bags][name]
      raise Chef::Exceptions::Application, "the data bag #{name} does not exist" if data_bag.nil? 
      
      data_bag
    end    

    def self.load(name)
      load_as_node(name).to_hash
    end

  end
end