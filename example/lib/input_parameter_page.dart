import 'package:example/face_liveness_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class InputParameterPage extends StatefulWidget {
  const InputParameterPage({super.key});

  @override
  State<InputParameterPage> createState() => _InputParameterPageState();
}

class _InputParameterPageState extends State<InputParameterPage> {
  TextEditingController token = TextEditingController();

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
          'external_id': 'annijsuklsssiu',
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
      if (data.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(data.body);
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
          print(
            'Failed to create liveness link: ${responseData['message'] ?? 'Unknown error'}',
          );
        }
      } else {
        print('Failed to create liveness link: ${data.statusCode}');
      }
    } on SocketException catch (e) {
      print('Failed to create liveness link: ${e.message}');
    } on http.ClientException catch (e) {
      print('Failed to create liveness link: ${e.message}');
    }
    return null;
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
              decoration: InputDecoration(label: Text('Token')),
            ),
            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
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
                            builder: (context) =>
                                FaceLivenessPage(launchToken: launchToken!),
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
