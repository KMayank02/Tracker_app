import 'package:bloc/bloc.dart';
import 'botnavbar_states.dart';
import 'botnvabar_events.dart';

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc() : super(const BottomNavigationInitial(tabIndex: 0)) {
    on<BottomNavigationEvent>((event, emit) {
      if (event is TabChange) {
        emit(BottomNavigationInitial(tabIndex: event.tabIndex));
      }
    });
  }
}
