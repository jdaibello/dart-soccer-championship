import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_soccer_championship/app/config/application_config.dart';
import 'package:dart_soccer_championship/app/middlewares/cors/cors_middleware.dart';
import 'package:dart_soccer_championship/app/middlewares/default_content_type/default_content_type_middleware.dart';
import 'package:dart_soccer_championship/app/middlewares/security/security_middleware.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

const _hostname = '0.0.0.0';

Future<void> main(List<String> args) async {
  var parser = ArgParser()..addOption('port', abbr: 'p');
  var result = parser.parse(args);

  var portStr = result['port'] ?? Platform.environment['PORT'] ?? '8080';
  var port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number');
    exitCode = 64; // 64: Command line usage error
    return;
  }

  final router = Router();
  final appConfig = ApplicationConfig();
  await appConfig.loadApplicationConfig(router);

  final getIt = GetIt.I;

  var handler = const shelf.Pipeline()
      .addMiddleware(CorsMiddleware().handler)
      .addMiddleware(
        DefaultContentTypeMiddleware(
          'application/json;charset=utf-8',
        ).handler,
      )
      .addMiddleware(SecurityMiddleware(getIt.get()).handler)
      .addMiddleware(shelf.logRequests())
      .addHandler(router);

  var server = await io.serve(handler, _hostname, port);
  print('Serving at http://${server.address.host}:${server.port}');
}
