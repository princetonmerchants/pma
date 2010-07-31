# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
require File.join(File.dirname(__FILE__), 'boot')

require 'radius'

Radiant::Initializer.run do |config|
  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :action_mailer ]

  # Only load the extensions named here, in the order given. By default all
  # extensions in vendor/extensions are loaded, in alphabetical order. :all
  # can be used as a placeholder for all extensions not explicitly named.
  # config.extensions = [ :all ]
  config.extensions = [:help, :textile_filter, :wym_editor_filter, :fckeditor, :page_preview,
    :layouts, :redirect, :navigation, :import_export, :drag, :mailer,
    :paperclipped, :paperclipped_uploader, :search, :page_factory, :file_system, :tags,
    :comments, :archive, :dashboard, :pma, :settings ]
  
  # By default, only English translations are loaded. Remove any of these from
  # the list below if you'd like to provide any of the supported languages
  config.extensions -= [:markdown_filter, :dutch_language_pack, :french_language_pack, :german_language_pack,
                        :italian_language_pack, :japanese_language_pack, :russian_language_pack]

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random,
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :key => '_pma_session',
    :secret => 'e76f8749c40d12445b4c355dfce01d94d3b1f0ae'
  }

  # Comment out this line if you want to turn off all caching, or
  # add options to modify the behavior. In the majority of deployment
  # scenarios it is desirable to leave Radiant's cache enabled and in
  # the default configuration.
  #
  # Additional options:
  #  :use_x_sendfile => true
  #    Turns on X-Sendfile support for Apache with mod_xsendfile or lighttpd.
  #  :use_x_accel_redirect => '/some/virtual/path'
  #    Turns on X-Accel-Redirect support for nginx. You have to provide
  #    a path that corresponds to a virtual location in your webserver
  #    configuration.
  #  :entitystore => "radiant:tmp/cache/entity"
  #    Sets the entity store type (preceding the colon) and storage
  #   location (following the colon, relative to Rails.root).
  #    We recommend you use radiant: since this will enable manual expiration.
  #  :metastore => "radiant:tmp/cache/meta"
  #    Sets the meta store type and storage location.  We recommend you use
  #    radiant: since this will enable manual expiration and acceleration headers.
  config.middleware.use ::Radiant::Cache,
    :entitystore => "radiant:tmp/cache/entity",
    :metastore => "radiant:tmp/cache/meta"

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :cookie_store

  # Activate observers that should always be running
  config.active_record.observers = :user_action_observer

  # Make Active Record use UTC-base instead of local time
  config.time_zone = 'UTC'

  # Set the default field error proc
  config.action_view.field_error_proc = Proc.new do |html, instance|
    if html !~ /label/
      %{<span class="error-with-field">#{html} <span class="error">&bull; #{[instance.error_message].flatten.first}</span></span>}
    else
      html
    end
  end

  config.gem 'will_paginate', :version => '~> 2.3.11', :source => 'http://gemcutter.org'
  config.gem 'rubypants', :source => 'http://gemcutter.org'
  config.gem 'bluecloth', :source => 'http://gemcutter.org'
  config.gem 'sanitize', :source => 'http://gemcutter.org'
  config.gem 'fastercsv', :source => 'http://gemcutter.org'
  config.gem 'exceptional', :source => 'http://gemcutter.org'
  
  config.after_initialize do
    # Add new inflection rules using the following format:
    ActiveSupport::Inflector.inflections do |inflect|
      inflect.uncountable 'config'
    end
    
    DATABASE_MAILER_COLUMNS = {
      :first_name => :string,
      :last_name => :string,
      :company => :string,
      :job_title => :string,
      :industry => :string,
      :email => :string,
      :home_phone => :string,
      :work_phone => :string,
      :work_phone_ext => :string,
      :mobile_phone => :string,
      :address => :string,
      :city => :string,
      :state => :string,
      :zip => :string,
      :resident_since => :string,
      :princeton_activities => :string,
      :age_range => :string,
      :household_count => :integer,
      :gender => :string,
      :message => :text,
      :atatchment => :string
    }
  end
end