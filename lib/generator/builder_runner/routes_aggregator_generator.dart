import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

// Factory function for build.yaml
Builder routesAggregatorBuilder(BuilderOptions options) =>
    RoutesAggregatorBuilder();

class RoutesAggregatorBuilder extends Builder {
  // This tells build_runner to trigger this builder when it finds 'lib/router/routes.dart'.
  @override
  Map<String, List<String>> get buildExtensions => {
    'lib/router/router.dart': ['lib/router/router.g.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    // The final output file will be created at lib/router/routes.g.dart
    final outputId = AssetId(
      buildStep.inputId.package,
      'lib/router/router.g.dart',
    );

    final routeFilePaths = <String>[];

    // This glob pattern `lib/**.route.dart` is designed to find all matching files
    // in any subdirectory of `lib`.
    await for (final input in buildStep.findAssets(Glob('lib/**.route.dart'))) {
      // `input.uri.toString()` creates a correct 'package:' import path.
      routeFilePaths.add(input.uri.toString());
    }

    if (routeFilePaths.isEmpty) {
      log.warning(
        "Routes Aggregator did not find any '.route.dart' files to process.",
      );
      return;
    }

    // Build the content of the final Routes class.
    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND\n');
    // buffer.writeln("import 'package:go_router/go_router.dart';\n");
    buffer.writeln(
      "import 'package:${buildStep.inputId.package}/router/router.dart';\n",
    );
    //

    buffer.writeln("//import all the required paths");

    routeFilePaths.forEach((path) => buffer.writeln("import '$path';"));
    buffer.writeln('''
/// The [Routes] class provides static access to all route instances used in the application.
/// 
/// This class is auto-generated and should not be modified by hand. It imports all the required
/// route files and exposes each route as a static final instance for easy access throughout the app.
/// 
/// - Each route (e.g., `HomeViewRoute`, `WorksViewRoute`) is imported and exposed as a static field.
/// - The `all` list contains all route instances, which can be used for route registration or iteration.
/// 
/// Example usage:
/// ```dart
/// final homeRoute = Routes.homeViewInstance;
/// final allRoutes = Routes.all;
/// ```
''');

    buffer.writeln('\nclass Routes {');
    buffer.writeln('  Routes._();\n');

    for (final path in routeFilePaths) {
      // This logic robustly gets the filename (e.g., 'home_view')
      final baseName = p
          .basenameWithoutExtension(path)
          .replaceAll('.route', '');

      // This logic converts a snake_case filename to a PascalCase class name
      // e.g., 'home_view' -> 'HomeView'
      final className = baseName
          .split('_')
          .map(
            (word) => word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1)
                : '',
          )
          .join('');
      final variableName =
          '${className?[0].toLowerCase()}${className?.substring(1)}Instance';
      // Appends 'Route.route' to the class name, e.g., 'HomeViewRoute.route'
      buffer.writeln('///Static instance of[${className}Route]');
      buffer.writeln(
        '   static final ${variableName}  =  ${className}Route.instance;',
      );
    }

    buffer.writeln('/// List containing all route instances.');
    buffer.writeln('  static final all = <AppRoute>[');

    for (final path in routeFilePaths) {
      // This logic robustly gets the filename (e.g., 'home_view')
      final baseName = p
          .basenameWithoutExtension(path)
          .replaceAll('.route', '');

      // This logic converts a snake_case filename to a PascalCase class name
      // e.g., 'home_view' -> 'HomeView'
      final className = baseName
          .split('_')
          .map(
            (word) => word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1)
                : '',
          )
          .join('');

      // Appends 'Route.route' to the class name, e.g., 'HomeViewRoute.route'
      buffer.writeln('    ${className}Route.instance,');
    }

    buffer.writeln('  ];');
    buffer.writeln('}');

    await buildStep.writeAsString(outputId, buffer.toString());
  }
}
