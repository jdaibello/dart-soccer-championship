import 'package:dart_soccer_championship/app/middlewares/middlewares.dart';
import 'package:shelf/shelf.dart';

class DefaultContentType extends Middlewares {
  final String contentType;

  DefaultContentType(this.contentType);

  @override
  Future<Response> execute(Request request) async {
    final response = await innerHandler(request);

    return response.change(
      headers: {
        'content-type': contentType,
      },
    );
  }
}
