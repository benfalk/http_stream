# WebStream

A simple DSL wrapper around HTTPoision to help build a stream with http requests


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add web_stream to your list of dependencies in `mix.exs`:

        def deps do
          [{:web_stream, "~> 0.0.1"}]
        end

  2. Ensure web_stream is started before your application:

        def application do
          [applications: [:web_stream]]
        end
