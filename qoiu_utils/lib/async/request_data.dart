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
    }catch(e){
      isError = true;
      errorText = e.toString();
      if(onError!=null){
        onError(Exception(e.toString()));
      }
    }finally{
      isLoading=false;
      setState((){});
    }
  }

  bool get haveData=> data != null && !isError && !isLoading;
}