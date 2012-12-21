require "impressionist"
require "rails"

module Impressionist
  class Engine < Rails::Engine
    initializer 'impressionist.model' do |app|
      require "#{root}/app/models/impressionist/impressionable.rb"

      require "impressionist/models/active_record/impression.rb"
      require "impressionist/models/active_record/impressionist/impressionable.rb"
      ActiveRecord::Base.send(:include, Impressionist::Impressionable)
    end

    initializer 'impressionist.controller' do
      ActiveSupport.on_load(:action_controller) do
        include ImpressionistController::InstanceMethods
      end
    end
  end
end
