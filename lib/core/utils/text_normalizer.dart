class TextNormalizer {
  TextNormalizer._();

  static String normalize(String value) {
    final trimmed = value.trim().toLowerCase();
    final withoutAccents = _removeDiacritics(trimmed);
    final compactSpaces = withoutAccents.replaceAll(RegExp(r'\s+'), ' ');
    final sanitized = compactSpaces.replaceAll(RegExp(r'[^a-z0-9\s]'), ' ');
    return sanitized.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static String _removeDiacritics(String input) {
    final buffer = StringBuffer();

    for (final rune in input.runes) {
      final char = String.fromCharCode(rune);
      switch (char) {
        case 'á':
        case 'à':
        case 'â':
        case 'ã':
        case 'ä':
        case 'å':
          buffer.write('a');
          break;
        case 'ç':
        case 'ć':
        case 'č':
          buffer.write('c');
          break;
        case 'é':
        case 'è':
        case 'ê':
        case 'ë':
          buffer.write('e');
          break;
        case 'í':
        case 'ì':
        case 'î':
        case 'ï':
          buffer.write('i');
          break;
        case 'ñ':
        case 'ń':
          buffer.write('n');
          break;
        case 'ó':
        case 'ò':
        case 'ô':
        case 'õ':
        case 'ö':
        case 'ø':
          buffer.write('o');
          break;
        case 'ú':
        case 'ù':
        case 'û':
        case 'ü':
          buffer.write('u');
          break;
        case 'ý':
        case 'ÿ':
          buffer.write('y');
          break;
        default:
          buffer.write(char);
      }
    }

    return buffer.toString();
  }
}
