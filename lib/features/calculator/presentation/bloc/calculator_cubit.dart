// calculator_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:math_expressions/math_expressions.dart';

import 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit() : super(const CalculatorState());

  // ----------------- Entradas -----------------

  void inputDigit(String d) {
    assert(RegExp(r'^\d$').hasMatch(d));
    final exp0 = _sanitize(state.expression);

    // Se acabou de mostrar resultado, começar nova expressão
    if (state.lastInput == InputType.result) {
      emit(
        CalculatorState(
          expression: d,
          display: d,
          lastInput: InputType.digit,
        ),
      );
      return;
    }

    final exp = _appendToExpression(exp0, d, isDigit: true);
    final preview = _computePreview(exp) ?? _currentNumber(exp);

    emit(
      state.copyWith(
        expression: exp,
        display: preview.isEmpty ? '0' : preview,
        lastInput: InputType.digit,
        error: null,
      ),
    );
  }

  void inputDecimal() {
    final exp0 = _sanitize(state.expression);

    // Se acabou de mostrar resultado, inicia "0."
    if (state.lastInput == InputType.result || exp0.isEmpty) {
      emit(
        CalculatorState(
          expression: '0.',
          display: '0.',
          lastInput: InputType.decimal,
        ),
      );
      return;
    }

    // Só permite um ponto por número
    if (_currentNumber(exp0).contains('.')) return;

    final exp = _isLastCharOperator(exp0) ? '${exp0}0.' : '$exp0.';
    emit(
      state.copyWith(
        expression: exp,
        display: _currentNumber(exp),
        lastInput: InputType.decimal,
        error: null,
      ),
    );
  }

  void inputOperator(String op) {
    assert(op == '+' || op == '-' || op == '*' || op == '/');
    var exp = _sanitize(state.expression);

    // Não começar com + * /; permite '-' unário
    if (exp.isEmpty && (op == '+' || op == '*' || op == '/')) return;

    // Se veio de um resultado, continua a partir do display
    if (state.lastInput == InputType.result) {
      exp = state.display;
    }

    // Substituir operador duplicado
    if (exp.isNotEmpty && _isLastCharOperator(exp)) {
      exp = exp.substring(0, exp.length - 1) + op;
    } else {
      exp += op;
    }

    emit(
      state.copyWith(
        expression: exp,
        // display mantém o número atual quando houver
        display: _currentNumber(exp).isEmpty
            ? state.display
            : _currentNumber(exp),
        lastInput: InputType.operator,
        error: null,
      ),
    );
  }

  void clearAll() {
    emit(const CalculatorState());
  }

  void backspace() {
    if (state.expression.isEmpty) return;
    final exp = state.expression.substring(0, state.expression.length - 1);
    final current = _currentNumber(exp);
    emit(
      state.copyWith(
        expression: exp,
        display: current.isEmpty ? '0' : current,
        lastInput: exp.isEmpty ? InputType.none : state.lastInput,
        error: null,
      ),
    );
  }

  void evaluate() {
    final exp0 = _sanitize(state.expression);
    if (exp0.isEmpty) return;

    final cleaned = _trimTrailingOperator(exp0);
    if (cleaned.isEmpty) return;

    try {
      final parser = Parser();
      final expr = parser.parse(cleaned);
      final value = expr.evaluate(EvaluationType.REAL, ContextModel());

      // math_expressions pode retornar Infinity/NaN; filtrar
      if (value is num && value.isFinite) {
        final formatted = _formatResult(value);
        emit(
          state.copyWith(
            expression: cleaned,
            display: formatted,
            lastInput: InputType.result,
            error: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            lastInput: InputType.error,
            error: 'Expressão inválida',
          ),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(lastInput: InputType.error, error: 'Expressão inválida'),
      );
    }
  }

  // ----------------- Helpers -----------------

  // Troca o ponto central "·" da UI por "."
  String _sanitize(String s) => s.replaceAll('·', '.');

  bool _isLastCharOperator(String s) => RegExp(r'[+\-*/]$').hasMatch(s);

  String _trimTrailingOperator(String s) {
    if (s.isEmpty) return s;
    return _isLastCharOperator(s) ? s.substring(0, s.length - 1) : s;
  }

  // Retorna o número atual (ultimo token numérico, com suporte a negativo)
  String _currentNumber(String exp) {
    if (exp.isEmpty) return '';
    final match = RegExp(r'([\-]?\d+(\.\d+)?)$').firstMatch(exp);
    return match?.group(0) ?? '';
  }

  // Evita zero à esquerda sem decimal (ex.: "0" + "5" => "5")
  String _appendToExpression(String exp, String token, {bool isDigit = false}) {
    if (!isDigit) return exp + token;
    // Se último foi resultado e usuário digitou número, reinicia
    if (state.lastInput == InputType.result) return token;

    final numAtual = _currentNumber(exp);
    if (numAtual == '0') {
      // substitui último '0' por dígito
      return exp.substring(0, exp.length - 1) + token;
    }
    return exp + token;
  }

  String? _computePreview(String exp) {
    // Só tenta avaliar se não termina com operador
    if (exp.isEmpty || _isLastCharOperator(exp)) return null;
    try {
      final parser = Parser();
      final expr = parser.parse(exp);
      final value = expr.evaluate(EvaluationType.REAL, ContextModel());
      if (value is num && value.isFinite) return _formatResult(value);
      return null;
    } catch (_) {
      return null;
    }
  }

  String _formatResult(num value) {
    // remove .0; limita casas para evitar 0.30000000004
    if (value % 1 == 0) return value.toInt().toString();
    final fixed = (value as double).toStringAsFixed(10);
    return _trimZeros(fixed);
  }

  String _trimZeros(String s) {
    if (!s.contains('.')) return s;
    s = s.replaceFirst(RegExp(r'0+$'), '');
    if (s.endsWith('.')) s = s.substring(0, s.length - 1);
    return s;
  }
}
