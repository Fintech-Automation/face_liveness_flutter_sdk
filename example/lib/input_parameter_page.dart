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
  TextEditingController token = TextEditingController(
    text:
        'Bearer eyJraWQiOiJqXzJIZDZWRnhQbjFVT0NqZG9mNlVYR1dCbXcyWWlicEEteGJ1cDE4UHBNIiwiYWxnIjoiUlMyNTYifQ.eyJ2ZXIiOjEsImp0aSI6IkFULmtSazVWbXRBaXU2a19NTXQySHZ1WGJrbHBob2ZSSEZtbHFGbnl1bTdMTWciLCJpc3MiOiJodHRwczovL2ZpbnRlY2hzc28ub2t0YXByZXZpZXcuY29tL29hdXRoMi9hdXNlNnY2MmljQ0R0aTRZcTFkNyIsImF1ZCI6ImFwaTovL3RlbmFudCIsImlhdCI6MTc4NDgxOTg1NSwiZXhwIjoxNzg0ODI3MDU1LCJjaWQiOiIwb2FoZTU3dmNla0FrSGk5UDFkNyIsInVpZCI6IjAwdWU3NXoxdjB0bWI0RWlOMWQ3Iiwic2NwIjpbIm9wZW5pZCJdLCJhdXRoX3RpbWUiOjE3ODQ4MTk4NTEsInN1YiI6ImJ5YW5AZmludGVjaGF1dG9tYXRpb24uY29tIiwiY2xpZW50SWQiOiIwb2FoZTU3dmNla0FrSGk5UDFkNyJ9.E1GdlKGPqFOyH2hM6KuImZ4A-aGcPXLQfmGt-M2U0ANuUA_iCnQPSIegJWFbdR45mMfusGKzP_x6wcawCgdnmzykcG6g2jF5ojLLIIK-T9meDF53kKEtWXjdZq8tOWfHsS2YKY9a3F2DZvC6Cz0M39JKBE4LdJoI1w7aJ4sIFutUTamG523wSzcagvla0D2l5T7Ujx9DS80aBTTcdJG4bO6h3M5MAzEbHYJf44zRz1a1ZsYn6cujtiZ0lBqPfOkjxjfXS0wis5m0RoH9vhb6GDLZ5f1x7s-ju3RZR-v41CWnqKPr3aCNfYy32FIOYkenoIKQGL_Sn0FpHX9FsCW9Pg',
  );

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
