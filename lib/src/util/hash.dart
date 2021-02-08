// Refers to: https://github.com/google/quiver-dart/blob/master/lib/src/core/hash.dart.

/// Generates a hash code for two objects.
int hash2(a, b) => _finish(_combine(_combine(0, a.hashCode), b.hashCode));

/// Generates a hash code for three objects.
int hash3(a, b, c) => _finish(_combine(_combine(_combine(0, a.hashCode), b.hashCode), c.hashCode));

/// Generates a hash code for four objects.
int hash4(a, b, c, d) => _finish(_combine(_combine(_combine(_combine(0, a.hashCode), b.hashCode), c.hashCode), d.hashCode));

/// Generates a hash code for five objects.
int hash5(a, b, c, d, e) => _finish(_combine(_combine(_combine(_combine(_combine(0, a.hashCode), b.hashCode), c.hashCode), d.hashCode), e.hashCode));

/// Generates a hash code for six objects.
int hash6(a, b, c, d, e, f) => _finish(_combine(_combine(_combine(_combine(_combine(_combine(0, a.hashCode), b.hashCode), c.hashCode), d.hashCode), e.hashCode), f.hashCode));

/// Generates a hash code for iterable objects.
int hashObjects(Iterable objects) => _finish(objects.fold(0, (h, i) => _combine(h, i.hashCode)));

// Jenkins hash function
int _combine(int hash, int value) {
  hash = 0x1fffffff & (hash + value);
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}

// Jenkins hash function
int _finish(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}
