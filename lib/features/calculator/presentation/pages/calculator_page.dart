import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:port_calculator/config/theme/app_colors.dart';
import 'package:port_calculator/features/calculator/presentation/bloc/calculator_cubit.dart';
import 'package:port_calculator/features/calculator/presentation/bloc/calculator_state.dart';
import 'package:port_calculator/features/calculator/presentation/widgets/small_button.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 138.0, bottom: 66.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 40.0),
              child: BlocBuilder<CalculatorCubit, CalculatorState>(
                builder: (context, state) {
                  final theme = Theme.of(context).textTheme;
                  return Column(
                    spacing: 8.0,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        state.expression.isEmpty ? ' ' : state.expression,
                        style: theme.headlineMedium,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.ltr,
                      ),
                      Text(
                        state.error ?? '=${state.display}',
                        style: theme.headlineLarge,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.right,
                      ),
                    ],
                  );
                },
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20.0,
              children: [
                SmallButton(
                  text: "Ac",
                  contentColor: AppColors.textGray,
                  buttonColor: isLightMode ? null : AppColors.lightGray,
                  onPressed: () => context.read<CalculatorCubit>().clearAll(),
                ),
                SmallButton(
                  icon: Icon(
                    Icons.backspace_outlined,
                    size: 24.0,
                  ),
                  contentColor: AppColors.textGray,
                  buttonColor: isLightMode ? null : AppColors.lightGray,
                  onPressed: () => context.read<CalculatorCubit>().backspace(),
                ),
                SmallButton(
                  text: "/",
                  contentColor: AppColors.lightBlue,
                  buttonColor: AppColors.blue,
                  onPressed: () =>
                      context.read<CalculatorCubit>().inputOperator('/'),
                ),
                SmallButton(
                  text: "*",
                  height: 60.0,
                  contentColor: AppColors.lightBlue,
                  buttonColor: AppColors.blue,
                  onPressed: () =>
                      context.read<CalculatorCubit>().inputOperator('*'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20.0,
              children: [
                SmallButton(
                  text: "7",
                  onPressed: () => _digit(context, '7'),
                ),
                SmallButton(
                  text: "8",
                  onPressed: () => _digit(context, '8'),
                ),
                SmallButton(
                  text: "9",
                  onPressed: () => _digit(context, '9'),
                ),
                SmallButton(
                  text: "-",
                  contentColor: AppColors.lightBlue,
                  buttonColor: AppColors.blue,
                  onPressed: () =>
                      context.read<CalculatorCubit>().inputOperator('-'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20.0,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Row(
                      spacing: 20.0,
                      children: [
                        SmallButton(
                          text: "4",
                          onPressed: () => _digit(context, '4'),
                        ),
                        SmallButton(
                          text: "5",
                          onPressed: () => _digit(context, '5'),
                        ),
                        SmallButton(
                          text: "6",
                          onPressed: () => _digit(context, '6'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      spacing: 20.0,
                      children: [
                        SmallButton(
                          text: "1",
                          onPressed: () => _digit(context, '1'),
                        ),
                        SmallButton(
                          text: "2",
                          onPressed: () => _digit(context, '2'),
                        ),
                        SmallButton(
                          text: "3",
                          onPressed: () => _digit(context, '3'),
                        ),
                      ],
                    ),
                  ],
                ),
                SmallButton(
                  text: "+",
                  height: 106.0,
                  contentColor: AppColors.lightBlue,
                  buttonColor: AppColors.blue,
                  onPressed: () =>
                      context.read<CalculatorCubit>().inputOperator('+'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 20.0,
              children: [
                SmallButton(
                  height: 62,
                  width: 144,
                  text: "0",
                  onPressed: () => _digit(context, '0'),
                ),
                SmallButton(
                  text:
                      "·", // UI pode mostrar "·", internamente cubit converte para "."
                  onPressed: () =>
                      context.read<CalculatorCubit>().inputDecimal(),
                ),
                SmallButton(
                  text: "=",
                  height: 96.0,
                  buttonColor: const Color(0xff1991FF),
                  contentColor: const Color(0xffB2DAFF),
                  onPressed: () => context.read<CalculatorCubit>().evaluate(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _digit(BuildContext context, String d) =>
      context.read<CalculatorCubit>().inputDigit(d);
}
