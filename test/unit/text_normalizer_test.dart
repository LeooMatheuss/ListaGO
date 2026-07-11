import 'package:flutter_test/flutter_test.dart';
import 'package:listago/core/utils/text_normalizer.dart';

void main() {
  group('TextNormalizer', () {
    test('remove accents, punctuation and duplicate spaces', () {
      const input = '  São Paulo, 123!  ';

      expect(TextNormalizer.normalize(input), 'sao paulo 123');
    });

    test('normalizes uppercase and mixed case text', () {
      expect(TextNormalizer.normalize('MaÇã'), 'maca');
    });

    test('collapses repeated whitespace', () {
      expect(TextNormalizer.normalize('arroz   branco'), 'arroz branco');
    });
  });
}
