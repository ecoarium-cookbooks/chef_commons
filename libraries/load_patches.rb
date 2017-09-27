
Dir.glob(File.expand_path('patches/ruby/**/*.rb', File.dirname(__FILE__))).each{|patch|
  require patch
}