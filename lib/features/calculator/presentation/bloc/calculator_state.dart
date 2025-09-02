import 'package:equatable/equatable.dart';

enum InputType { none, digit, operator, decimal, result, error }

class CalculatorState extends Equatable {
  final String expression;
  final String display;
  final InputType lastInput;
  final String? error;

  const CalculatorState({
    this.expression = '',
    this.display = '0',
    this.lastInput = InputType.none,
    this.error,
  });

  CalculatorState copyWith({
    String? expression,
    String? display,
    InputType? lastInput,
    String? error,
  }) {
    return CalculatorState(
      expression: expression ?? this.expression,
      display: display ?? this.display,
      lastInput: lastInput ?? this.lastInput,
      error: error,
    );
  }

  @override
  List<Object?> get props => [expression, display, lastInput, error];
}
