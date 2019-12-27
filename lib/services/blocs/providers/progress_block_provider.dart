import 'package:flutter/widgets.dart';

import '../image_bloc.dart';

class ImageBlocProvider extends InheritedWidget{

  final bloc = ImageBloc();

  ImageBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static ImageBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ImageBlocProvider>().bloc;
  }
}