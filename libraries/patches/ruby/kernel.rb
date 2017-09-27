
module Kernel

  def suppress_warnings
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    result = yield
    $VERBOSE = original_verbosity
    return result
  end

  alias_method :original_require_relative, :require_relative
  def require_relative(partial_file_path)
    caller_file_path = caller[0].split(':')[0]
    if RbConfig::CONFIG['host_os'].downcase.include?('mingw')
      drive = caller[0].split(':')[0]
      caller_file_path = "#{drive}:#{caller[0].split(':')[1]}"
    end

    return if caller_file_path == __FILE__
    
    gem_path = $:.find{|gem_path_candidate|
      caller_file_path.start_with?(gem_path_candidate)
    }

    file_name_without_extention = File.basename(partial_file_path, '.*')
    partial_path = File.dirname(partial_file_path)

    full_path_without_extention = File.expand_path("#{partial_path}/#{file_name_without_extention}", File.dirname(caller_file_path))

    unless gem_path.nil?
      as_require = full_path_without_extention.gsub(/#{Regexp.escape(gem_path)}\//, '')
      require as_require
    else
      require "#{full_path_without_extention}.rb"
    end
  end

end