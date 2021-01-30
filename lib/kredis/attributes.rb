module Kredis::Attributes
  extend ActiveSupport::Concern

  class_methods do
    def redis_list(name, config: :shared)
      ivar_symbol = :"@#{name}_redis_list"

      define_method(name) do
        if instance_variable_defined?(ivar_symbol)
          instance_variable_get(ivar_symbol)
        else
          instance_variable_set(ivar_symbol, Kredis.list(redis_key_for_attribute(name), config: config))
        end
      end
    end

    def redis_unique_list(name, limit: nil, config: :shared)
      ivar_symbol = :"@#{name}_redis_unique_list"

      define_method(name) do
        if instance_variable_defined?(ivar_symbol)
          instance_variable_get(ivar_symbol)
        else
          instance_variable_set(ivar_symbol, Kredis.unique_list(redis_key_for_attribute(name), limit: limit, config: config))
        end
      end
    end
  end

  private
    def redis_key_for_attribute(name)
      "#{self.class.name.tableize.gsub("/", ":")}:#{id}:#{name}"
    end
end
