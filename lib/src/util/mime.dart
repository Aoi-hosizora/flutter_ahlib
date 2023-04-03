// Reference:
// - https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
// - https://pub.dev/packages/mime_type

const _extensionMimeMap = <String, String>{
  'aac': 'audio/aac', // AAC audio
  'abw': 'application/x-abiword', // AbiWord document
  'arc': 'application/x-freearc', // Archive document (multiple files embedded)
  'avif': 'image/avif', // AVIF image
  'avi': 'video/x-msvideo', // AVI: Audio Video Interleave
  'azw': 'application/vnd.amazon.ebook', // Amazon Kindle eBook format
  'bin': 'application/octet-stream', // Any kind of binary data
  'bmp': 'image/bmp', // Windows OS/2 Bitmap Graphics
  'bz': 'application/x-bzip', // BZip archive
  'bz2': 'application/x-bzip2', // BZip2 archive
  'cda': 'application/x-cdf', // CD audio
  'csh': 'application/x-csh', // C-Shell script
  'css': 'text/css', // Cascading Style Sheets (CSS)
  'csv': 'text/csv', // Comma-separated values (CSV)
  'doc': 'application/msword', // Microsoft Word
  'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', // Microsoft Word (OpenXML)
  'eot': 'application/vnd.ms-fontobject', // MS Embedded OpenType fonts
  'epub': 'application/epub+zip', // Electronic publication (EPUB)
  'gz': 'application/gzip', // GZip Compressed Archive
  'gif': 'image/gif', // Graphics Interchange Format (GIF)
  'htm': 'text/html', // HyperText Markup Language (HTML)
  'html': 'text/html', // HyperText Markup Language (HTML)
  'ico': 'image/vnd.microsoft.icon', // Icon format
  'ics': 'text/calendar', // iCalendar format
  'jar': 'application/java-archive', // Java Archive (JAR)
  'jpeg': 'image/jpeg', // JPEG images
  'jpg': 'image/jpeg', // JPEG images
  'js': 'text/javascript', // JavaScript
  'json': 'application/json', // JSON format
  'jsonld': 'application/ld+json', // JSON-LD format
  'mid': 'audio/midi', // Musical Instrument Digital Interface (MIDI)
  'midi': 'audio/midi', // Musical Instrument Digital Interface (MIDI)
  'mjs': 'text/javascript', // JavaScript Module
  'mp3': 'audio/mpeg', // MP3 audio
  'mp4': 'video/mp4', // MP4 video
  'mpeg': 'video/mpeg', // MPEG Video
  'mpkg': 'application/vnd.apple.installer+xml', // Apple Installer Package
  'odp': 'application/vnd.oasis.opendocument.presentation', // OpenDocument presentation document
  'ods': 'application/vnd.oasis.opendocument.spreadsheet', // OpenDocument spreadsheet document
  'odt': 'application/vnd.oasis.opendocument.text', // OpenDocument text document
  'oga': 'audio/ogg', // OGG audio
  'ogv': 'video/ogg', // OGG video
  'ogx': 'application/ogg', // OGG
  'opus': 'audio/opus', // Opus audio
  'otf': 'font/otf', // OpenType font
  'png': 'image/png', // Portable Network Graphics
  'pdf': 'application/pdf', // Adobe Portable Document Format (PDF)
  'php': 'application/x-httpd-php', // Hypertext Preprocessor (Personal Home Page)
  'ppt': 'application/vnd.ms-powerpoint', // Microsoft PowerPoint
  'pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation', // Microsoft PowerPoint (OpenXML)
  'rar': 'application/vnd.rar', // RAR archive
  'rtf': 'application/rtf', // Rich Text Format (RTF)
  'sh': 'application/x-sh', // Bourne shell script
  'svg': 'image/svg+xml', // Scalable Vector Graphics (SVG)
  'tar': 'application/x-tar', // Tape Archive (TAR)
  'tif': 'image/tiff', // Tagged Image File Format (TIFF)
  'tiff': 'image/tiff', // Tagged Image File Format (TIFF)
  'ts': 'video/mp2t', // MPEG transport stream
  'ttf': 'font/ttf', // TrueType Font
  'txt': 'text/plain', // Text, (generally ASCII or ISO 8859-n)
  'vsd': 'application/vnd.visio', // Microsoft Visio
  'wav': 'audio/wav', // Waveform Audio Format
  'weba': 'audio/webm', // WEBM audio
  'webm': 'video/webm', // WEBM video
  'webp': 'image/webp', // WEBP image
  'woff': 'font/woff', // Web Open Font Format (WOFF)
  'woff2': 'font/woff2', // Web Open Font Format (WOFF)
  'xhtml': 'application/xhtml+xml', // XHTML
  'xls': 'application/vnd.ms-excel', // Microsoft Excel
  'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', // Microsoft Excel (OpenXML)
  'xml': 'application/xml', // XML
  'xul': 'application/vnd.mozilla.xul+xml', // XUL
  'zip': 'application/zip', // ZIP archive
  '3gp': 'video/3gpp', // 3GPP audio/video container
  '3g2': 'video/3gpp2', // 3GPP2 audio/video container
  '7z': 'application/x-7z-compressed', // 7-zip archive
};

const _preferredExtension = <String, String>{
  'htm': 'html',
  'html': 'html',
  'jpg': 'jpg',
  'jpeg': 'jpg',
  'mid': 'mid',
  'midi': 'mid',
  'js': 'js',
  'mjs': 'js',
  'tif': 'tif',
  'tiff': 'tif',
};

/// Gets MIME type from given extension. Note that this function returns null if given
/// extension has no correspond MIME type.
String? getMimeFromExtension(String extension) {
  return _extensionMimeMap[extension.toLowerCase()];
}

/// Gets extension list from given MIME type. Note that this function returns null if
/// given MIME type has no correspond extension.
List<String>? getExtensionsFromMime(String mime) {
  mime = mime.split(';').first.trim().toLowerCase();
  final extensions = <String>[];
  for (var kv in _extensionMimeMap.entries) {
    if (kv.value == mime) {
      extensions.add(kv.key);
    }
  }
  if (extensions.isEmpty) {
    return null;
  }
  return extensions;
}

/// Gets preferred extension from given MIME type. Here for example, "jpg" is preferred
/// in "jpg" and "jpeg", "html" is preferred in "htm" and "html". Note that this
/// function returns null if given MIME type has no correspond extension.
String? getPreferredExtensionFromMime(String mime) {
  var extensions = getExtensionsFromMime(mime);
  if (extensions == null) {
    return null;
  }
  return _preferredExtension[extensions.first] ?? extensions.first;
}
