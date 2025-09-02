import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:port_calculator/features/calculator/presentation/bloc/calculator_cubit.dart';
import 'package:port_calculator/features/calculator/presentation/bloc/calculator_state.dart';

void main() {
  group('CalculatorCubit', () {
    test('estado inicial', () {
      final cubit = CalculatorCubit();
      expect(cubit.state.expression, '');
      expect(cubit.state.display, '0');
      expect(cubit.state.lastInput, InputType.none);
      expect(cubit.state.error, isNull);
      cubit.close();
    });

    blocTest<CalculatorCubit, CalculatorState>(
      'digitar 1 2 3 -> expression "123", display "123"',
      build: () => CalculatorCubit(),
      act: (cubit) {
        cubit.inputDigit('1');
        cubit.inputDigit('2');
        cubit.inputDigit('3');
      },
      verify: (cubit) {
        expect(cubit.state.expression, '123');
        expect(cubit.state.display, '123');
        expect(cubit.state.lastInput, InputType.digit);
      },
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'decimal: "." no início vira "0." e depois 5 -> "0.5"',
      build: () => CalculatorCubit(),
      act: (cubit) {
        cubit.inputDecimal();
        cubit.inputDigit('5');
      },
      verify: (cubit) {
        expect(cubit.state.expression, '0.5');
        expect(cubit.state.display, '0.5');
      },
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'operador após número mantém display do número atual',
      build: () => CalculatorCubit(),
      act: (cubit) {
        cubit.inputDigit('1');
        cubit.inputDigit('2'); // 12
        cubit.inputOperator('+');
      },
      verify: (cubit) {
        expect(cubit.state.expression, '12+');
        expect(cubit.state.display, '12'); // mantém último número visível
        expect(cubit.state.lastInput, InputType.operator);
      },
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'substitui operador duplicado: 1 + * => "1*"',
      build: () => CalculatorCubit(),
      act: (cubit) {
        cubit.inputDigit('1');
        cubit.inputOperator('+');
        cubit.inputOperator('*');
      },
      verify: (cubit) {
        expect(cubit.state.expression, '1*');
        expect(cubit.state.display, '1');
      },
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'divisão por zero gera erro (Infinity tratado como inválido)',
      build: () => CalculatorCubit(),
      act: (cubit) {
        cubit.inputDigit('1');
        cubit.inputOperator('/');
        cubit.inputDigit('0');
        cubit.evaluate();
      },
      verify: (cubit) {
        expect(cubit.state.lastInput, InputType.error);
        expect(cubit.state.error, isNotNull);
      },
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'backspace remove último char e atualiza display',
      build: () => CalculatorCubit(),
      act: (cubit) {
        cubit.inputDigit('1');
        cubit.inputDigit('2'); // "12"
        cubit.backspace(); // "1"
      },
      verify: (cubit) {
        expect(cubit.state.expression, '1');
        expect(cubit.state.display, '1');
      },
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'clearAll reseta estado',
      build: () => CalculatorCubit(),
      act: (cubit) {
        cubit.inputDigit('9');
        cubit.inputOperator('+');
        cubit.inputDigit('1');
        cubit.clearAll();
      },
      verify: (cubit) {
        expect(cubit.state.expression, '');
        expect(cubit.state.display, '0');
        expect(cubit.state.lastInput, InputType.none);
        expect(cubit.state.error, isNull);
      },
    );

    blocTest<CalculatorCubit, CalculatorState>(
      'depois de result, digitar número começa nova expressão',
      build: () => CalculatorCubit(),
      act: (cubit) {
        cubit.inputDigit('1');
        cubit.inputOperator('+');
        cubit.inputDigit('1');
        cubit.evaluate(); // =2
        cubit.inputDigit('9'); // deve iniciar "9"
      },
      verify: (cubit) {
        expect(cubit.state.expression, '9');
        expect(cubit.state.display, '9');
        expect(cubit.state.lastInput, InputType.digit);
      },
    );
  });
}
