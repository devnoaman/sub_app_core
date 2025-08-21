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
    'lib/router/routes.dart': ['lib/router/routes.g.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    // The final output file will be created at lib/router/routes.g.dart
    final outputId = AssetId(
      buildStep.inputId.package,
      'lib/router/routes.g.dart',
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
    buffer.writeln("import 'package:go_router/go_router.dart';\n");
    buffer.writeln("import 'package:jobs/router/routes.dart';\n");
    routeFilePaths.forEach((path) => buffer.writeln("import '$path';"));

    buffer.writeln('\nclass Routes {');
    buffer.writeln('  Routes._();\n');
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
