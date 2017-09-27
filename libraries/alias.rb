
require 'chef/dsl/recipe'

Dir.glob("#{File.expand_path('../providers', File.dirname(__FILE__))}/*.rb"){|provider_file_path|
  provider_name = File.basename(provider_file_path, '.rb')

  Chef::DSL::Recipe.module_eval "
    def #{provider_name}(name, &block)
      if block_given?
        chef_commons_#{provider_name}(name, &block)
      else
        chef_commons_#{provider_name}(name)
      end
    end
  "
}