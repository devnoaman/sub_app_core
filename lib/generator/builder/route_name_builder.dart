import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:sub_app_core/generator/annotations/generate_route.dart';

class RouteNameBuilder extends GeneratorForAnnotation<GenerateRoute> {
  @override
  String generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    // Make sure we are only generating for classes
    if (element is! ClassElement2) {
      throw InvalidGenerationSourceError(
        '`@GenerateRoute` can only be used on classes.',
        element: element,
      );
    }

    // Read values from the annotation
    final routeName = annotation.read('routeName').stringValue;
    final routePath = annotation.read('routePath').stringValue;
    final addExtra = annotation.read('addExtra').boolValue;

    // Read the 'extraModel' field into its own reader first
    final extraModelReader = annotation.read('extraModel');
    // Check if the reader's content is null before accessing objectValue
    final extraModel = extraModelReader.isNull
        ? null
        : extraModelReader.objectValue;

    // Now, your validation can safely check the null-aware 'extraModel' variable
    if (addExtra && extraModel == null) {
      throw InvalidGenerationSourceError(
        '`addExtra` is true but `extraModel` is null.',
        todo: 'Please provide a valid `extraModel`.',
        element: element,
      );
    }
    // Get the name of the annotated class
    final className = element.name3;
    // 2. Get the URI of the source file (e.g., 'package:jobs/views/home_view.dart')
    final sourceFileUri = buildStep.inputId.uri;
    final packageName = buildStep.inputId.package;
    // Create a camelCase variable name from the class name (e.g., HomeView -> homeViewRoute)
    final variableName =
        '${className?[0].toLowerCase()}${className?.substring(1)}Route';
    final generatedClassName =
        '${className?[0].toUpperCase()}${className?.substring(1)}Route';

    // return '''
    //   const ${variableName} = GoRoute(
    //     path: '$routePath',
    //     name: '$routeName',
    //     builder: (context, state) => const $className(),
    //   );
    // ''';

    // --- Build the output string ---
    return '''
      // GENERATED CODE - DO NOT MODIFY BY HAND
      
      import 'package:flutter/material.dart';
      import 'package:go_router/go_router.dart';
      import 'package:$packageName/router/router.dart';
      ${addExtra == true && extraModel != null ? extraModel.getField('extraRelativePath').toString() : ''}

      import '$sourceFileUri';

      /// A class that encapsulates the route definition for the [$className].
      class $generatedClassName implements AppRoute{
        $generatedClassName._();

        //instance of this route class
        static final $generatedClassName instance = $generatedClassName._();
        /// The name for this route: '$routeName'
        @override
        String get name => '$routeName';
        /// The path for this route: '$routePath'
        @override
        String get path =>  '$routePath';


        /// The full `GoRoute` object for this route.
        @override
        GoRoute get route =>  GoRoute(
          path: path,
          name: name,
          builder: (context, state) => $className(key: state.pageKey),
        );
      }
    ''';
  }
}

/// A route definition for the [$className] widget.
// final $variableName = GoRoute(
//   path: '$routePath',
//   name: '$routeName',
//   builder: (BuildContext context, GoRouterState state) {
//     return $className(key: state.pageKey,);
//   },
// );
