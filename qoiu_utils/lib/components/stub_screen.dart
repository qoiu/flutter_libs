import 'package:flutter/cupertino.dart';

@Deprecated("develope only")
class StubScreen extends StatelessWidget {
  final String title;
  const StubScreen(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title));
  }
}
