angular.module 'evaluator'
  .config ($stateProvider) ->

    privateState =
      name: 'private'
      templateUrl: 'private/root.html'
      url: ''
      abstract: true
      data:
        authRule: (userAuth) ->
          if userAuth.signedIn
            {
              allowed: true
            }
          else
            {
              to: 'public.login'
              params: {}
              allowed: false
            }

    coursesState =
      name: 'private.courses'
      url: '/courses'
      resolve:
        $title: ->
          'Courses'
      views:
        'pageContent':
          templateUrl: 'private/courses.html'
          controller: 'CoursesController'

    courseState =
      name: 'private.course'
      url: '/course/:id'
      views:
        'pageContent':
          templateUrl: 'private/course.html'
          controller: 'CourseController'

    projectState =
      name: 'private.project'
      url: '/project/:id'
      views:
        'pageContent':
          templateUrl: 'private/project.html'
          controller: 'ProjectController'

    submissionsState =
      name: 'private.submissions'
      url: '/project/:project_id/submissions'
      views:
        'pageContent':
          templateUrl: 'private/submissions.html'
          controller: 'SubmissionsController'

    $stateProvider
      .state privateState
      .state coursesState
      .state courseState
      .state projectState
      .state submissionsState