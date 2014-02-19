if ENV['HEROKU']
  Roswell::Application.config.roswell_key = ENV['ROSWELL_KEY']
end