import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '0';

  void _appendValue(String value) {
    setState(() {
      _expression += value;
    });
  }

  void _clear() {
    setState(() {
      _expression = '';
      _result = '0';
    });
  }

  void _calculateResult() {
    try {
      Parser parser = Parser();
      Expression exp =
          parser.parse(_expression.replaceAll('×', '*').replaceAll('÷', '/'));
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        _result = eval.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Close icon
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(
                    CupertinoIcons.clear_circled_solid,
                    color: cs.onSurfaceVariant,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Display
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: textTheme.titleMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _result,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Buttons Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.1,
                  children: [
                    _buildButton(context, '7'),
                    _buildButton(context, '8'),
                    _buildButton(context, '9'),
                    _buildButton(context, '÷', isOperator: true),
                    _buildButton(context, '4'),
                    _buildButton(context, '5'),
                    _buildButton(context, '6'),
                    _buildButton(context, '×', isOperator: true),
                    _buildButton(context, '1'),
                    _buildButton(context, '2'),
                    _buildButton(context, '3'),
                    _buildButton(context, '-', isOperator: true),
                    _buildButton(context, '0'),
                    _buildButton(context, '.', isOperator: true),
                    _buildButton(context, '=', isEqual: true),
                    _buildButton(context, '+', isOperator: true),
                    _buildButton(context, 'C', isClear: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text,
      {bool isOperator = false, bool isEqual = false, bool isClear = false}) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    Color bgColor = theme.scaffoldBackgroundColor; // match screen color
    Color textColor = cs.onBackground;

    if (isEqual) {
      bgColor = cs.primary;
      textColor = cs.onPrimary;
    } else if (isOperator) {
      bgColor = cs.surfaceContainerHigh;
    } else if (isClear) {
      bgColor = cs.error.withOpacity(0.12);
      textColor = cs.error;
    }

    return GestureDetector(
      onTap: () {
        if (text == 'C') {
          _clear();
        } else if (text == '=') {
          _calculateResult();
        } else {
          _appendValue(text);
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
