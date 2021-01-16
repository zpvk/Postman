import 'package:flutter/material.dart';

class ThemeBuilder extends StatefulWidget {
  final Widget Function(BuildContext context,Brightness brightness) builder;

  ThemeBuilder({this.builder});

  @override
  _ThemeBuilderState createState() => _ThemeBuilderState();

  static _ThemeBuilderState of(BuildContext context){
    // ignore: deprecated_member_use
    return context.ancestorStateOfType(const TypeMatcher<_ThemeBuilderState>());
  }
}

class _ThemeBuilderState extends State<ThemeBuilder> {
  Brightness _brightness;
  @override void initState() {
    // TODO: implement initState
    super.initState();
    _brightness = Brightness.light;

  }
  void changeTheme(){
    setState(() {
      _brightness = _brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    });
  }
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _brightness);
  }
}
