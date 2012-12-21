module Impressionist
  module Impressionable
    extend ActiveSupport::Concern

    module ClassMethods
      attr_accessor :impressionist_cache_options
      @impressionist_cache_options = nil

      def impressionist_counter_cache_options
        if @impressionist_cache_options
          options = { :column_name => :impressions_count, :unique => false }
          options.merge!(@impressionist_cache_options) if @impressionist_cache_options.is_a?(Hash)
          options
        end
      end

      def impressionist_counter_caching?
        impressionist_counter_cache_options.present?
      end

      def counter_caching?
        ::ActiveSupport::Deprecation.warn("#counter_caching? is deprecated; please use #impressionist_counter_caching? instead")
        impressionist_counter_caching?
      end
    end

    def impressionable?
      true
    end

    def impressionist_count(options={})
      impressions.where(options).count
    end

    def user_impressionist_count(user_id)
      impressionist_count(user_id: user_id)
    end

    def update_impressionist_counter_cache
      cache_options = self.class.impressionist_counter_cache_options
      column_name = cache_options[:column_name].to_sym
      count = impressionist_count
      old_count = send(column_name) || 0
      self.class.update_counters(id, column_name => (count - old_count))
    end

  end
end
