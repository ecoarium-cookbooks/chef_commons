
class Chef
  module LoadDeepMerge
    def load_deep_merge
      require 'deep_merge'
    end
  end
  class Node
    send(:include, Chef::DSL::DataQuery)

    def set_instance
      self.class.node = self
    end

    def save

    end

    class << self

      @node = nil
      def node
        raise Chef::Exceptions::Application, "the class attribute node has not been set, please include the recipe chef_commons before this call or set it yourself: Chef::Node.set_instance" if @node.nil?
        return @node
      end

      def node=(value)
        @node = value
      end

    end

    class MultiMash
      include LoadDeepMerge

      def deep_merge!(source, options = {})
        load_deep_merge
        default_opts = {:preserve_unmergeables => false}
        DeepMerge::deep_merge!(source, self, default_opts.merge(options))
      end
    end
    class VividMash
      include LoadDeepMerge

      def deep_merge!(source, options = {})
        load_deep_merge
        default_opts = {:preserve_unmergeables => false}
        DeepMerge::deep_merge!(source, self, default_opts.merge(options))
      end
    end
    class Attribute
      include LoadDeepMerge

      def deep_merge!(source)
        load_deep_merge
        case @set_type
        when :normal
          @current_normal = @current_normal.deep_merge!(source)
        when :override
          @current_override = @current_override.deep_merge!(source)
        when :default
          @current_default = @current_default.deep_merge!(source)
        when :automatic
          @current_automatic = @current_automatic.deep_merge!(source)
        end

        self
      end
    end
    class AttrArray
      include LoadDeepMerge

      def deep_merge!(source, options = {})
        load_deep_merge
        default_opts = {:preserve_unmergeables => false}
        DeepMerge::deep_merge!(source, self, default_opts.merge(options))
      end

    end
  end
end
