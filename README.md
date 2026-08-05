# FTA Face Liveness SDK Overview

`@fintech-automation/face_liveness_flutter_SDK` is a branded Flutter SDK around a managed
face liveness capture engine. It provides:

- FTA backend session creation and result lookup.
- Built-in runtime configuration.
- Branded wrapper screens before and after the camera capture step.
- Grouped `brand`, `theme`, `localization`, `captureText`, and `callbacks`
  options for readable host integration.

The flow is:

```text
intro -> prepare -> capture -> processing -> success | fail | error
```

## Installation

```yaml
face_liveness_flutter_sdk:
    git:
        url: https://github.com/Fintech-Automation/face_liveness_flutter_sdk.git
        ref: 1.0.0
```

## Usage

```dart
import 'package:face_liveness_flutter_sdk/face_liveness_flutter_sdk.dart';
import 'package:face_liveness_flutter_sdk/models/liveness_brand.dart';

FaceLivenessWidget(
    launchToken: 'YOUR_LAUNCH_TOKEN',
    brand: LivenessBrand(
        name: widget.brandName,
        logoUrl: widget.brandLogoUrl?.isNotEmpty == true
            ? Uri.parse(widget.brandLogoUrl!)
            : null,
        secureLabel: widget.brandSecureLabel,
    ),
    backendUrl: 'YOUR_BACKEND_URL',
    tenant: 'YOUR_TENANT',
    onSuccess: (result) => print('Liveness check succeeded: ${result?.toJson()}'),
    onFail: (result) => ('Liveness check failed: ${result?.toJson()}'),
    onCancel: () => print('Liveness check canceled'),
    onContinue: () => print('Liveness continue'),
    onError: (error) => print('Liveness check error: ${error?.toJson()}'),
    onScreenChange: (screen) => print('to Liveness Screen: ${screen}'),
    onAnalysisComplete: () => print('Liveness check Analysis Complete'),
),
```

## Authentication Token

