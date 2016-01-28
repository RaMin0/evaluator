angular.module 'evaluator'
  .factory 'endpoints', (apiHost) ->
    endpoints =
      configurations:
        index: [apiHost, 'configurations.json'].join '/'
      users:
        resourceUrl: [apiHost, 'users', ':id.json'].join '/'
      courses:
        resourceUrl: [apiHost, 'courses', ':id.json'].join '/'