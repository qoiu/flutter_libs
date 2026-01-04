extension MapsExtension<K extends dynamic, V extends dynamic> on Map<K, V> {
  V? nullAt(K key,[V? value]) => containsKey(key) ? this[key] : value;
}
