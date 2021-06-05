require 'forwardable'
require "yaml"
require "erb"

module AppConfig
  PATH = "config.yml"

  def self.load
    @app_config = YAML.load(ERB.new(File.read(PATH)).result)
    Config.new(@app_config)
  end
end

class Config
  extend Forwardable
  attr_reader :data
  def_delegators :data, :key?, :has_key?, :include?, :member?, :fetch, :[]

  def initialize(hash)
    @data = hash
  end

  private

  def get_config_value(key)
    return nil unless key?(key)

    value = fetch(key)
    value.is_a?(Hash) ? self.class.new(value) : value
  end

  def method_missing(method, *args)
    key = method.to_s
    key = key[0..-2] if boolean_method?(method)

    if key?(key)
      get_config_value(key) 
    else
      super
    end
  end

  def boolean_method?(method)
    method.to_s[-1] == "?"
  end
end
