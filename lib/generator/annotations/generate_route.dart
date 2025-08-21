/// An annotation to generate routes for a sub-application.
/// This annotation is used to mark a class that will be processed by the code generator
/// to create the necessary routing logic for a sub-application in a Flutter project.
/// The generated routes will be based on the class name and its properties.
library;

import 'package:sub_app_core/generator/models/extra_model.dart';

class GenerateRoute {
  /// The name of the route.
  /// This is typically used to identify the route in the application.
  /// It should be a unique identifier for the route.
  final String routeName;

  /// The path of the route.
  /// This is the URL path that the route will respond to.
  /// It should be a valid path that can be used in the application's routing system.
  final String routePath;

  ///
  final bool addExtra;
  final ExtraModel? extraModel;

  /// Creates an instance of [GenerateRoute].
  /// This constructor requires both [routeName] and [routePath]
  /// to be provided, ensuring that the route can be uniquely identified and accessed.
  ///
  /// [routeName] should be a descriptive name for the route,
  ///
  /// [routePath] should be a valid path string.
  ///
  /// Example:
  /// ```dart
  /// @GenerateRoute(routeName: 'Home', routePath: '/home')
  /// class HomeView {}
  /// ```
  const GenerateRoute({
    required this.routeName,
    required this.routePath,
    this.addExtra = false,
    this.extraModel,
  });
}
