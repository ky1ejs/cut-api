require 'yaml'
require 'erb'

RABBIT_CONFIG = YAML.load(ERB.new(File.new("config/rabbitmq.yml").read).result(binding))[Rails.env]
