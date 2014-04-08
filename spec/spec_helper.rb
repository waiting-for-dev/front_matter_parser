$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'front_matter_parser'
require 'tempfile'
Dir["#{File.expand_path('../support', __FILE__)}/*.rb"].each do |file|
  require file
end
