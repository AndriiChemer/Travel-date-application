
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class BottomNavBloc extends BlocBase {
  BottomNavBloc();

  var navController = BehaviorSubject<int>.seeded(0);

  Stream<int> get navStream => navController.stream;
  Sink<int> get navSink => navController.sink;

  setNavIndexPage(int index) {
    navSink.add(index);
  }

  @override
  void dispose() {
    navController.close();
    super.dispose();
  }
}