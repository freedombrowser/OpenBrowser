#!/bin/bash
PROJECT_DIR=$(dirname $(realpath $0))
export $(dotenv -f .env)
cd $PROJECT_DIR
RAILS_ENV=production bundle exec rake assets:precompile

RAILS_ENV=production rails server -p 5000