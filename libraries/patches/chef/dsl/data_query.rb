require 'pp'
require 'chef/data_bag'
require 'chef/data_bag_item'
require 'chef/dsl/data_query'

class Chef
  module DSL
    module DataQuery

      def data_bag_items(bag_name)
        bag = DataBag.load_as_node(bag_name)

        raise Chef::Exceptions::Application, "Failed to load data bag: bag_name[#{bag_name.inspect}] bag[#{bag.inspect}]" if bag.nil?
        
        bag
      end

      def data_bag(bag_name)
        bag = DataBag.load_as_node(bag_name)

        raise Chef::Exceptions::Application, "Failed to load data bag: bag_name[#{bag_name.inspect}] bag[#{bag.inspect}]" if bag.nil?

        bag.keys
      end

      def data_bag_item(bag, item_name, secret=nil)
        item = DataBagItem.load_as_node(bag, item_name)
        raise Chef::Exceptions::Application, "Failed to load data bag item: bag_name[#{bag.inspect}] item_name[#{item_name.inspect}] item[#{item.inspect}]" if item.nil?

        if encrypted?(item)
          Log.debug("Data bag item looks encrypted: bag[#{bag.inspect}] item_name[#{item_name.inspect}]")
          
          if secret.nil? and !Chef::Node.node[:data_bag_secret].nil?
            secret = Chef::Node.node[:data_bag_secret]
          else
            raise Chef::Exceptions::Application, "No data bag secret provided for encrypted data bag item: bag[#{bag.inspect}] item_name[#{item_name.inspect}]"
          end

          begin
            item = EncryptedDataBagItem.new(item, secret).to_hash
            item = JSON.parse(JSON.pretty_generate(item), symbolize_names: true)
          rescue Exception
            raise Chef::Exceptions::Application, "Failed to load secret for encrypted data bag item: bag[#{bag.inspect}] item_name[#{item_name.inspect}]"
          end
        end

        raise Chef::Exceptions::Application, "Failed to load data bag item: bag[#{bag.inspect}] item_name[#{item_name.inspect}] item[#{item.inspect}]" if item.nil?

        item
      end

      def encrypted?(item)
        evidence = %w{encrypted_data iv version cipher}
        item.any?{|key,value|
          is_it = false
          if value.is_a? Hash
            value.keys.any?{|key|
              is_it = true if evidence.include?(key)
            }
          end
          is_it
        }
      end

    end
  end
end