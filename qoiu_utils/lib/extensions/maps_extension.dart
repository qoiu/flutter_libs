extension MapsExtension<K extends dynamic, V extends dynamic> on Map<K, V> {
  V? nullAt(K key) => containsKey(key) ? this[key] : null;
}
