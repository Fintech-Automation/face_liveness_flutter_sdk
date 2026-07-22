import 'dart:collection';

import 'package:face_liveness_flutter_sdk/models/liveness_error_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_result_model.dart';

class FaceLivenessWidget extends StatefulWidget {
  const FaceLivenessWidget({
    this.env,
    this.launchToken,
    this.logoUrl,
    this.secureLabel,
    this.backendUrl,
    this.onSuccess,
    this.onFail,
    this.onError,
    this.onCancel,
    this.onAnalysisComplete,
    this.onScreenChange,
    this.onContinue,
    super.key,
  });

  /// Selects the FTA backend URL + bundled Cognito config. Default 'prod'.
  final String? env;

  /// Preferred short-lived bearer token for backend session APIs.
  final String? launchToken;

  /// Optional brand mark shown in the top-left wrapper chrome. It is an image URL.
  final String? logoUrl;

  final String? secureLabel;

  /// Override the environment's default FTA backend URL.
  final String? backendUrl;

  ///Fired when liveness passes (`result.passed === true`).
  final void Function(LivenessResultModel? result)? onSuccess;

  /// Fired when liveness fails (`result.passed === false`).
  final void Function(LivenessResultModel? result)? onFail;

  /// Fired on any error (session creation, results fetch, or AWS detector error).
  final void Function(LivenessErrorModel? error)? onError;

  /// Fired when the user cancels the AWS capture.
  final void Function()? onCancel;

  /// Low-level AWS hook fired when capture completes, before results are fetched.
  final void Function()? onAnalysisComplete;

  /// Fired on every screen transition (telemetry).
  final void Function()? onScreenChange;

  /// When provided, renders a "Continue" button on the success screen that calls this.
  final void Function()? onContinue;

  @override
  State<FaceLivenessWidget> createState() => _FaceLivenessWidgetState();
}

class _FaceLivenessWidgetState extends State<FaceLivenessWidget> {
  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      // initialUrlRequest: URLRequest(url: WebUri('https://192.168.31.17:5173/')),
      initialFile:
          'packages/face_liveness_flutter_sdk/assets/html/face_liveness.html',
      initialSettings: InAppWebViewSettings(
        mediaPlaybackRequiresUserGesture: false,
        allowsInlineMediaPlayback: true,
        sharedCookiesEnabled: true,
        domStorageEnabled: true,
        allowFileAccessFromFileURLs: true,
        allowUniversalAccessFromFileURLs: true,
        useShouldInterceptAjaxRequest: true,
      ),
      initialUserScripts: UnmodifiableListView<UserScript>([
        UserScript(
          source:
              """
                window.__INITIAL_NATIVE_DATA__ = {
                      env: '${widget.env}',
                      launchToken: '${widget.launchToken}',
                      logoUrl: '${widget.logoUrl}',
                      secureLabel: '${widget.secureLabel}',
                    };
              """,
          injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
        ),
      ]),
      onWebViewCreated: (controller) async {
        controller.addJavaScriptHandler(
          handlerName: 'onSuccess',
          callback: (args) {
            if (args.isNotEmpty && args[0] is Map<String, dynamic>) {
              if (args[0].containsKey('result')) {
                Map<String, dynamic> result = args[0]['result'];
                LivenessResultModel livenessResult =
                    LivenessResultModel.fromJson(result);
                widget.onSuccess?.call(livenessResult);
              }
            }
          },
        );
        controller.addJavaScriptHandler(
          handlerName: 'onFail',
          callback: (args) {
            if (args.isNotEmpty && args[0] is Map<String, dynamic>) {
              if (args[0].containsKey('result')) {
                Map<String, dynamic> result = args[0]['result'];
                LivenessResultModel livenessResult =
                    LivenessResultModel.fromJson(result);
                widget.onFail?.call(livenessResult);
              }
            }
          },
        );
        controller.addJavaScriptHandler(
          handlerName: 'onError',
          callback: (args) {
            print('onError called with args: $args');
          },
        );
        controller.addJavaScriptHandler(
          handlerName: 'onCancel',
          callback: (args) {
            print('onCancel called with args: $args');
            widget.onCancel?.call();
          },
        );
        controller.addJavaScriptHandler(
          handlerName: 'onAnalysisComplete',
          callback: (args) {
            print('onAnalysisComplete called with args: $args');
          },
        );
        controller.addJavaScriptHandler(
          handlerName: 'onScreenChange',
          callback: (args) {
            print('onScreenChange called with args: $args');
          },
        );
        controller.addJavaScriptHandler(
          handlerName: 'onContinue',
          callback: (args) {
            widget.onContinue?.call();
          },
        );
      },
      onLoadStart: (controller, url) async {},
      onLoadStop: (controller, url) {},
      onNavigationResponse: (controller, navigationResponse) async {
        return NavigationResponseAction.ALLOW;
      },
      onConsoleMessage: (controller, consoleMessage) {
        print('Console message: ${consoleMessage.message}');
      },
      onReceivedError: (controller, request, message) {
        print('加载失败: $message');
      },
      onReceivedHttpError: (controller, request, errorResponse) {
        print('HTTP错误: ${errorResponse.statusCode} ${errorResponse.data}');
      },
      onReceivedServerTrustAuthRequest: (controller, challenge) async {
        // 直接放行，接受所有服务器的证书
        return ServerTrustAuthResponse(
          action: ServerTrustAuthResponseAction.PROCEED,
        );
      },
      onPermissionRequest: (controller, permissionRequest) async {
        final resources = <PermissionResourceType>[];
        if (permissionRequest.resources.contains(
          PermissionResourceType.CAMERA,
        )) {
          final cameraStatus = await Permission.camera.request();
          if (!cameraStatus.isDenied) {
            resources.add(PermissionResourceType.CAMERA);
          }
        }
        return PermissionResponse(
          action: PermissionResponseAction.GRANT,
          resources: permissionRequest.resources,
        );
      },
    );
  }
}
