import 'package:sub_app_core/constants.dart';
// import 'sub_app_core.dart' as bin;
import './launcher.dart' as launcher;

void main(List<String> arguments) {
  print(introMessage('packageVersion'));
  // bin.main(arguments);
  launcher.main(arguments);
}
