# Wine Cellar Application #

The original Wine Cellar application is documented [here](http://coenraets.org/blog/2012/02/sample-application-with-angular-js/).

It has been updated to Angular 1.0.2, and some new features have been implemented.

This is sample CRUD application built with Angular.js.

* Routing, Controllers, Modules, Services
* List, view, create, update, delete functions with $resource
* RESTlike API built with SlimPHP
* event emission which let controllers communicate
* directive example


Set Up:

1. Create a MySQL database name "cellar".
2. Execute cellar.sql to create and populate the "wine" table:

	mysql cellar -uroot < cellar.sql


