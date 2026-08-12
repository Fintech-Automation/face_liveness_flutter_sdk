import 'package:face_liveness_flutter_sdk/face_liveness_flutter_sdk.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_brand.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_flow.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_localization.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_theme.dart';
import 'package:flutter/material.dart';

class FaceLivenessPage extends StatefulWidget {
  const FaceLivenessPage({
    required this.verificationToken,
    this.brandName,
    this.brandLogoUrl,
    this.brandSecureLabel,
    this.skipIntro = false,
    this.skipPrepare = false,
    this.primary,
    this.secondary,
    this.heading,
    this.localization,
    this.captureText,
    super.key,
  });

  final String verificationToken;
  final String? brandName;
  final String? brandLogoUrl;
  final String? brandSecureLabel;

  final bool skipIntro;
  final bool skipPrepare;

  final String? primary;
  final String? secondary;
  final String? heading;

  final Map<String, String>? captureText;

  final LivenessLocalization? localization;

  @override
  State<FaceLivenessPage> createState() => _FaceLivenessPageState();
}

class _FaceLivenessPageState extends State<FaceLivenessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Face Liveness')),
      body: FaceLivenessWidget(
        verificationToken: widget.verificationToken,
        brand: LivenessBrand(
          name: widget.brandName,
          logoUrl: widget.brandLogoUrl?.isNotEmpty == true
              ? Uri.parse(widget.brandLogoUrl!)
              : null,
          secureLabel: widget.brandSecureLabel,
        ),
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
        localization: widget.localization,
        captureText: widget.captureText,
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