Obtain a `launchToken` before rendering the component, then pass it through
the `launchToken` prop. For the API request and response details, refer to the
[UniFi Face Liveness API documentation](https://api-docs.accelerationcloud.com/resource/unifi-face-liveness).


## Component Props

Top-level props are reserved for session/runtime parameters:

### Required Backend Parameters

To communicate with the Face Liveness backend, pass all of the following
parameters explicitly. The liveness session cannot be created or queried
correctly without valid values for them.

| Parameter | Purpose |
| --- | --- |
| `launchToken` | Bearer token used to authenticate backend requests. |
| `backendUrl` | Face Liveness backend URL for the selected deployment. |
| `tenant` | Tenant namespace used to build the backend API path. |

| Prop           | Type                     | Required | Default        | Description                                     |
| -------------- | ------------------------ | -------- | -------------- | ----------------------------------------------- |
| `launchToken`  | `String`                 | Yes      | none           | Bearer token used to authenticate backend APIs. |
| `backendUrl`   | `String`                 | Yes      | production URL | Face Liveness backend URL.                      |
| `tenant`       | `String`                 | Yes      | `'unifi'`      | Tenant namespace used in the backend API path.  |
| `flow`         | `LivenessFlow`           | No       | SDK defaults   | Flow behavior.                                  |
| `brand`        | `LivenessBrand`          | No       | SDK defaults   | Brand shown in the SDK header.                  |
| `theme`        | `LivenessTheme`          | No       | SDK defaults   | Visual system tokens.                           |
| `localization` | `LivenessLocalization`   | No       | SDK defaults   | SDK-owned screen copy.                          |
| `captureText`  | `Map<String, String>` | No       | SDK defaults   | Text overrides for the camera/capture step.     |
| `onSuccess`    | `void Function(LivenessResultModel?)`      | No       | none           | Called after the backend returns a successful liveness result.|
| `onFail`    | `void Function(LivenessResultModel?)`      | No       | none           | Called after the backend returns a non-passing or failed result. |
| `onError`    | `void Function(LivenessErrorModel?)`      | No       | none           | Called when a session, camera, capture, or result-fetch error occurs. |
| `onCancel`    | `void Function()`      | No       | none           | Called when the user cancels the live capture flow. |
| `onAnalysisComplete`    | `void Function()`      | No       | none           | Called when the capture detector finishes analysis and the SDK begins fetching backend results. |
| `onScreenChange`    | `void Function(LivenessScreenType)`      | No       | none           | Called when the flow changes screens. |
| `onContinue`    | `void Function()`      | No       | none           | Called when the user taps Continue on the success screen. |


Pass `backendUrl` to use the Face Liveness backend for your deployment. The
supported backend URLs are:

| Deployment | Backend URL |
| --- | --- |
| Development | `https://api-dev.accelerationcloud.info` |
| Staging | `https://api-staging.accelerationcloud.info` |
| UAT | `https://api-uat.accelerationcloud.com` |
| Production | `https://api.accelerationcloud.com` |

When omitted, `backendUrl` defaults to the production URL.


### Result Class
```dart
class LivenessResultModel {
  String? id;
  String? status;
  String? failReason;
  String? createdTime;
  String? completedTime;

  LivenessResultModel({
    this.id,
    this.status,
    this.failReason,
    this.createdTime,
    this.completedTime,
  });

}
```
## Brand Class

```dart
class LivenessBrand {
  /// Brand text in the top-left chrome. Defaults to hidden.
  final String? name;

  /// Optional image URL for the brand mark. Preferred for hosted/runtime wrappers.
  final Uri? logoUrl;

  /// Top-right security label; pass `''` to hide.
  final String? secureLabel;

  const LivenessBrand({this.name, this.logoUrl, this.secureLabel});
}
```

| Field         | Default               | Description                                                           |
| ------------- | --------------------- | --------------------------------------------------------------------- |
| `name`        | `''`                  | Your business name.                                                   |
| `logoUrl`     | none                  | Optional image URL brand mark; preferred for hosted/runtime wrappers. |
| `secureLabel` | `'Encrypted session'` | Top-right security label; pass `''` to hide.                          |

### Friendly Note 📝
> **Note:** The brand mark is rendered with the following priority:
> 
> 1. **`logoUrl`** – If no `logo` is provided, we'll display your image.
> 2. **`name`** – As a last resort, we'll generate a clean initials-based mark (e.g., "Face Liveness" → "FL") to keep the UI tidy.
> 
> This ensures your brand identity always appears — whether as a rich component, an image, or a simple text abbreviation. ✨

## Flow Class

```dart
class LivenessFlow {
  /// Starts at Prepare instead of Intro.
  final bool? skipIntro;

  /// Goes straight to capture after Intro, or immediately when `skipIntro` is also true.
  final bool? skipPrepare;

  const LivenessFlow({this.skipIntro, this.skipPrepare});

}
```

| Field         | Default | Description                                                                         |
| ------------- | ------- | ----------------------------------------------------------------------------------- |
| `skipIntro`   | `false` | Starts at Prepare instead of Intro.                                                 |
| `skipPrepare` | `false` | Goes straight to capture after Intro, or immediately when `skipIntro` is also true. |

## Theme

```dart
FaceLivenessWidget(
    theme: LivenessTheme(
        colors: LivenessThemeColors(
        primary: '#1634A4',
        secondary: '#1A3DBF',
        heading: '#111827',
        ),
        shape: LivenessThemeShape(radius: 22),
        typography: LivenessThemeTypography(
            fontFamily: "Inter, system-ui, sans-serif",
        ),
    ),
)
```

| Field                   | Default            | Description                                            |
| ----------------------- | ------------------ | ------------------------------------------------------ |
| `colors.primary`        | `'#1634A4'`        | Main brand color.                                      |
| `colors.secondary`      | `'#1A3DBF'`        | Secondary brand accent color.                          |
| `colors.heading`        | `'#111827'`        | Main heading and strong text color.                    |
| `shape.radius`          | `22`               | Root/card corner radius in pixels.                     |
| `typography.fontFamily` | Inter/system stack | Font family used by wrapper screens and capture theme. |

## Localization

`localization` customizes SDK-owned screens and is grouped by screen.

```dart
class LivenessLocalization {
  LivenessLocalizationIntro? intro;

  LivenessLocalizationPrepare? prepare;

  LivenessLocalizationPageElements? starting;

  LivenessLocalizationPageElements? processing;

  LivenessLocalizationResultElements? success;

  LivenessLocalizationResultElements? fail;

  LivenessLocalizationPageElements? cameraPermission;

  LivenessLocalization({
    this.intro,
    this.prepare,
    this.starting,
    this.processing,
    this.success,
    this.fail,
    this.cameraPermission,
  });
}

class LivenessLocalizationIntro {
  String? eyebrow;
  String? title;
  String? body;
  String? cta;

  /// Small trust line under the intro CTA; pass `''` to hide.
  String? trustLabel;

  LivenessLocalizationIntro({
    this.eyebrow,
    this.title,
    this.body,
    this.cta,
    this.trustLabel,
  });
}

class LivenessLocalizationPageElements {
  String? title;
  String? body;
  LivenessLocalizationPageElements({this.title, this.body});

}

class LivenessLocalizationPrepare {
  String? eyebrow;
  String? title;
  List<LivenessLocalizationPageElements>? tips;
  String? cta;
  String? backLabel;

  LivenessLocalizationPrepare({
    this.eyebrow,
    this.title,
    this.tips,
    this.cta,
    this.backLabel,
  });
}

class LivenessLocalizationResultElements
    extends LivenessLocalizationPageElements {
  String? cta;

  LivenessLocalizationResultElements({super.title, super.body, this.cta});

}

```

## Capture Text

`captureText` customizes the text shown during the camera/capture step.

```dart
FaceLivenessWidget(
    captureText: {
        "hintCenterFaceText": "Center your face",
        "hintTooCloseText": "Move back",
        "hintTooFarText": "Move closer",
        "hintHoldFaceForFreshnessText": "Hold still"
    },
)
```


## Notes

- The camera capture step owns the camera oval geometry and liveness model flow.
  This SDK themes the surrounding UI and supported capture theme tokens.
- The underlying capture runtime uses process-global client configuration. If a
  host app also configures the same provider runtime, mount this SDK with that
  shared global behavior in mind.
- Camera capture requires browser camera permission, HTTPS in production, WebGL,
  and network access to liveness assets.
- Bundled runtime ids are public client identifiers. Privileged operations stay
  on the FTA backend.

## License

This repository includes the FinTech Face Liveness SDK, which is licensed under a Commercial License Agreement. See [COMMERCIAL-LICENSE.md](./COMMERCIAL-LICENSE.md) for full terms.

Use of this SDK requires explicit permission from FinTech Automation.
