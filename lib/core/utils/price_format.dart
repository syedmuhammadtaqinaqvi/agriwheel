/// Format price as Rs 25,00,000 per design system.
String formatPakistanPrice(num value) {
  final n = value.round();
  final s = n.toString();
  if (s.length <= 3) return 'Rs $s';
  final last3 = s.substring(s.length - 3);
  var rest = s.substring(0, s.length - 3);
  final buf = StringBuffer();
  while (rest.length > 2) {
    buf.write('${rest.substring(rest.length - 2)},');
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) buf.write('$rest,');
  return 'Rs $buf$last3';
}
