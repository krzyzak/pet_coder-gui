# frozen_string_literal: true

# Require all lib files
require "gosu"
require_relative "../lib/point"
require_relative "../lib/state"
require_relative "../lib/treat"
require_relative "../lib/hole"
require_relative "../lib/game_object"
require_relative "../lib/player"
require_relative "../lib/level"
require_relative "../lib/game"
require_relative "../lib/parser"
require_relative "../lib/editor"
require_relative "../lib/executor"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.warnings = true

  config.order = :random
  Kernel.srand config.seed
end
