require 'yaml'

RABBIT_CONFIG = YAML.load_file(Rails.root.join('config/rabbitmq.yml'))[Rails.env]
