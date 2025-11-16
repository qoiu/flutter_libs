

import 'dart:math';

import 'package:qoiu_utils/qoiu_utils.dart';

test(){
  String text =
      '{count: 4, next: null, previous: null, results: [{id: 934e9030-2c96-4e80-854b-bcb0ee12ba76, username: terst, name: terst, is_active: true, _company: test descr}, {id: 75e7e659-d435-404d-9c39-fa5ed49e66b6, username: test1, name: test descr2, is_active: true, _company: test descr}, {id: 12fe9020-9ea2-4a85-84cc-372af7f1d8e2, username: test123, name: Тестовый переработчик, is_active: true, _company: ООО «Яндекс лавка»}, {id: 53fa9d76-e4e0-4e1b-80bf-77e3a866a64d, username: testt, name: a, is_active: true, _company: test descr}]}';
  tryColorizeMap(text).printLong();
}
String tryColorizeMap(String text, [int offset=0]) {
  return text.split(':').map((e)=>colorizeLast(e)).join('').replaceAll(',', ',\n');
}

String colorizeLast(String text, [int offset=1]){
  if(text.length<=1)return text;
  'map: $text'.print();
  for (int i=1; i< text.length; i++) {
    var letter = text.substring(text.length-i,min(text.length,text.length-i+1));
    // 'checkLetter: $letter'.print();
    if(!RegExp(r"^[a-zA-Z0-9_]").hasMatch(letter) || RegExp(r"\s").hasMatch(letter)){
      'letter $i - $letter'.print();
      return '${text.substring(0,text.length-i+1)}${text.substring(text.length-i+1,text.length).dpBlue()}:';
      return text;
    }
  }
  return text;
}