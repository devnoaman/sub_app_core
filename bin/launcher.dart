import 'dart:io';

Future<void> main(List<String> arguments) async {
  print(
    'This command is deprecated and replaced with "flutter pub run flutter_launcher_icons"',
  );
  // Define the file path you want to touch
  final filePath = 'lib/router/router.dart';
  final fileContent = """
import 'package:go_router/go_router.dart';

/// An abstract class that defines the contract for all route definitions.
///
/// Any generated route class will implement this, ensuring it provides
/// a path, a name, and a GoRoute object.
abstract class AppRoute {
  /// The path of the route (e.g., '/home').
  String get path;

  /// The name of the route (e.g., 'Home Page').
  String get name;

  /// The configured GoRoute object for navigation.
  GoRoute get route;
}
""";

  final file = File(filePath);

  try {
    // Create a File object

    // Check if the file exists
    if (await file.exists()) {
      print('File already exists. "Touching" it by doing nothing.');
    } else {
      // If the file doesn't exist, create it.
      await file.create();
      print('File created successfully at $filePath');
    }
  } catch (e) {
    print('An error occurred: $e');
  }

  await file.parent.create(recursive: true);
  await file.writeAsString(fileContent);

  print('\nRunning build_runner...');
  try {
    final result = await Process.run('dart', [
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ], runInShell: true);

    // Print the output of the command
    stdout.write(result.stdout);
    stderr.write(result.stderr);

    // Check the exit code to see if it was successful
    if (result.exitCode == 0) {
      print('\nbuild_runner completed successfully! ✅');
    } else {
      print('\nbuild_runner failed with exit code ${result.exitCode} ❌');
    }
  } catch (e) {
    print('\nAn error occurred while running build_runner: $e 💥');
  }
}
