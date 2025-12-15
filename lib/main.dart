import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pmu/data/repositories/penguin_repository.dart';
import 'package:pmu/presentation/home_page/bloc/bloc.dart';
import 'package:pmu/presentation/home_page/bloc/events.dart';
import 'package:pmu/presentation/home_page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penguin Cards',
      debugShowCheckedModeBanner: false,
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
  }
}
