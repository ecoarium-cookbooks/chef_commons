require 'chef/run_context'

class Chef
  class RunContext
    @@count = 0

    alias_method :orig_load_recipe, :load_recipe
    def load_recipe(recipe_name, current_cookbook: nil)
      cookbook_name, recipe_short_name = Chef::Recipe.parse_recipe_name(recipe_name, current_cookbook: current_cookbook)

      unless unreachable_cookbook?(cookbook_name) and loaded_fully_qualified_recipe?(cookbook_name, recipe_short_name)
      
        cookbook_name_for_attr, attr_file = node.parse_attribute_file_spec(recipe_name)
        if !loaded_fully_qualified_attribute?(cookbook_name_for_attr, attr_file) and !@cookbook_compiler.nil?
          Chef::Log.debug("Loading Attribute #{cookbook_name_for_attr}::#{attr_file}")
          
          begin
            @cookbook_compiler.send(:load_attributes_from_cookbook, cookbook_name)
          rescue ::Chef::Exceptions::CookbookNotFound => e
            raise Chef::Exceptions::CookbookNotFound, "
Error loading recipe named '#{recipe_name}'.
Best guess is that the cookbook named '#{current_cookbook}' does not have the follow in it's metadata.rb:

depends '#{cookbook_name}'


#{e.message}
  #{e.backtrace.join("\n  ")}
"
          end
        end
      end

      orig_load_recipe(recipe_name, current_cookbook: nil)
    end

  end
end