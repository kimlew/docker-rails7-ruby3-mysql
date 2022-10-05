# Dockerfile.rails
FROM ruby:3.0.1 AS rails-toolbox

RUN apt update && apt install -y \
  nodejs \
  nano

# Set default working directory as app's root directory.
ENV INSTALL_PATH /opt/rails7_task_manager
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

# Copy everything from current directory directory into corresp. folder of app's
# root directory within the container, e.g., COPY ./docker-flask-mysql /docker-flask-mysql
# Copy project includ. Gemfile & Gemfile.lock into container's root directory.
# Can use . or $INSTALL_PATH for current dir since WORKDIR set to /opt/rails7_task_manager.
COPY rails7_task_manager .
#COPY rails7_task_manager/Gemfile .
#COPY rails7_task_manager/Gemfile.lock .
RUN bundle update --all
#RUN bundle update --bundler
#RUN bundle update listen

# Try since defined WORKDIR: COPY rails7_task_manager/Gemfile .
# Try since defined WORKDIR: COPY rails7_task_manager/Gemfile $INSTALL_PATH

# OUTSIDE the Dockerfile: docker build --rm -t docker-flask-mysql .
# TO TEST w/out docker-compose.yml: RUN docker run -d -p 3000:3000 docker-flask-mysql
# TO TEST w/out docker-compose.yml: RUN docker run -d -p 3000:3000 ruby3-1_rails7_todo_app_docker
# Install gems: rails 7 & bundler
RUN gem install rails -v 7 && gem install bundler -v 2.3.22
RUN bundle install
#RUN chown -R user:user /opt/app

# Test if container working right by runing a shell.
CMD ["/bin/sh"]

# Default port is 3000 for container that app is in for MySQL.
EXPOSE 3000

# Add a script to be executed every time the container starts.
# COPY entrypoint.sh /usr/bin/
# RUN chmod +x /usr/bin/entrypoint.sh
# ENTRYPOINT ["entrypoint.sh"]

# Configure the main process to run when running the image, i.e., Start the main process.
# To make rails bind to all IPs & listen to requests from outside the container,
# use the rails server -b parameter. https://stackoverflow.com/questions/61164093/docker-compose-rails-app-not-accessible-on-port-3000#61164280
# CMD [ "/usr/local/bin/flask", "run", "--host=0.0.0.0" ]
# CMD ["rails", "server", "-b", "0.0.0.0"]
# View in browser at: http://localhost:3000/
