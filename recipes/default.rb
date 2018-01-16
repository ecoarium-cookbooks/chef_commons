
chef_gem 'awesome_print'
chef_gem 'deep_merge'

chef_gem 'mixlib-shellout' do
  version '2.1.0'
  only_if do
    begin
      Gem::Specification.find_by_name('mixlib-shellout').version < Gem::Version.new('2.1.0')
    rescue Gem::LoadError => e
      true
    end
  end
end

node.set_instance

include_recipe 'chef_commons::ark_monkey_patch'
