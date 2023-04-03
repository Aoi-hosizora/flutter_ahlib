import 'package:flutter_ahlib/flutter_ahlib_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mime', () {
    test('getMimeFromExtension', () {
      expect(getMimeFromExtension(''), null);
      expect(getMimeFromExtension(' ;'), null);
      expect(getMimeFromExtension('jpg'), 'image/jpeg');
      expect(getMimeFromExtension('jpeg'), 'image/jpeg');
      expect(getMimeFromExtension('htm'), 'text/html');
      expect(getMimeFromExtension('html'), 'text/html');
      expect(getMimeFromExtension('pdf'), 'application/pdf');
    });

    test('getExtensionsFromMime', () {
      expect(getExtensionsFromMime(''), null);
      expect(getExtensionsFromMime(' ;'), null);
      var ext = getExtensionsFromMime('image/jpeg');
      expect(ext?.length, 2);
      expect(ext!.contains('jpg'), true);
      expect(ext.contains('jpeg'), true);
      ext = getExtensionsFromMime('text/html');
      expect(ext?.length, 2);
      expect(ext!.contains('htm'), true);
      expect(ext.contains('html'), true);
      expect(getExtensionsFromMime('application/pdf'), ['pdf']);
      expect(getExtensionsFromMime('text/plain; charset=UTF-8'), ['txt']);
    });

    test('getPreferredExtensionFromMime', () {
      expect(getPreferredExtensionFromMime(''), null);
      expect(getPreferredExtensionFromMime(' ;'), null);
      expect(getPreferredExtensionFromMime('image/jpeg'), 'jpg');
      expect(getPreferredExtensionFromMime('text/html'), 'html');
      expect(getPreferredExtensionFromMime('text/javascript'), 'js');
      expect(getPreferredExtensionFromMime('audio/midi'), 'mid');
      expect(getPreferredExtensionFromMime('image/tiff'), 'tif');
      expect(getPreferredExtensionFromMime('application/pdf'), 'pdf');
      expect(getPreferredExtensionFromMime('text/plain; charset=UTF-8'), 'txt');
    });
  });
}
