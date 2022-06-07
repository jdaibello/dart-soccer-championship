import 'package:dotenv/dotenv.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtHelper {
  static final env = DotEnv(includePlatformEnvironment: true)..load();

  static final _jwtSecret = env['JWT_SECRET']!;

  JwtHelper._();

  static JwtClaim getClaims(String token) {
    return verifyJwtHS256Signature(token, _jwtSecret);
  }
}
