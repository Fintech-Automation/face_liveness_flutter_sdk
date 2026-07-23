class LivenessBrand {
  /// Brand text in the top-left chrome. Defaults to hidden.
  final String? name;

  /// Optional image URL for the brand mark. Preferred for hosted/runtime wrappers.
  final Uri? logoUrl;

  /// Top-right security label; pass `''` to hide.
  final String? secureLabel;

  const LivenessBrand({this.name, this.logoUrl, this.secureLabel});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (logoUrl?.toString().isNotEmpty == true) {
      data['logoUrl'] = logoUrl.toString();
    }
    data['secureLabel'] = secureLabel;
    return data;
  }
}
