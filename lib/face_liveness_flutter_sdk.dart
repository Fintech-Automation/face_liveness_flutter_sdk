import 'dart:collection';
import 'dart:convert';
import 'package:face_liveness_flutter_sdk/models/face_liveness_env.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_brand.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_error_model.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_flow.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_localization.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_screen_type.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_result_model.dart';

class FaceLivenessWidget extends StatefulWidget {
  const FaceLivenessWidget({
    this.env,
    this.launchToken,
    this.brand,
    this.backendUrl,
    this.origin,
    this.tenant,
    this.flow,
    this.theme,
    this.localization,
    this.captureText,
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
  final FaceLivenessEnv? env;

  /// Preferred short-lived bearer token for backend session APIs.
  final String? launchToken;

  /// Brand shown in the SDK chrome.
  final LivenessBrand? brand;

  /// Override the environment's default FTA backend URL.
  final String? backendUrl;

  /// Optional origin/domain sent to the backend.
  final String? origin;

  /// Backend tenant namespace. Defaults to `'unifi'`.
  final String? tenant;

  /// Flow behavior, independent from visual theme.
  final LivenessFlow? flow;

  ///  Visual system tokens grouped by concern.
  final LivenessTheme? theme;

  /// SDK-owned screen copy, grouped by screen.
  final LivenessLocalization? localization;

  /// Text overrides for the camera/capture step.
  final Map<String, String>? captureText;

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
  final void Function(LivenessScreenType?)? onScreenChange;

  /// When provided, renders a "Continue" button on the success screen that calls this.
  final void Function()? onContinue;

  @override
  State<FaceLivenessWidget> createState() => _FaceLivenessWidgetState();
}

class _FaceLivenessWidgetState extends State<FaceLivenessWidget> {
  Map<String, dynamic> get parameter {
    return {
      'env': widget.env?.name,
      'launchToken': widget.launchToken,
      'brand': widget.brand?.toJson(),
      'backendUrl': widget.backendUrl,
      'origin': widget.origin,
      'tenant': widget.tenant,
      'flow': widget.flow,
      'theme': widget.theme?.toJson(),
      'localization': widget.localization?.toJson(),
      'captureText': widget.captureText,
    };
  }

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
                window.__INITIAL_NATIVE_DATA__ = '${jsonEncode(parameter)}';
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
            if (args.isNotEmpty &&
                args.first is Map &&
                (args.first as Map).containsKey('error')) {
              widget.onError?.call(
                LivenessErrorModel.fromJson(args.first['error']),
              );
            }
          },
        );
        controller.addJavaScriptHandler(
          handlerName: 'onCancel',
          callback: (args) {
            widget.onCancel?.call();
          },
        );
        controller.addJavaScriptHandler(
          handlerName: 'onAnalysisComplete',
          callback: (args) {
            widget.onAnalysisComplete?.call();
          },
        );
        controller.addJavaScriptHandler(
          handlerName: 'onScreenChange',
          callback: (args) {
            if (args.isNotEmpty &&
                args.first is Map &&
                (args.first as Map).containsKey('screen')) {
              widget.onScreenChange?.call(
                LivenessScreenType.from(args.first['screen']),
              );
            }
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
