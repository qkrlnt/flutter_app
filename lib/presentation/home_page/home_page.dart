import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pmu/components/extensions/context_x.dart';
import 'package:pmu/presentation/home_page/bloc/bloc.dart';
import 'package:pmu/presentation/home_page/bloc/events.dart';
import 'package:pmu/presentation/home_page/bloc/state.dart';
import 'package:pmu/presentation/home_page/widgets/penguin_card.dart';

import '../common/svg_objects.dart';
import '../locale_bloc/locale_bloc.dart';
import '../locale_bloc/locale_events.dart';
import '../locale_bloc/locale_state.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    SvgObjects.init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(const HomeLoadDataEvent());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    context.read<HomeBloc>().add(const HomeLoadDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [const Icon(Icons.ac_unit), const SizedBox(width: 10), Text(widget.title)],
        ),
        actions: [
          IconButton(tooltip: context.locale.refresh, onPressed: _reload, icon: const Icon(Icons.refresh)),
          GestureDetector(
            onTap: () =>
                context.read<LocaleBloc>().add(const ChangeLocaleEvent()),
            child: SizedBox.square(
              dimension: 50,
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: BlocBuilder<LocaleBloc, LocaleState>(
                  builder: (context, state) {
                    return state.currentLocale.languageCode == 'ru'
                        ? const SvgRu()
                        : const SvgUk();
                  },
                ),
              ),
            ),
          ),
        ],

      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${context.locale.notFound}\n${state.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: _reload, child: Text(context.locale.retry)),
                  ],
                ),
              ),
            );
          }

          final items = state.filteredItems;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) =>
                            context.read<HomeBloc>().add(HomeSearchChangedEvent(v)),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: context.locale.searchHint,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          state.query.trim().isEmpty ? context.locale.emptyList : context.locale.notFound,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: items.length,
                        itemBuilder: (context, i) => PenguinCard(data: items[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
