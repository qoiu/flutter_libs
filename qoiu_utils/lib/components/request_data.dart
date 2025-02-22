import 'dart:ui';

import 'package:flutter/foundation.dart';

class RequestData<T>{
  bool isLoading = false;
  bool isError = false;
  String errorText = '';
  T? data;

  Future request(Future<T> Function() networkAction,Function(VoidCallback fn) setState, {Function(Exception)? onError})async{
    try{
      isLoading=true;
      isError = false;
      errorText = '';
      setState((){});
      data = await networkAction();
    }on Exception catch(e){
      isError = true;
      errorText = e.toString();
      if(onError!=null){
        onError(e);
      }
    }finally{
      isLoading=false;
      setState((){});
    }
  }
}