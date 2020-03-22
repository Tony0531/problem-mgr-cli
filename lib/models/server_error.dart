import 'package:dio/dio.dart';

enum ServerErrorCode { userNotExists }

class ServerError extends Error {
  final ServerErrorCode code;
  final String message;

  ServerError(this.code, {this.message});

  factory ServerError.fromException(Exception e) {
    if (e is DioError) {
      if (e.response.statusCode == 500) {
        ServerErrorCode errorCode =
            errorCodeFromString(e.response.data["error"]);
        if (errorCode != null) {
          return new ServerError(errorCode,
              message: e.response.data["message"]);
        }
      }
    }

    return null;
  }

  static ServerErrorCode errorCodeFromString(String msg) {
    print(msg);
    if (msg == "UserNotExists") {
      return ServerErrorCode.userNotExists;
    }

    return null;
  }
}
