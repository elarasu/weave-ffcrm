# Fat Free Crm 
#   docker build -t elarasu/weave-ffcrm .
#
FROM rails
MAINTAINER elarasu@outlook.com

RUN apt-get update && apt-get install -y libmagick++-dev
RUN git clone --depth 1 http://github.com/fatfreecrm/fat_free_crm.git

WORKDIR /fat_free_crm

# use file-based SQLite database - this may be slow and unreliable
RUN cp config/database.sqlite.yml config/database.yml
RUN gem install sqlite3

# install dependencies
RUN bundle install
RUN rake db:create
RUN rake db:migrate

EXPOSE 3000

# start server and bind to all IPs in docker container
ENTRYPOINT ["rails", "server", "--binding=0.0.0.0", "--port=3000"]

# for interactive setup use this command in shell
#   rake ffcrm:setup
# create demo data in database
#RUN rake ffcrm:demo:load
# create admin user with given user/pass
RUN rake ffcrm:setup:admin USERNAME=admin PASSWORD=password EMAIL=admin@example.com

