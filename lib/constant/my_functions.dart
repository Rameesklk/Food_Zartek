import 'package:flutter/material.dart';

callNext(var className, var context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => className),
  );
}
void finish(context) {
  Navigator.pop(context);
}
callNextReplacement(var className, var context){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => className),
  );

}
void back(var context) {
  Navigator.pop(context);
}