require './app/bowling.rb'
require 'capybara/poltergeist'

Dir[File.expand_path(File.join(File.dirname(__FILE__), 'support', '**', '*.rb'))].each { |file| require file }

Capybara.app = Sinatra::Application.new

Capybara.default_driver = :poltergeist

Capybara.ignore_hidden_elements = false

Capybara.javascript_driver = :poltergeist

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, debug: false, js_errors: false, phantomjs_options: ['--load-images=no'])
end

Capybara.server do |app, port|
  require 'rack/handler/thin'
  Rack::Handler::Thin.run(app, Port: port)
end

RSpec.configure do |config|
  config.include Capybara::DSL, type: :feature
end
