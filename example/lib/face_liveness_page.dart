import 'package:face_liveness_flutter_sdk/face_liveness_flutter_sdk.dart';
import 'package:face_liveness_flutter_sdk/models/face_liveness_env.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_brand.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_flow.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_theme.dart';
import 'package:flutter/material.dart';

class FaceLivenessPage extends StatefulWidget {
  const FaceLivenessPage({
    required this.launchToken,
    this.brandName,
    this.brandLogoUrl,
    this.brandSecureLabel,
    this.skipIntro = false,
    this.skipPrepare = false,
    this.primary,
    this.secondary,
    this.heading,
    super.key,
  });

  final String launchToken;
  final String? brandName;
  final String? brandLogoUrl;
  final String? brandSecureLabel;

  final bool skipIntro;
  final bool skipPrepare;

  final String? primary;
  final String? secondary;
  final String? heading;

  @override
  State<FaceLivenessPage> createState() => _FaceLivenessPageState();
}

class _FaceLivenessPageState extends State<FaceLivenessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Face Liveness')),
      body: FaceLivenessWidget(
        env: FaceLivenessEnv.dev,
        launchToken: widget.launchToken,
        brand: LivenessBrand(
          name: widget.brandName,
          logoUrl: widget.brandLogoUrl?.isNotEmpty == true
              ? Uri.parse(widget.brandLogoUrl!)
              : null,
          secureLabel: widget.brandSecureLabel,
        ),
        // backendUrl: 'https://your-backend.example.com',
        // tenant: 'actc',
        flow: LivenessFlow(
          skipIntro: widget.skipIntro,
          skipPrepare: widget.skipPrepare,
        ),
        theme: LivenessTheme(
          colors: LivenessThemeColors(
            primary: widget.primary,
            secondary: widget.secondary,
            heading: widget.heading,
          ),
          shape: LivenessThemeShape(radius: 100),
          typography: LivenessThemeTypography(
            fontFamily: "Inter, system-ui, sans-serif",
          ),
        ),
        // localization: LivenessLocalization(
        //   intro: LivenessLocalizationIntro(
        //     title: '1',
        //     eyebrow: '2',
        //     body: '3',
        //     cta: '4',
        //     trustLabel: '5',
        //   ),
        //   prepare: LivenessLocalizationPrepare(
        //     eyebrow: '1',
        //     title: '2',
        //     cta: '3',
        //     backLabel: '4',
        //     tips: [
        //       LivenessLocalizationPageElements(title: 't1', body: 'b1'),
        //       LivenessLocalizationPageElements(title: 't2', body: 'b3'),
        //       LivenessLocalizationPageElements(title: 't3', body: 'b3'),
        //       LivenessLocalizationPageElements(title: 't4', body: 'b4'),
        //     ],
        //   ),
        //   starting: LivenessLocalizationPageElements(
        //     title: 'starting',
        //     body: 'starting body',
        //   ),
        //   processing: LivenessLocalizationPageElements(
        //     title: 'processing',
        //     body: 'processing body',
        //   ),
        //   success: LivenessLocalizationResultElements(
        //     title: 'success',
        //     body: 'success body',
        //     cta: 'success cta',
        //   ),
        //   fail: LivenessLocalizationResultElements(
        //     title: 'fail',
        //     body: 'fail body',
        //     cta: 'fail cta',
        //   ),
        //   cameraPermission: LivenessLocalizationPageElements(
        //     title: 'cameraPermission',
        //     body: 'cameraPermission body',
        //   ),
        // ),
        // captureText: {
        //   'hintCenterFaceText': 'Center your face test',
        //   'hintTooCloseText': 'Move back test',
        //   'hintTooFarText': 'Move closer test',
        //   'hintHoldFaceForFreshnessText': 'Hold still test',
        // },
        onSuccess: (result) {
          print('Liveness check succeeded: ${result?.toJson()}');
        },
        onFail: (result) {
          print('Liveness check failed: ${result?.toJson()}');
        },
        onCancel: () => print('Liveness check canceled'),
        onContinue: () {
          Navigator.of(context).pop();
        },
        onError: (error) => print('Liveness check error: ${error?.toJson()}'),
        onScreenChange: (screen) => print('to Liveness Screen: ${screen}'),
        onAnalysisComplete: () => print('Liveness check Analysis Complete'),
      ),
    );
  }
}
