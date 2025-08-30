import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Represents a single step in [DynamicMultiStepForm].
class FormStep {
  /// Title displayed in the stepper header.
  final Widget title;

  /// Content of the step.
  final Widget content;

  const FormStep({required this.title, required this.content});
}

/// A lightweight replacement for the `dynamic_multi_step_form` package.
///
/// Displays a simple [Stepper] with next/back navigation and calls
/// [onSubmit] when the last step is completed.
class DynamicMultiStepForm extends StatefulWidget {
  const DynamicMultiStepForm({
    super.key,
    required this.steps,
    required this.onSubmit,
    this.isLoading = false,
    this.stepperType = StepperType.horizontal,
  });

  /// Ordered list of form steps.
  final List<FormStep> steps;

  /// Callback invoked when the final step is submitted.
  final VoidCallback onSubmit;

  /// Whether a submit operation is in progress.
  final bool isLoading;

  /// Orientation of the [Stepper]. Defaults to [StepperType.horizontal].
  final StepperType stepperType;

  @override
  State<DynamicMultiStepForm> createState() => _DynamicMultiStepFormState();
}

class _DynamicMultiStepFormState extends State<DynamicMultiStepForm> {
  int _currentStep = 0;

  void _next() {
    if (widget.isLoading) return;
    if (_currentStep < widget.steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      widget.onSubmit();
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: widget.stepperType,
      currentStep: _currentStep,
      onStepTapped: (i) => setState(() => _currentStep = i),
      onStepContinue: _next,
      onStepCancel: _back,
      controlsBuilder: (context, details) {
        final bool isLast = _currentStep == widget.steps.length - 1;
        return Row(
          children: [
            if (_currentStep > 0)
              TextButton(onPressed: _back, child: const Text('Back')),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: widget.isLoading ? null : _next,
              child: widget.isLoading && isLast
                  ? const CupertinoActivityIndicator()
                  : Text(isLast ? 'Submit' : 'Next'),
            ),
          ],
        );
      },
      steps: widget.steps
          .asMap()
          .entries
          .map((entry) => Step(
                title: entry.value.title,
                content: entry.value.content,
                isActive: entry.key <= _currentStep,
              ))
          .toList(),
    );
  }
}

