require 'digest/sha2'

module ImpressionistController

  module InstanceMethods

    def impressionist(obj,opts={})
        if obj.respond_to?("impressionable?")
          if unique_instance?(obj, opts[:unique])
            obj.impressions.create(associative_create_statement)
          end
        else
          # we could create an impression anyway. for classes, too. why not?
          raise "#{obj.class.to_s} is not impressionable!"
        end
    end

    private


    def unique_instance?(impressionable, unique_opts)
      return unique_opts.blank? || !impressionable.impressions.where(unique_query(unique_opts)).exists?
    end

    def unique?(unique_opts)
      return unique_opts.blank? || !Impression.where(unique_query(unique_opts)).exists?
    end

    # creates the query to check for uniqueness
    def unique_query(unique_opts)
      full_statement = direct_create_statement
      # reduce the full statement to the params we need for the specified unique options
      unique_opts.reduce({}) do |query, param|
        query[param] = full_statement[param]
        query
      end
    end

    # creates a statment hash that contains default values for creating an impression via an AR relation.
    def associative_create_statement(query_params={})
      query_params.reverse_merge! user_id: user_id
    end

    # creates a statment hash that contains default values for creating an impression.
    def direct_create_statement(query_params={})
      query_params.reverse_merge!(
        :impressionable_type => controller_name.singularize.camelize,
        :impressionable_id=> params[:id]
        )
      associative_create_statement(query_params)
    end


    #use both @current_user and current_user helper
    def user_id
      user_id = @current_user ? @current_user.id : nil rescue nil
      user_id = current_user ? current_user.id : nil rescue nil if user_id.blank?
      user_id
    end
  end
end
