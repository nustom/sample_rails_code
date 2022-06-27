require 'simplecov'
require_relative 'support/test_helpers/features'
require_relative 'support/test_helpers/froala_helper'
require_relative 'support/test_helpers/google_address_search_helper'
require_relative 'support/test_helpers/common_helpers'
require_relative 'support/test_helpers/typeahead_helper'
require_relative 'support/test_helpers/flatpickr_helper'
require_relative 'support/test_helpers/request_helpers'
require_relative 'support/test_helpers/dropzone_helper'
require_relative 'support/test_helpers/zoomus_helper'
require_relative 'support/test_helpers/instructor_availability_helper.rb'
require_relative 'support/test_helpers/selectize_select_helper'

SimpleCov.start do
  add_filter '/spec/'
  add_filter 'registrations_controller'
  # SimpleCov.minimum_coverage_by_file 80
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'capybara/poltergeist'

ActiveRecord::Migration.maintain_test_schema!

Capybara.register_driver :poltergeist do |app|
  options = {
    phantomjs_options: %w[
      --cookies-file=cookies.txt
      --disk-cache=yes
      --ignore-ssl-errors=yes
    ],
    js_errors: true,
    phantomjs_logger: Logger.new(STDOUT),
    window_size: [1600, 1200]
  }

  Capybara::Poltergeist::Driver.new(
    app, options
  )
end

Capybara.javascript_driver = :poltergeist

if ENV['SPEC_AR_LOGGING']
  ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
end

RSpec.configure do |config|
  config.include Support::TestHelpers::Features, type: :feature
  config.include Support::TestHelpers::FroalaHelper, type: :feature
  config.include Support::TestHelpers::GoogleAddressSearchHelper, type: :feature
  config.include Support::TestHelpers::CommonHelpers, type: :feature
  config.include Support::TestHelpers::TypeaheadHelper, type: :feature
  config.include Support::TestHelpers::FlatpickrHelper, type: :feature
  config.include Support::TestHelpers::DropzoneHelper, type: :feature
  config.include Support::TestHelpers::RequestHelpers, type: :request
  config.include Support::TestHelpers::ZoomusHelper, type: :request
  config.include Support::TestHelpers::SelectizeSelectHelper, type: :feature  

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
  config.before(:each) { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryGirl::Syntax::Methods
  config.color = true
  config.formatter = ENV['SPEC_FORMATTER'] ? ENV['SPEC_FORMATTER'].to_sym : :progress
  config.example_status_persistence_file_path = 'examples.txt'
end
