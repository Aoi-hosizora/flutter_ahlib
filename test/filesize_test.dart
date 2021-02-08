import 'package:flutter_ahlib/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('filesize', () {
    test('filesize', () {
      expect(filesize(0), "0 B");
      expect(filesize(1023), "1023 B");
      expect(filesize(1024), "1 KB");
      expect(filesize(1030), "1.01 KB");
      expect(filesize(1536), "1.50 KB");
      expect(filesize(2048), "2 KB");
      expect(filesize(1024 * 1024), "1 MB");
      expect(filesize((2.51 * 1024 * 1024).toInt()), "2.51 MB");
      expect(filesize((1024 * 1024 * 1024).toInt()), "1 GB");
      expect(filesize((2.51 * 1024 * 1024 * 1024).toInt()), "2.51 GB");
      expect(filesize((1024 * 1024 * 1024 * 1024).toInt()), "1 TB");
      expect(filesize((1.1 * 1024 * 1024 * 1024 * 1024).toInt()), "1.10 TB");
    });

    test('round', () {
      expect(filesize(1023, 4), "1023 B");
      expect(filesize(1024, 4), "1 KB");
      expect(filesize(1030, 4), "1.0059 KB");
      expect(filesize(1536, 4), "1.5000 KB");
      expect(filesize(2048, 4), "2 KB");
    });

    test('space', () {
      expect(filesize(1023, 0, true), "1023 B");
      expect(filesize(1023, 1, true), "1023 B");
      expect(filesize(1023, 0, false), "1023B");
      expect(filesize(1023, 1, false), "1023B");
    });
  });
}
