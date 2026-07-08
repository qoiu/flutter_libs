import 'dart:math';

extension QoiuListExtension<T> on List<T> {
  List<R> indexedMap<R>(R Function(int index, T data) mapper) =>
      indexed.map((e) => mapper(e.$1, e.$2)).toList();

  T random() => this[Random().nextInt(length)];
  Future<List<R>> indexedMapFuture<R>(
      Future<R> Function(int index, T data) mapper) async {
    List<R> result = [];
    for (var e in indexed) {
      var data = await mapper(e.$1, e.$2);
      result.add(data);
    }
    return result;
  }


  ///add or remove item
  switchItem(T item){
    if(contains(item)){
      remove(item);
    }else{
      add(item);
    }
  }

}
