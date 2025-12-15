import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pmu/data/repositories/api_interface.dart';
import 'package:pmu/presentation/home_page/bloc/events.dart';
import 'package:pmu/presentation/home_page/bloc/state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiInterface repo;

  HomeBloc(this.repo) : super(const HomeState()) {
    on<HomeLoadDataEvent>(_onLoadData);
    on<HomeSearchChangedEvent>(_onSearchChanged);
  }

  Future<void> _onLoadData(HomeLoadDataEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final items = await repo.loadData();
      emit(
        state.copyWith(
          isLoading: false,
          items: items ?? const [],
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onSearchChanged(HomeSearchChangedEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(query: event.query));
  }
}
