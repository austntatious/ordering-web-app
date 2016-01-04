** Third-party Requirements **

- Image magick
- PostgreSQL
- Redis (at least 2.4 version)


** Launching an app **

- clone the app
- copy config/database.yml.example to config/database.yml and setup database connection
- copy config/local_env.yml.example to config/local_env.yml and setup credentials inside 
- run "bundle install"
- run "bundle exec rake db:create"
- run "bundle exec rake db:migrate"
- run "bundle exec rails s" to start server
- run "bundle exec sidekiq" to start background worker
- create an admin user (see below)
- fill the "settings" area on admin panel

** Creating an admin user **
- run "bundle exec rails c" to start Rails console
- run "AdminUser.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password')" to create an admin user with password 'password' and email 'admin@example.com'


** Troubleshooting **

You can get an error with "pg" gem installation.
This usually means you have no pg_config on 
your path. You can install "pg" gem manually with following command

gem install pg -- --with-ph-config=PATHTOYOURPGCONFIG

PATHTOYOURPGCONFIG depends on your OS and PostgreSQL installation,
for me (PostgreSQL 9.3 and OSX) I have the following path:

/Library/PostgreSQL/9.3/bin/


** Notes **

I didn't added any comments to controllers/admin/*.rb, because all of this controlles are standard scaffold controllers and doesn't have any custom code except of sorting, but it's quite easy to understand.

API controllers are documented with ApiPie.