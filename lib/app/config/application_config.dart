import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_soccer_championship/app/config/appwrite_client_configuration.dart';
import 'package:dart_soccer_championship/app/config/service_locator_config.dart';
import 'package:dart_soccer_championship/app/logger/i_logger.dart';
import 'package:dart_soccer_championship/app/logger/logger_impl.dart';
import 'package:dart_soccer_championship/app/routers/router_configure.dart';
import 'package:dotenv/dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/shelf_router.dart';

class ApplicationConfig {
  Client? appwriteClient;

  Future<void> loadApplicationConfig(Router router) async {
    await _loadAppwriteConfig();
    _configLogger();
    _loadDependencies();
    _loadRoutersConfigure(router);
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

  void _configLogger() =>
      GetIt.I.registerLazySingleton<ILogger>(() => LoggerImpl());

  void _loadDependencies() => configureDependencies();

  void _loadRoutersConfigure(Router router) =>
      RouterConfigure(router).configure();
}
