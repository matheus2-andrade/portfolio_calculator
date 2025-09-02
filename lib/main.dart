import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:port_calculator/config/theme/app_theme.dart';
import 'package:port_calculator/features/calculator/presentation/bloc/calculator_cubit.dart';
import 'package:port_calculator/features/calculator/presentation/pages/calculator_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CalculatorCubit()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: CalculatorPage(),
      ),
    );
  }
}
