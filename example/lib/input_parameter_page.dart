import 'package:example/face_liveness_page.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class InputParameterPage extends StatefulWidget {
  const InputParameterPage({super.key});

  @override
  State<InputParameterPage> createState() => _InputParameterPageState();
}

class _InputParameterPageState extends State<InputParameterPage> {
  TextEditingController token = TextEditingController(
    text:
        'Bearer eyJraWQiOiJqXzJIZDZWRnhQbjFVT0NqZG9mNlVYR1dCbXcyWWlicEEteGJ1cDE4UHBNIiwiYWxnIjoiUlMyNTYifQ.eyJ2ZXIiOjEsImp0aSI6IkFULkNlVEtpbU9uc05UVFBGMUlSNDduczNzdEMyZGV4WTdhNFJhR3o0RnhObEkiLCJpc3MiOiJodHRwczovL2ZpbnRlY2hzc28ub2t0YXByZXZpZXcuY29tL29hdXRoMi9hdXNlNnY2MmljQ0R0aTRZcTFkNyIsImF1ZCI6ImFwaTovL3RlbmFudCIsImlhdCI6MTc4NjU0MDkyMCwiZXhwIjoxNzg2NTQ4MTIwLCJjaWQiOiIwb2FoZTU3dmNla0FrSGk5UDFkNyIsInVpZCI6IjAwdWU3NXoxdjB0bWI0RWlOMWQ3Iiwic2NwIjpbIm9wZW5pZCJdLCJhdXRoX3RpbWUiOjE3ODY1NDA5MTgsInN1YiI6ImJ5YW5AZmludGVjaGF1dG9tYXRpb24uY29tIiwiY2xpZW50SWQiOiIwb2FoZTU3dmNla0FrSGk5UDFkNyJ9.Dq4HHFUxMwGPvm1JXHGo9MosBWqxwuyDDsO1sXr_mZwXXQPta4oN7MGCkhi4B12UEZQg9TVVT6Odt2KF3MofdP4pogMGJRyqwQiCeaJC3E6tl9L0pNmxBCTRcchTaS1Sjz4HNWTQk3E3zH-UPBStZZDp2gxMRwVlb3hpJoB_gpeMcUDdw360HXAB5pB1Zqkyc4oDOsjIqjM_zEdXkcPqW7C3EzK_-nictHAywP5Bo1bxgrL0EY9aHy8QLfNLm8RO6xpJMwQ_r4pmtUv0Q_eoA8Mu_38HajF1oAfWry8L2KOxsUh2IboV64sqsO1ASxA8YG7BuYbz1crQERLtZ3FACQ',
  );

  TextEditingController brandName = TextEditingController();
  TextEditingController brandLogoUrl = TextEditingController(
    text:
        'https://accloud-public-storage-dev1.s3.us-east-2.amazonaws.com/REx0xk8bC8_tenants/GBX/Fintech_6_pwo4ga.png',
  );
  TextEditingController brandSecureLabel = TextEditingController();

  TextEditingController backendUrl = TextEditingController(
    text: 'https://api-dev.accelerationcloud.info',
  );

  TextEditingController tenant = TextEditingController(text: 'unifi');

  bool skipIntro = false;
  bool skipPrepare = false;

  Color? primaryColor;
  Color? secondaryColor;
  Color? headingColor;

  TextEditingController localization = TextEditingController(
    text: """{
    "intro": {
      "eyebrow": "Identity check",
      "title": "Let's confirm it's really you",
      "body": "A quick face scan helps protect your account.",
      "cta": "Start face scan",
      "trustLabel": "Bank-grade liveness detection"
    },
    "prepare": {
      "eyebrow": "Before we start",
      "title": "Three things for a clean scan",
      "tips": [
        {
          "title": "Find good light",
          "body": "Avoid strong backlight."
        },
        {
          "title": "Clear your face",
          "body": "Remove sunglasses or masks."
        },
        {
          "title": "Hold steady",
          "body": "Keep the device at eye level."
        }
      ],
      "cta": "I'm ready",
      "backLabel": "Back"
    },
    "starting": {
      "title": "Starting camera",
      "body": "Creating a secure liveness session."
    },
    "processing": {
      "title": "Verifying your scan",
      "body": "This usually takes just a moment."
    },
    "success": {
      "title": "You're verified",
      "body": "Thanks. The liveness check was completed.",
      "cta": "Thanks. The liveness check was completed."
    },
    "fail": {
      "title": "We couldn't complete the scan",
      "body": "Move somewhere brighter and try again.",
      "cta": "Move somewhere brighter and try again."
    },
    "cameraPermission": {
      "title": "Camera access is required",
      "body": "Allow camera access, then try again."
    }
  }""",
  );

  // TextEditingController captureText = TextEditingController(
  //   text: '''{
  //   "hintCenterFaceText": "Center your face",
  //   "hintTooCloseText": "Move back",
  //   "hintTooFarText": "Move closer",
  //   "hintHoldFaceForFreshnessText": "Hold still"
  // }''',
  // );

  String? errorString;

