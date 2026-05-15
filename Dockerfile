FROM ruby:3.0.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

WORKDIR /app

# Copy dependency files
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application
COPY . .

# Precompile assets for production
RUN bundle exec rake assets:precompile RAILS_ENV=production SECRET_KEY_BASE=dummy_key DATABASE_URL=postgres://dummy

# Open the port Hugging Face requires
EXPOSE 7860

# Start the Rails server on Hugging Face's port
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "7860", "-e", "production"]
