import 'package:dotenv/dotenv.dart';

class ApplicationConfig {
  Future<void> loadApplicationConfig() async {
    final env = DotEnv(includePlatformEnvironment: true)..load();
  }
}
