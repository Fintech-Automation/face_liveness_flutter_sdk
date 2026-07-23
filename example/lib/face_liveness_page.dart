import 'package:face_liveness_flutter_sdk/face_liveness_flutter_sdk.dart';
import 'package:face_liveness_flutter_sdk/models/face_liveness_env.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_flow.dart';
import 'package:flutter/material.dart';

class FaceLivenessPage extends StatefulWidget {
  const FaceLivenessPage({required this.launchToken, super.key});

  final String launchToken;

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
        logoUrl:
            'https://accloud-public-storage-dev1.s3.us-east-2.amazonaws.com/REx0xk8bC8_tenants/GBX/Fintech_6_pwo4ga.png',
        secureLabel: 'ZXC',
        // backendUrl: 'https://your-backend.example.com',
        // tenant: 'actc',
        flow: LivenessFlow(skipIntro: true, skipPrepare: false),
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
