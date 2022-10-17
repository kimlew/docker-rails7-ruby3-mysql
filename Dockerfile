FROM ruby:3.0.1 AS rails-toolbox

RUN apt update && apt install -y \
  nodejs \
  nano

# Set default working directory as app's root directory.
ENV INSTALL_PATH /opt/rails7_task_manager
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

# Copy everything from current directory directory into corresp. folder of app's
# root directory within the container. Copy includes Gemfile & Gemfile.lock 
# into container's root directory. Can use . or $INSTALL_PATH for current dir
# since WORKDIR set to /opt/rails7_task_manager.
COPY $INSTALL_PATH/Gemfile $INSTALL_PATH/Gemfile.lock ./
RUN bundle check || bundle install
COPY rails7_task_manager .
RUN bundle update --all

# 1st run OUTSIDE the Dockerfile: docker build --rm -t docker-flask-mysql .
# TO TEST w/out docker-compose.yml: 
# RUN docker run -d -p 3000:3000 ruby3-1_rails7_todo_app_docker
RUN gem install rails -v 7 && gem install bundler -v 2.3.22
RUN bundle install

# Test if container working right by runing a shell. Comment out after initial  
# test since only 1 CMD allowed per Dockerfile & need that 1 CMD to run web app.
#CMD ["/bin/sh"]

# Default port is 3000 for host. Note: In recent versions of Dockerfile, EXPOSE
# is just informative. EXPOSE no longer has any operational impact.
EXPOSE 3000

# Add an entrypoint script to be executed every time the container starts to  
# let us run the container as an executable.
# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]

# Start the main process, i.e., configure the main process to run when running 
# the image. Note: Use the rails server -b parameter to make rails bind to all 
# IPs & listen to requests from outside the container. Refer to:
# https://stackoverflow.com/questions/61164093/docker-compose-rails-app-not-accessible-on-port-3000#61164280
CMD ["rails", "server", "-b", "0.0.0.0"]
# View in browser at: http://localhost:48013/
