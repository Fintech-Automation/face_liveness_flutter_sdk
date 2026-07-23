import 'package:example/face_liveness_page.dart';
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
        'Bearer eyJraWQiOiIzY2E2MTI0MC01MzVkLTQyZDAtYmVjMy05NzZiNTk4ZmEwZTAiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIwb2FoZTUzajZ2bUJteTlKUTFkNyIsImF1ZCI6Imh0dHBzOi8vYXBpLmZpbnRlY2hhdXRvbWF0aW9uLmNvbSIsImNsaWVudElkIjoiMG9haGU1M2o2dm1CbXk5SlExZDciLCJleHBpcmVUaW1lIjoxNzg0ODMzOTg0LCJpc3MiOiJodHRwczovL2FwaS5maW50ZWNoYXV0b21hdGlvbi5jb20iLCJzZkNvbnRhY3RJZCI6IjI0MTAxMDE5NTg0OTk0MTMzMCIsImV4cCI6MTc4NDgzMzk4NCwiaWF0IjoxNzg0ODI2Nzg0LCJjaWQiOiIwb2FoZTUzajZ2bUJteTlKUTFkNyJ9.FGBCbPvL0bPiFgmmgo0uB7MCJviLZNWfrdYu243aH0pRWT8auxjaD_YCtimrcUOBnqL2FlQwraQi5FnYHcoc0F3N0IkDd0G-yNMzQybKdauvfgVP_S4ERI7MK5FM_f2uVpBjl4fA_mquDKfQgQUF_Bh45OpVbhM27mB14VAloAsn4aXCEFQxrG1k_RyGzAVMKc38jdEMOLuLTXkMqrjfZEJeR2Qcbd5yMfDjkw8mtbQptmoHGT5phBiwF_nxUl4c44h2KFqsVGjSY9GFHczPpn6tK_hPsemo2BU-uMYP_wQxaQToaZVBUfI0_fDHpBODgUQPQm0lBmroFHx0_ggTDA',
  );

  TextEditingController brandName = TextEditingController();
  TextEditingController brandLogoUrl = TextEditingController(
    text:
        'https://accloud-public-storage-dev1.s3.us-east-2.amazonaws.com/REx0xk8bC8_tenants/GBX/Fintech_6_pwo4ga.png',
  );
  TextEditingController brandSecureLabel = TextEditingController();

  bool skipIntro = false;
  bool skipPrepare = false;

  Color? primaryColor;
  Color? secondaryColor;
  Color? headingColor;

  String? errorString;

  bool loading = false;
  Future<String?> createLivenessLink() async {
    final client = http.Client();
    try {
      http.Response data = await client.post(
        Uri.parse(
          'https://api-dev.accelerationcloud.info/api/v1/cores/unifi/face-liveness/public-link',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token.text,
        },
        body: jsonEncode({
          'external_id': DateTime.now().microsecondsSinceEpoch,
          'public_link': 'http://localhost:5173/',
          'api_domain': 'https://api-dev.accelerationcloud.info',
          'callback_url': 'http://localhost:5173/',
          'meta': {},
          'branding': {
            'tenantName': 'Fintech Automation',
            'logoUrl':
                'https://accloud-public-storage-dev1.s3.us-east-2.amazonaws.com/REx0xk8bC8_tenants/GBX/Fintech_6_pwo4ga.png',
            'bannerUrl':
                'https://accloud-public-storage-dev1.s3.us-east-2.amazonaws.com/REx0xk8bC8_tenants/GBX/banner.png',
            'themeColor': '#1d4ed8',
          },
        }),
      );
      print('Liveness link statusCode: ${data.statusCode} ');
      if (data.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(data.body);
        print('Liveness link response Data : ${responseData}');
        if (responseData['code'] == 200) {
          String link = responseData['data'];
          print('Liveness link created successfully: $link');
          if (link.isNotEmpty) {
            String token = Uri.parse(link).queryParameters['token'].toString();
            print('Liveness token created successfully: $token');
            return token;
          } else {
            print('Failed to create liveness link: Link is empty');
          }
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

  String? valueOrEmpty(String value) {
    if (value.isNotEmpty) {
      return value;
    }
    return null;
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
            if (errorString?.isNotEmpty == true)
              Text(
                'Error: $errorString',
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            TextFormField(
              controller: token,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(label: Text('Token')),
            ),
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
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        loading = true;
                      });
                      String? launchToken = await createLivenessLink();
                      setState(() {
                        loading = false;
                      });
                      if (launchToken?.isNotEmpty == true) {
                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) => FaceLivenessPage(
                              launchToken: launchToken!,
                              brandName: valueOrEmpty(brandName.text),
                              brandLogoUrl: valueOrEmpty(brandLogoUrl.text),
                              brandSecureLabel: valueOrEmpty(
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
