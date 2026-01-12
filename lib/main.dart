import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pmu/components/locale/l10n/app_locale.dart';
import 'package:pmu/data/repositories/penguin_repository.dart';
import 'package:pmu/presentation/home_page/bloc/bloc.dart';
import 'package:pmu/presentation/home_page/bloc/events.dart';
import 'package:pmu/presentation/home_page/home_page.dart';
import 'package:pmu/presentation/locale_bloc/locale_bloc.dart';
import 'package:pmu/presentation/locale_bloc/locale_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleBloc>(
      lazy: false,
      create: (_) => LocaleBloc(Locale(Platform.localeName)),
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Penguin Cards',
            debugShowCheckedModeBanner: false,
            //l10n
            locale: state.currentLocale,
            localizationsDelegates: AppLocale.localizationsDelegates,
            supportedLocales: AppLocale.supportedLocales,

            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: const Color(0xFF0B3D91),
              scaffoldBackgroundColor: const Color(0xFFEAF6FF),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF0B3D91),
                foregroundColor: Colors.white,
                centerTitle: true,
              ),
            ),
            home: BlocProvider(
              create: (_) => HomeBloc(PenguinRepository())..add(const HomeLoadDataEvent()),
              child: const HomePage(title: 'UlybinAA PIbd-32'),
            ),
          );
        },
      ),
    );
  }
}
