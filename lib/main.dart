// depending on if the code is executed by the browser the mobile or web version of the app will be executed
import 'main_mobile.dart' if (dart.library.html) 'main_web.dart';

void main() => start();
