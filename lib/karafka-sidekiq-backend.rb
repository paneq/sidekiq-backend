# frozen_string_literal: true

%w[
  karafka
  sidekiq
].each(&method(:require))

# Karafka framework namespace
module Karafka
  # Namespace for all the backends that process data
  module Backends
    # Sidekiq Karafka backend
    module Sidekiq
      class << self
        # @return [String] path to Karafka gem root core
        def core_root
          Pathname.new(File.expand_path('../karafka', __FILE__))
        end
      end
    end
  end
end

# Uses Karafka loader to load all the sources that this backend needs
Karafka::Loader.load!(Karafka::Backends::Sidekiq.core_root)