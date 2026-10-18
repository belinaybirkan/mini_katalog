import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:mini_katalog/app.dart';

void main() {
  // Kullanılan yazı tipi ve görsellerin lisanslarını uygulamaya kaydeder.
  LicenseRegistry.addLicense(() async* {
    final poppins = await rootBundle.loadString(
      'assets/licenses/Poppins-OFL.txt',
    );
    yield LicenseEntryWithLineBreaks(['Poppins'], poppins);

    final fluentEmoji = await rootBundle.loadString(
      'assets/licenses/FluentEmoji-MIT.txt',
    );
    yield LicenseEntryWithLineBreaks(['Fluent Emoji'], fluentEmoji);
  });

  runApp(const MiniKatalogApp());
}
