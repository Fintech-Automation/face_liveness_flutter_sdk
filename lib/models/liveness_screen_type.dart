enum LivenessScreenType {
  intro,
  prepare,
  capture,
  processing,
  success,
  fail,
  error;

  static LivenessScreenType? from(String name) {
    switch (name) {
      case 'intro':
        return LivenessScreenType.intro;
      case 'prepare':
        return LivenessScreenType.prepare;
      case 'capture':
        return LivenessScreenType.capture;
      case 'processing':
        return LivenessScreenType.processing;
      case 'success':
        return LivenessScreenType.success;
      case 'fail':
        return LivenessScreenType.fail;
      case 'error':
        return LivenessScreenType.error;
      default:
        return null;
    }
  }
}
