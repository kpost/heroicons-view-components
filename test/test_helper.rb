# frozen_string_literal: true

require "bundler/setup"
require "minitest/autorun"
require "heroicons/view_component"

class Minitest::Test
  def setup
    # Clear the cache before each test to ensure clean state
    Heroicons::ViewComponent::IconCache.clear
  end
end
