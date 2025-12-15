abstract class HomeEvent {
  const HomeEvent();
}

class HomeLoadDataEvent extends HomeEvent {
  const HomeLoadDataEvent();
}

class HomeSearchChangedEvent extends HomeEvent {
  final String query;
  const HomeSearchChangedEvent(this.query);
}
