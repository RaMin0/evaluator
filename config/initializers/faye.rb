# Faye configurations
Rails.application.config.middleware.delete Rack::Lock

unless Rails.const_defined?(:Server) || !ENV['IS_SERVER'].nil?
  Faye.logger = Rails.logger
  Faye.logger.debug "Ensure reactor running!"
  Faye.ensure_reactor_running!
end
  


Rails.application.config.middleware.use FayeRails::Middleware, mount: '/faye', engine: {
  type: Faye::Redis,
  host: 'localhost'
  }, timeout: 25 do
    map '/notifications/submissions/**': Notifications::SubmissionsController
    map '/notifications/test_suites/**': Notifications::TestSuitesController
    map '/notifications/projects/**': Notifications::ProjectsController
    map '/notifications/courses/**': Notifications::CoursesController
end

