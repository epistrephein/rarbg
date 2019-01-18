# frozen_string_literal: true

require 'rarbg/version'
require 'rarbg/categories'
require 'rarbg/api'

# Module namespace shortcut methods.
module RARBG
  class << self
    %i[list search].each do |method|
      define_method(method) do |*args|
        @rarbg ||= RARBG::API.new
        @rarbg.send(method, *args)
      end
    end
  end
end
