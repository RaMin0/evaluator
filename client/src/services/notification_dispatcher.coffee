angular.module 'evaluator'
  .factory 'NotificationDispatcher', (FayeClient) ->
    class NotificationDispatcher
      constructor: () ->
        @subscribers = {}
        @listeners = {}


      # Generic handler
      handler: (url, message) ->
        (@listeners[url]or=[]).forEach (listener) ->
          listener(message)

      # Generic subscribe for all types
      # Used internally
      subscribe: (url, callback) ->
        (@listeners[url]or=[]).push callback
        if url not of @subscribers
          receiveHandler = (message) =>
            @handler url, message
          FayeClient.subscribe url, receiveHandler

      subscribeSuite: (suite, callback) ->
        url = "/notifications/test_suites/#{suite.id}"
        @subscribe url, callback

      subscribeSubmission: (submission, callback) ->
        url = "/notifications/submissions/#{submission.id}"
        @subscribe url, callback

    new NotificationDispatcher
        



    