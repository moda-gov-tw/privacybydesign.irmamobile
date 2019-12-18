import 'package:flutter/material.dart';

class BlurText extends StatelessWidget {
  final String text;
  final TextStyle theme;
  final Color color;
  final bool isTextBlurred;

  const BlurText({this.text, this.theme, this.color, this.isTextBlurred});

  @override
  Widget build(BuildContext context) {
    return isTextBlurred
        ? Opacity(
            opacity: 0.8,
            child: Flexible(
              child: Text(
                text,
                style: theme.copyWith(color: const Color(0x00ffffff)).copyWith(shadows: [
                  Shadow(
                    blurRadius: 7.0,
                    color: color,
                  ),
                  Shadow(
                    blurRadius: 15.0,
                    color: color,
                  ),
                  Shadow(
                    blurRadius: 20.0,
                    color: color,
                  ),
                ]),
              ),
            ),
          )
        : Flexible(child: Text(text, style: theme));
  }
}