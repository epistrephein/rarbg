# frozen_string_literal: true

require 'rarbg/version'
require 'rarbg/categories'
require 'rarbg/api'

# Module shortcut methods
module RARBG
  class << self
    %i[list search].each do |m|
      define_method(m) do |*arg|
        @rarbg ||= RARBG::API.new
        @rarbg.send(m, *arg)
      end
    end
  end
end
