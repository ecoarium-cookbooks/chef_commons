#
# Cookbook Name:: chef_commons
# Provider:: alias_resource
#

require 'chef/dsl/recipe'

action :create do
  calling_cookbook_name =

  Dir.glob("#{File.expand_path('../providers', File.dirname(__FILE__))}/*.rb"){|provider_file_path|
    provider_name = File.basename(provider_file_path, '.rb')

    Chef::DSL::Recipe.module_eval "
      def #{provider_name}(name, &block)
        if block_given?
          #{calling_cookbook_name}_#{provider_name}(name, &block)
        else
          #{calling_cookbook_name}_#{provider_name}(name)
        end
      end
    "
  }

  new_resource.updated_by_last_action(true)
end