require 'rails_helper'

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.order = :random

  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # config.before do
  #   allow_any_instance_of(AASM::Configuration)
  #     .to receive(:no_direct_assignment).and_return(false)
  # end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |callable|
    Faker::Config.random = Random.new(config.seed)
    Faker::UniqueGenerator.clear

    DatabaseCleaner.cleaning { callable.run }
  end
end
