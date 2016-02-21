angular.module 'evaluator'
  .controller 'BundlesController', ($scope, Pagination, BundlesResource,
    defaultPageSize, Bundle) ->
      $scope.bundles = []
      $scope.bundleClasses = ['bundle-accent-one', 'bundle-accent-two',
      'bundle-accent-three']

      $scope.scrollDisabled = false
      $scope.loading = true

      bundleFactory = (data) ->
        new Bundle(new BundlesResource(data))

      bundlesPagination = new Pagination BundlesResource, 'project_bundles', {},
        bundleFactory, defaultPageSize

      addBundlesCallback = (newBundles, begin) ->
        args = [begin, 0].concat newBundles
        $scope.bundles.splice.apply $scope.bundles, args

      $scope.addBundlesCallback = addBundlesCallback

      # Load first page
      bundlesPagination.page(1).then (data) ->
        $scope.loading = false
        addBundlesCallback data, $scope.bundles.length

      # Callback for infinite scroll
      $scope.loadMore = ->
        $scope.scrollDisabled = true
        page = if bundlesPagination.pageSize < defaultPageSize then \
          bundlesPagination.currentPage else bundlesPagination.currentPage + 1
        bundlesPagination.page(page)
          .then (bundles) ->
            addBundlesCallback bundles, $scope.bundles.length
            $scope.scrollDisabled = false

