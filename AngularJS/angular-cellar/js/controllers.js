function MenuCtrl($routeParams, $location, $scope) {

    $scope.addWine = function () {
        $location.path("/wines/add");
    };

}
MenuCtrl.$inject = ['$routeParams', '$location', '$scope'];


function WineListCtrl(Wine, $location, $scope) {
    $scope.wines = Wine.api.query(); 

    $scope.$on('handleBroadcast', function() {
        $scope.wines = Wine.api.query(); 
    });   

}
WineListCtrl.$inject = ['Wine', '$location', '$scope'];


function WineDetailCtrl(Wine, $routeParams, $location, $scope) {
    $scope.wine = Wine.api.get({wineId: $routeParams.wineId}) 

    $scope.saveWine = function () {
        if ($scope.wine.id > 0)
        {
            Wine.api.update({wineId:$scope.wine.id}, $scope.wine, function (res) {
                alert('Wine ' + $scope.wine.name + ' updated'); 
                Wine.broadcastChange();
                $location.path("/wines");
                }
            );
        }
        //no match for wine means it's an empty form
        else
        {      
            Wine.api.save({}, $scope.wine, function (res) {
                alert('Wine ' + $scope.wine.name + ' created'); 
                Wine.broadcastChange();
                $location.path("/wines");
                }
            );
        }
    }

    $scope.deleteWine = function () {
        Wine.api.delete({wineId:$scope.wine.id}, function(wine) {
            alert('Wine ' + $scope.wine.name + ' deleted')
            Wine.broadcastChange();
            $location.path("/wines");
        });
    }
}
WineDetailCtrl.$inject = ['Wine', '$routeParams', '$location', '$scope'];