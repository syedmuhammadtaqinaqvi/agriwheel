enum AuthFlowType { buyer, seller, passwordReset }

class OtpRouteArgs {
  const OtpRouteArgs({
    required this.flow,
    required this.phoneDisplay,
    this.showCustomKeypad = true,
  });

  final AuthFlowType flow;
  final String phoneDisplay;
  final bool showCustomKeypad;
}
