import 'package:ecommerce_app/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

import '../robot.dart';

void main() {
  testWidgets('Golden - products list', (tester) async {
    final r = Robot(tester);
    await r.golden.loadRobotoFont(); //for font to be replaced
    await r.golden.loadMaterialIconFont(); //load icons
    await r.pumpMyApp();
    await r.golden.precacheImages();
    await expectLater(
      find.byType(MyApp),
      matchesGoldenFile(
        'products_list.png',
      ),
    );
  });
}
