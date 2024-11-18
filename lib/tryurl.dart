import 'package:flutter/services.dart';

void main() {
  // Regular expression to allow characters commonly found in URLs
  // This allows alphanumeric characters, dots, slashes, colons, hyphens, underscores, and query parameters.
  RegExp urlPattern = RegExp(r'^[a-zA-Z0-9\-._~:/?#[\]@!$&\()*+,;=%]*$');

  // Create a FilteringTextInputFormatter using the regular expression
  FilteringTextInputFormatter urlFormatter = FilteringTextInputFormatter.allow(urlPattern);

  // Example usage in a TextField widget in Flutter:
  /*
  TextField(
    inputFormatters: [urlFormatter],
    decoration: InputDecoration(hintText: 'Enter a URL'),
  );
  */
}
