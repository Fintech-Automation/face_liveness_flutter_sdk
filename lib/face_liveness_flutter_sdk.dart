import 'dart:collection';
import 'dart:convert';
import 'package:face_liveness_flutter_sdk/models/liveness_brand.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_error_model.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_flow.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_localization.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_screen_type.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_session_status.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_result_model.dart';

class FaceLivenessWidget extends StatefulWidget {
  const FaceLivenessWidget({
    required this.verificationToken,
    this.brand,
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
    this.onSessionStatusChange,
    super.key,
  });

  /// Bearer token used to authenticate backend APIs.
  final String verificationToken;

  /// Brand shown in the SDK chrome.
  final LivenessBrand? brand;

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

  /// Called after the SDK validates the token/session state. status indicates the session state, and isEligible indicates whether the session is eligible for verification.
  final void Function(LivenessSessionStatus?)? onSessionStatusChange;

  @override
  State<FaceLivenessWidget> createState() => _FaceLivenessWidgetState();
}

class _FaceLivenessWidgetState extends State<FaceLivenessWidget> {
  Map<String, dynamic> get parameter {
    return {
      'verificationToken': widget.verificationToken,
      'brand': widget.brand?.toJson(),
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
                window.__INITIAL_NATIVE_DATA__ = `${jsonEncode(parameter)}`;
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

        controller.addJavaScriptHandler(
          handlerName: 'onSessionStatusChange',
          callback: (args) {
            print(args);
            if (args.isNotEmpty && args[0] is Map<String, dynamic>) {
              if (args[0].containsKey('result')) {
                Map<String, dynamic> result = args[0]['result'];
                LivenessSessionStatus livenessStatus =
                    LivenessSessionStatus.fromJson(result);
                widget.onSessionStatusChange?.call(livenessStatus);
              }
            }
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
        print('error: $message');
      },
      onReceivedHttpError: (controller, request, errorResponse) {
        print('HTTP error: ${errorResponse.statusCode} ${errorResponse.data}');
      },
      onReceivedServerTrustAuthRequest: (controller, challenge) async {
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