  bool loading = false;
  Future<String?> createLivenessLink() async {
    final client = http.Client();
    try {
      http.Response data = await client.post(
        Uri.parse(
          '${backendUrl.text}/api/v1/cores/${tenant.text}/facial-liveness',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.text,
        },
        body: jsonEncode({
          'external_id': DateTime.now().microsecondsSinceEpoch,
          'brandingConfig': {
            'tenantName': valueOrDefault(
              brandName.text,
              defaultValue: 'Fintech Automation',
            ),
            'logoUrl': valueOrDefault(
              brandLogoUrl.text,
              defaultValue:
                  'https://accloud-public-storage-dev1.s3.us-east-2.amazonaws.com/REx0xk8bC8_tenants/GBX/Fintech_6_pwo4ga.png',
            ),
            'bannerUrl':
                'https://accloud-public-storage-dev1.s3.us-east-2.amazonaws.com/REx0xk8bC8_tenants/GBX/banner.png',
            'themeColor': primaryColor != null
                ? colorToHex(
                    primaryColor!,
                    includeHashSign: true,
                    enableAlpha: false,
                  )
                : '#1d4ed8',
          },
        }),
      );
      print('Liveness link statusCode: ${data.statusCode} ');
      if (data.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(data.body);
        print('Liveness link response Data : ${responseData}');
        if (responseData['code'] == 200 && responseData['data'] is Map) {
          String token = responseData['data']['session_token'];
          return token;
        } else {
          setState(() {
            errorString = responseData['error_message'];
          });
        }
      } else {
        setState(() {
          errorString = data.body;
        });
      }
    } on SocketException catch (e) {
      setState(() {
        errorString = e.message;
      });
    } on http.ClientException catch (e) {
      setState(() {
        errorString = e.message;
      });
    }
    return null;
  }

  String? valueOrDefault(String value, {String? defaultValue}) {
    if (value.isNotEmpty) {
      return value;
    }
    return defaultValue;
  }

  Future<Color?> selectColors(BuildContext context) async {
    Color? color;
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: Colors.white,
              onColorChanged: (Color value) {
                color = value;
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop(color);
              },
            ),
          ],
        );
      },
    );
  }

  Widget selectColorWidget({
    required String title,
    Color? color,
    void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: ColoredBox(
        color: color ?? Colors.transparent,
        child: Container(padding: EdgeInsets.all(12), child: Text(title)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input Parameters')),
      body: Form(
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            TextFormField(
              controller: token,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(label: Text('Token')),
            ),
            SizedBox(height: 16),
            Text(
              'Parameters',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: backendUrl,
              decoration: InputDecoration(label: Text('Backend Url')),
            ),
            TextFormField(
              controller: tenant,
              decoration: InputDecoration(label: Text('Tenant')),
            ),
            TextFormField(
              controller: localization,
              minLines: 10,
              maxLines: 1000,
              decoration: InputDecoration(label: Text('Localization')),
            ),
            // TextFormField(
            //   controller: captureText,
            //   minLines: 1,
            //   maxLines: 1000,
            //   decoration: InputDecoration(label: Text('Capture Text')),
            // ),
            SizedBox(height: 16),
            Text(
              'Brand',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: brandName,
              decoration: InputDecoration(label: Text('Name')),
            ),
            TextFormField(
              controller: brandLogoUrl,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(label: Text('Logo Url')),
            ),
            TextFormField(
              controller: brandSecureLabel,
              decoration: InputDecoration(label: Text('Secure Label')),
            ),
            SizedBox(height: 16),
            Text(
              'Flow',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: Text('Skip Intro'),
              value: skipIntro,
              onChanged: (value) {
                setState(() {
                  skipIntro = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Skip Prepare'),
              value: skipPrepare,
              onChanged: (value) {
                setState(() {
                  skipPrepare = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text(
              'Theme',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            selectColorWidget(
              title: 'Primary',
              color: primaryColor,
              onTap: () {
                selectColors(context).then(
                  (value) => setState(() {
                    primaryColor = value;
                  }),
                );
              },
            ),
            selectColorWidget(
              title: 'Secondary Color',
              color: secondaryColor,
              onTap: () {
                selectColors(context).then(
                  (value) => setState(() {
                    secondaryColor = value;
                  }),
                );
              },
            ),
            selectColorWidget(
              title: 'Heading Color',
              color: headingColor,
              onTap: () {
                selectColors(context).then(
                  (value) => setState(() {
                    headingColor = value;
                  }),
                );
              },
            ),
            if (errorString?.isNotEmpty == true)
              Text(
                'Error: $errorString',
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        loading = true;
                      });
                      String? verificationToken = await createLivenessLink();
                      setState(() {
                        loading = false;
                      });
                      if (verificationToken?.isNotEmpty == true) {
                        // Map<String, String> captureTextMap =
                        //     Map<String, String>.from(
                        //       jsonDecode(captureText.text),
                        //     );

                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) => FaceLivenessPage(
                              verificationToken: verificationToken!,
                              brandName: valueOrDefault(brandName.text),
                              brandLogoUrl: valueOrDefault(brandLogoUrl.text),
                              brandSecureLabel: valueOrDefault(
                                brandSecureLabel.text,
                              ),
                              skipIntro: skipIntro,
                              skipPrepare: skipPrepare,
                              primary: primaryColor != null
                                  ? colorToHex(
                                      primaryColor!,
                                      includeHashSign: true,
                                      enableAlpha: false,
                                    )
                                  : null,
                              secondary: secondaryColor != null
                                  ? colorToHex(
                                      secondaryColor!,
                                      includeHashSign: true,
                                      enableAlpha: false,
                                    )
                                  : null,
                              heading: headingColor != null
                                  ? colorToHex(
                                      headingColor!,
                                      includeHashSign: true,
                                      enableAlpha: false,
                                    )
                                  : null,
                              localization: LivenessLocalization.fromJson(
                                jsonDecode(localization.text),
                              ),
                              // captureText: captureTextMap,
                            ),
                          ),
                        );
                      }
                    },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
