'use strict';
/* http://docs.angularjs.org/#!angular.service */

// Declare app level module which depends on filters, and services
angular.module('cellar', [ 'cellar.services', 'cellar.directives' ]).
  config(['$routeProvider', function($routeProvider) {

    $routeProvider
        .when('/wines', {templateUrl:'partials/welcome.html'})
        //any route that doesn't match an available wine will result in an empty form, which can be used to add a new wine
        .when('/wines/:wineId', {templateUrl:'partials/wine-details.html', controller:WineDetailCtrl})
        .otherwise({redirectTo:'/wines'});
  }]);