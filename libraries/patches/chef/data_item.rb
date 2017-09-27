require 'pp'
require 'chef/data_bag'
require 'chef/data_bag_item'
require 'chef/dsl/data_query'

class Chef
  class DataBagItem

    def self.validate_id!(id_str)
      
    end

    def data_bag(arg=nil)
      set_or_return(
        :data_bag,
        arg,
        :regex => /.*/
      )
    end

    def raw_data=(new_data)
      unless new_data.respond_to?(:[]) && new_data.respond_to?(:keys)
        raise Exceptions::ValidationFailed, "Data Bag Items must contain a Hash or Mash!"
      end
      @raw_data = new_data
    end

    def self.load_as_node(data_bag, name)
      bag = Chef::DataBag.load_as_node(data_bag)
      bag[name]
    end

    def self.load(data_bag, name)
      item = load_as_node(data_bag, name)
      raise Chef::Exceptions::Application, "the item #{name} does not exist for data bag #{data_bag}" if item.nil? 

      if item.kind_of?(DataBagItem)
        item
      else
        item = from_hash(item)
        item.data_bag(data_bag)
        item
      end

      item
    end

  end
end