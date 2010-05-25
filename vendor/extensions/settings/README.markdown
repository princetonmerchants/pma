Radiant Settings Extension
==========================

A simple configuration editor for Radiant.  It adds a simple "Settings" tab that allows manage the system settings.

After installation be sure to update your instance of radiant!

    rake radiant:extensions:settings:update
    rake radiant:extensions:settings:migrate
    
Additionally this extension includes yaml_db which makes it easy to dump and import a database. This can be great on
for making changes on a development machine which are pushed to production.

    rake db:export // dumps schema.rb and config/data.yaml
    rake db:import // imports schema.rb and config/data.yaml

Extension Developers
--------------------

If you are using Radiant::Config to store settings for your extensions, then you can add some textile formatted text into
the "description" attribute the Radiant::Config model.  This prose will show up on the the edit setting page making it
more clear just what that setting does.