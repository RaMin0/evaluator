angular.module 'evaluator'
  .controller 'SubmissionsController', ($scope, $stateParams, ProjectResource,
    ProjectSubmissionsResource, Pagination, defaultPageSize, Submission, ngDialog) ->

    $scope.loading = true

    projectPromise = ProjectResource.get(
      id: $stateParams.project_id
    ).$promise
    projectPromise.then (project) ->
      $scope.project = project
      $scope.loading = false

    submissionFactory = (data) ->
      new Submission data

    submissionsPagination = new Pagination ProjectSubmissionsResource,
      {project_id: $stateParams.project_id}, submissionFactory, defaultPageSize
    
    $scope.submissions = []
    $scope.submissionClasses = ['submission-accent-one',
    'submission-accent-two', 'submission-accent-three']

    addSubmissionsCallback = (newSubmissions) ->
      args = [0, $scope.submissions.length].concat submissions
      $scope.submissions.splice.apply $scope.submissions, args

    addNewSubmission = (submission) ->
      $scope.submissions.splice 0, 0, submission

    $scope.loadingSubmissions = true

    

    $scope.currentPage = 1

    loadSubmissionsPage = (page) ->
      submissionsPagination.page(page).then (submissions) ->
        $scope.loadingSubmissions = false
        $scope.currentPage = page
        addSubmissionsCallback submissions

    # Load first page
    loadSubmissionsPage $scope.currentPage

    $scope.backDisabled = ->
      $scope.currentPage > 1

    $scope.nextDisabled = ->
      $scope.currentPage == submissionsPagination.totalPages


    $scope.next = ->
      if not $scope.nextDisabled()
        loadSubmissionsPage($scope.currentPage + 1)
    $scope.back = ->
      if not $scope.backDisabled()
        loadSubmissionsPage($scope.currentPage - 1)

    $scope.newSubmissionData = {}

    $scope.showSubmitDialog = ->
      return if $scope.newSubmissionDialog && ngDialog.isOpen($scope.newSubmissionDialog)
      $scope.newSubmissionData = {}
      $scope.submissionCreateError = ''
      $scope.newSubmissionDialog = ngDialog.open
        template: 'private/create/submission.html'
        scope: $scope

    $scope.submit = ->
      return if $scope.processingSubmission
      $scope.processingSubmission = true
      success = (data) ->
        submission = new Submission data
        $scope.newSubmissionDialog.close()
        $scope.processingSubmission = false
        addNewSubmission submission
      failure = (response) ->
        if response.status is not 422
          $scope.submissionCreateError = ("#{key.capitalize()} #{value}." for key, value of response.data)
            .join ' '
          $scope.processingSubmission = false
        else
          $scope.submissionCreateError = response.data.message.capitalize
          $scope.processingSubmission = false
      Upload.upload(
        url: endpoints.projectSubmissions.resourceUrl.replace(':project_id', $stateParams.project_id)
        data: $scope.newSubmissionData
      ).then(success, failure)




