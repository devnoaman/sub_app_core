import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import '../builder/route_name_builder.dart';

// import 'package:build/build.dart';
// import 'package:source_gen/source_gen.dart';
// import 'package:sub_app_core/generator/builder/route_name_builder.dart';

// Use SharedPartBuilder and give it a unique partId
// Builder routeNameBuilder(BuilderOptions options) =>
//     SharedPartBuilder([RouteNameBuilder()], 'route_name_builder');
Builder routeNameBuilder(BuilderOptions options) {
  return LibraryBuilder(
    RouteNameBuilder(),
    // Use the header property to add imports to the top of the generated file
    // header: "import 'package:go_router/go_router.dart';",
    generatedExtension:
        '.route.dart', // A custom extension for the standalone file
  );
}
