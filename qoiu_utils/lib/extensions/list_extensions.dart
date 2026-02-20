
import 'dart:math';

extension ListExtension<T> on List<T>{
  List<R> indexedMap<R>(R Function(int index,T data) mapper)=>indexed.map((e)=>mapper(e.$1,e.$2)).toList();

  T random()=>this[Random().nextInt(length)];
}
