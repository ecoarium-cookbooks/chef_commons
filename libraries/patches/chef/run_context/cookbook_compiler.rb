require 'chef/run_context/cookbook_compiler'

class Chef
  class RunContext
    class CookbookCompiler
      def load_libraries_from_cookbook(cookbook_name)
        files_in_cookbook_by_segment(cookbook_name, :libraries).each do |filename|
          begin
            next unless File.extname(filename) == '.rb'
            Chef::Log.debug("Loading cookbook #{cookbook_name}'s library file: #{filename}")
            require filename
            @events.library_file_loaded(filename)
          rescue Exception => e
            @events.library_file_load_failed(filename, e)
            raise
          end
        end
      end

      def add_cookbook_with_deps(ordered_cookbooks, seen_cookbooks, cookbook)
        return false if seen_cookbooks.key?(cookbook)

        seen_cookbooks[cookbook] = true

        begin
          each_cookbook_dep(cookbook) do |dependency|
            add_cookbook_with_deps(ordered_cookbooks, seen_cookbooks, dependency)
          end  
        rescue Chef::Exceptions::CookbookNotFound => e
          cookbook_not_found, suggestion = e.message.split("\n") 
          raise Chef::Exceptions::CookbookNotFound, "Loading dependencies of cookbook #{cookbook}, the following dependency was not found:
#{cookbook_not_found}
#{suggestion}"
        end
        
        ordered_cookbooks << cookbook
      end
    end
  end
end