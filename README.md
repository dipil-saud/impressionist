impressionist (skinny version)
=============

FORKED from: https://github.com/charlotte-ruby/impressionist
LightWeight version supporting only AR and with all the fields except the user_id and the impressionable type & id removed.

--------------------------------------------------------------------------------

What does this thing do?
------------------------
Logs an impression... and I use that term loosely. It logs model impresssions. No
reporting yet.. this thingy just creates the data.



Installation
------------
Add it to your Gemfile

    gem 'impressionist'

Install with Bundler

    bundle install

Generate the impressions table migration

    rails g impressionist

Run the migration

    rake db:migrate

The following fields are provided in the migration:

    t.string   "impressionable_type"  # model type: Widget
    t.integer  "impressionable_id"    # model instance ID: @widget.id
    t.integer  "user_id"              # automatically logs @current_user.id
    t.datetime "created_at"           # I am not sure what this is.... Any clue?
    t.datetime "updated_at"           # never seen this one before either....  Your guess is as good as mine??

Usage
-----


1. Make your models impressionable.  This allows you to attach impressions to
   an AR model instance.  Impressionist will automatically log the Model name
   (based on action_name) and the id (based on params[:id]), but in order to
   get the count of impressions (example: @widget.impression_count), you will
   need to make your model impressionalble

        class Widget < ActiveRecord::Base
          is_impressionable
        end

2. Log an impression per model instance in your controller.

        def show
          @widget = Widget.find
          impressionist(@widget)
        end

5. Get unique impression count from a model.  This groups impressions by
   request_hash, so if you logged multiple impressions per request, it will
   only count them one time.  This unique impression count will not filter out
   unique users, only unique requests

        @widget.impressionist_count
        @widget.impressionist_count(:start_date=>"2011-01-01",:end_date=>"2011-01-05")
        @widget.impressionist_count(:start_date=>"2011-01-01")  #specify start date only, end date = now


Logging impressions for authenticated users happens automatically.  If you have
a current_user helper or use @current_user in your before_filter to set your
authenticated user, current_user.id will be written to the user_id field in the
impressions table.

Adding a counter cache
----------------------
Impressionist makes it easy to add a `counter_cache` column to your model. The
most basic configuration looks like:

    is_impressionable :counter_cache => true

This will automatically increment the `impressions_count` column in the
included model. Note: You'll need to add that column to your model. If you'd
like specific a different column name, you can:

    is_impressionable :counter_cache => { :column_name => :my_column }

If you'd like to include only unique impressions in your count:

    is_impressionable :counter_cache => { :column_name => :my_column, :unique => true }

What if I only want to record unique impressions?
-------------------------------------------------
Maybe you only care about unique impressions and would like to avoid
unnecessary database records. You can specify conditions for recording
impressions in your controller:

    # only record impression if the request has a unique combination of type, id
    impressionist :unique => [:impressionable_type, :impressionable_id]


Or you can use the `impressionist` method directly:

    impressionist(impressionable, :unique => [:session_hash])

Development Roadmap
-------------------
* Automatic impression logging in views.  For example, log initial view, and
  any partials called from initial view
* Customizable black list for user-agents or IP addresses.  Impressions will be
  ignored.  Web admin as part of the Engine.
* Reporting engine
* AB testing integration

Contributing to impressionist
-----------------------------
* Check out the latest master to make sure the feature hasn't been implemented
  or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it
  and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add rpsec tests for it. Patches or features without tests will
  be ignored.  Also, try to write better tests than I do ;-)
* If adding engine controller or view functionality, use HAML and Inherited
  Resources.
* All testing is done inside a small Rails app (test_app).  You will find specs
  within this app.

Contributors
------------
* [johnmcaliley](https://github.com/johnmcaliley)
* [coryschires](https://github.com/coryschires)
* [georgmittendorfer](https://github.com/georgmittendorfer)

Copyright (c) 2011 John McAliley. See LICENSE.txt for further details.
