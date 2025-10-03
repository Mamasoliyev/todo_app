import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/core/style/app_color.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1300), () {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        context.go("/onboarding");
      } else {
        context.go("/todo");
      }
    });
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(width: 12),
            // Use TypewriterText or FadeScaleText
            TypewriterText(
              "Todo App",
              textStyle: const TextStyle(
                fontSize: 55,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              charDuration: const Duration(milliseconds: 100),
              repeat: true, // set false to type once
              pauseAtEnd: const Duration(milliseconds: 800),
            ),

            // FadeScaleText(
            //   "Todo App",
            //   textStyle: const TextStyle(
            //     fontSize: 35,
            //     fontWeight: FontWeight.bold,
            //   ),
            //   duration: const Duration(milliseconds: 800),
            // ),
          ],
        ),
      ),
    );
  }
}

/// ----------------------
/// TypewriterText widget
/// ----------------------
class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration charDuration;
  final bool repeat;
  final Duration pauseAtEnd;

  const TypewriterText(
    this.text, {
    super.key,
    this.textStyle,
    this.charDuration = const Duration(milliseconds: 100),
    this.repeat = false,
    this.pauseAtEnd = const Duration(milliseconds: 600),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<int> _charCount;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _start();
  }

  void _initAnimation() {
    final int totalMs =
        (widget.text.length * widget.charDuration.inMilliseconds).clamp(
          1,
          1000000,
        );
    _controller = AnimationController(
      duration: Duration(milliseconds: totalMs),
      vsync: this,
    );
    _charCount = StepTween(
      begin: 0,
      end: widget.text.length,
    ).animate(_controller);
    _controller.addStatusListener(_statusListener);
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (widget.repeat) {
        Future.delayed(widget.pauseAtEnd, () {
          if (!mounted) return;
          _controller.reset();
          _controller.forward();
        });
      }
    }
  }

  void _start() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_statusListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle =
        widget.textStyle ?? Theme.of(context).textTheme.headlineSmall;

    return AnimatedBuilder(
      animation: _charCount,
      builder: (context, child) {
        final int count = _charCount.value;
        final safeCount = count.clamp(0, widget.text.length);
        final visible = widget.text.substring(0, safeCount);
        return Text(visible, style: defaultStyle);
      },
    );
  }
}

/// ----------------------
/// Fade + Scale Text widget
/// ----------------------
class FadeScaleText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration duration;

  const FadeScaleText(
    this.text, {
    super.key,
    this.textStyle,
    this.duration = const Duration(milliseconds: 700),
  });

  @override
  Widget build(BuildContext context) {
    final style = textStyle ?? Theme.of(context).textTheme.headlineSmall;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, t, child) {
        // t goes 0 -> 1
        final scale = 0.8 + 0.2 * t;
        return Opacity(
          opacity: t,
          child: Transform.scale(
            scale: scale,
            child: Text(text, style: style),
          ),
        );
      },
    );
  }
}
