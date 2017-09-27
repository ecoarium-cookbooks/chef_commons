
class Module

	def list_included_modules
		ancestor_list = ancestors
		ancestor_list.each{|ancestor|
			next if [Class, Module, Object, Kernel, BasicObject].include? ancestor
			next if ancestor == self

			ancestor_list.concat ancestor.list_included_modules
			ancestor_list.uniq!
		}
		ancestor_list
	end

	def list_extended_modules
		extended_list = included_modules
		extended_list.each{|ancestor|
			next if [Class, Module, Object, Kernel, BasicObject].include? ancestor
			next if ancestor == self

			extended_list.concat ancestor.list_extended_modules
			extended_list.uniq!
		}
		extended_list
  end
end