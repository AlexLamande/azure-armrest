
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'azure/armrest'
require 'pp'
require 'colorize'
require './lbn_secrets'

def print_code(str)
  puts str.light_green.colorize(background: :black).bold
  gets
end

# def print_server_status(server)
#   pp '#{server.name}: #{server.state}'.yellow.on_black.bold
# end
