import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PinInputField extends StatefulWidget {
  final Function(String) onCompleted;
  final Function(String)? onChanged;
  final int pinLength;
  final bool obscureText;
  final Color? fillColor;
  final Color? activeBorderColor;
  final Color? inactiveBorderColor;
  final Color? textColor;
  final double? boxSize;
  final double? borderRadius;
  final double? borderWidth;

  const PinInputField({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.pinLength = 4,
    this.obscureText = false,
    this.fillColor,
    this.activeBorderColor,
    this.inactiveBorderColor,
    this.textColor,
    this.boxSize,
    this.borderRadius,
    this.borderWidth,
  });

  @override
  State<PinInputField> createState() => _PinInputFieldState();
}

class _PinInputFieldState extends State<PinInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  final List<String> _pinValues = [];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.pinLength,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.pinLength, (index) => FocusNode());
    _pinValues.addAll(List.generate(widget.pinLength, (index) => ''));

    // Add listeners to handle automatic focus
    for (int i = 0; i < widget.pinLength; i++) {
      _controllers[i].addListener(() => _onTextChanged(i));
    }
  }


  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onTextChanged(int index) {
    final text = _controllers[index].text;

    if (text.isNotEmpty) {
      _pinValues[index] = text;

      // Move to next field if not the last one
      if (index < widget.pinLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field, unfocus and call onCompleted
        _focusNodes[index].unfocus();
        final pin = _pinValues.join();
        widget.onCompleted(pin);
      }
    } else {
      _pinValues[index] = '';
    }

    // Call onChanged callback
    if (widget.onChanged != null) {
      widget.onChanged!(_pinValues.join());
    }
  }

  void _onBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      _pinValues[index - 1] = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBoxSize = widget.boxSize ?? 60.w;
    final borderRadius = widget.borderRadius ?? 12.r;
    final borderWidth = widget.borderWidth ?? 2.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 8.w;
        double boxSize = defaultBoxSize;

        final parentWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width - 32.w;
        final available = parentWidth - (widget.pinLength - 1) * spacing;
        final maxPossible = available / widget.pinLength;
        boxSize = min(defaultBoxSize, maxPossible);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.pinLength * 2 - 1, (i) {
            if (i.isOdd) return SizedBox(width: spacing);
            final index = i ~/ 2;
            return SizedBox(
              width: boxSize,
              height: boxSize,
              child: TextFormField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textAlign: TextAlign.center,
                obscureText: widget.obscureText,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: widget.textColor ?? theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 24.sp,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: widget.fillColor ?? theme.colorScheme.surface,
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: widget.inactiveBorderColor ??
                          theme.colorScheme.outline.withOpacity(0.3),
                      width: borderWidth,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: widget.activeBorderColor ??
                          theme.colorScheme.primary,
                      width: borderWidth,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: theme.colorScheme.error,
                      width: borderWidth,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: theme.colorScheme.error,
                      width: borderWidth,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    _onBackspace(index);
                  }
                },
              ),
            );
          }),
        );
      },
    );
  }

}
  