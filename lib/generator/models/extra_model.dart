class ExtraModel {
  /// Creates an instance of [ExtraModel].
  /// This constructor requires both [extraType] and [extraRelativePath]
  /// to be provided, ensuring that the extra model can be uniquely identified and accessed.
  /// [extraType] should be a descriptive name for the extra model,
  /// and [extraRelativePath] should be a valid relative path string.
  /// Example:
  /// ```dart
  /// ExtraModel(extraType: 'User', extraRelativePath: 'package:packagename/models/user_model/user.dart')
  /// ```
  /// @param extraType The type of the extra model.
  final String extraType;

  /// The relative path to the extra model file.
  /// This should be a valid relative path string that points to the model file.
  /// @extraRelativePath extraType The type of the extra model.
  final String extraRelativePath;

  /// Creates an instance of [ExtraModel].
  /// This constructor requires both [extraType] and [extraRelativePath]
  /// to be provided, ensuring that the extra model can be uniquely identified and accessed.
  /// [extraType] should be a descriptive name for the extra model,
  /// and [extraRelativePath] should be a valid relative path string.
  /// Example:
  /// ```dart
  /// ExtraModel(extraType: 'User', extraRelativePath: 'package:packagename/models/user_model/user.dart')
  /// ```
  ///
  const ExtraModel({required this.extraType, required this.extraRelativePath});
}
