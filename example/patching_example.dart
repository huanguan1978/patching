import 'package:patching/patching.dart';

void main() {
  var awesome = Awesome();
  print('awesome: ${awesome.isAwesome}');

  mainisNumBetween();
}

void mainisNumBetween() {
  bool isValid = isNumBetween(2, 1, 10);
  print('isNumBetween(2, 1, 10), $isValid');
}
