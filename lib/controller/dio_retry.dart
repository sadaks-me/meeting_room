import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioConnectivityRequestRetry {
  final Dio dio;
  final Connectivity connectivity;

  DioConnectivityRequestRetry({
    @required this.dio,
    @required this.connectivity,
  });

  Future<Response> scheduleRequestRetry(
      BuildContext context, RequestOptions requestOptions) async {
    final responseCompleter = Completer<Response>();
    StreamSubscription streamSubscription;
    streamSubscription = connectivity.onConnectivityChanged.listen(
      (connectivityResult) async {
        if (connectivityResult != ConnectivityResult.none) {
          streamSubscription.cancel();
          responseCompleter.complete(
            dio.request(
              requestOptions.path,
              cancelToken: requestOptions.cancelToken,
              data: requestOptions.data,
              onReceiveProgress: requestOptions.onReceiveProgress,
              onSendProgress: requestOptions.onSendProgress,
              queryParameters: requestOptions.queryParameters,
              options: requestOptions,
            ),
          );
        }
      },
    );

    return responseCompleter.future;
  }
}

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final BuildContext context;
  final DioConnectivityRequestRetry requestRetrier;

  RetryOnConnectionChangeInterceptor(
    this.context, {
    @required this.requestRetrier,
  });

  @override
  Future onError(DioError err) async {
    if (_shouldRetry(err)) {
      try {
        return requestRetrier.scheduleRequestRetry(context, err.request);
      } catch (e) {
        return e;
      }
    }
    return err;
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType.DEFAULT &&
        err.error != null &&
        err.error is SocketException;
  }
}
