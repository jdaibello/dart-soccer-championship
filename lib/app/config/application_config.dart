import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_soccer_championship/app/config/appwrite_client_configuration.dart';
import 'package:dotenv/dotenv.dart';
import 'package:get_it/get_it.dart';

class ApplicationConfig {
  Client? appwriteClient;

  Future<void> loadApplicationConfig() async {
    await _loadAppwriteConfig();
  }

  Future<void> _loadAppwriteConfig() async {
    final env = DotEnv(includePlatformEnvironment: true)..load();

    final appwriteConfig = AppwriteClientConfiguration(
      endpoint: env['APPWRITE_API_ENDPOINT']!,
      projectId: env['APPWRITE_PROJECT_ID']!,
      apiKeySecret: env['APPWRITE_API_KEY_SECRET']!,
    );

    appwriteClient = Client();

    appwriteClient!
        .setEndpoint(appwriteConfig.endpoint)
        .setProject(appwriteConfig.projectId)
        .setKey(appwriteConfig.apiKeySecret);

    GetIt.I.registerSingleton(appwriteConfig);
  }
}
