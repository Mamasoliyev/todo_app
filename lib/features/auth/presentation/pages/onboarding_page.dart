import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/gen/fonts.gen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;
  String _selectedLang = "uz";

  final List<String> _texts = [
    'Organize your day with simple and clear task management.',
    'Stay focused — track your progress and complete your goals.',
    'Boost your productivity and never miss an important task again!',
  ];

  final List<String> _images = [
    'https://images.pexels.com/photos/669621/pexels-photo-669621.jpeg',
    'https://images.pexels.com/photos/313690/pexels-photo-313690.jpeg',
    'https://images.pexels.com/photos/669619/pexels-photo-669619.jpeg',
  ];

  void _nextPage() {
    if (_currentIndex < _texts.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Image with border radius
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _texts.length,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                        child: Image.network(
                          _images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    },
                  ),
                ),

                // Texts
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        Text(
                          _texts[_currentIndex],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),

                        // Page indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_texts.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.all(4),
                              width: _currentIndex == index ? 14 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: _currentIndex == index
                                    ? Colors.blue
                                    : Colors.grey.shade400,
                              ),
                            );
                          }),
                        ),
                        const Spacer(),

                        // Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: _nextPage,
                            child: Text(
                              _currentIndex == _texts.length - 1
                                  ? "Sign In"
                                  : "Next",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Language dropdown top-right
            Positioned(
              top: 12,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  value: _selectedLang,
                  underline: const SizedBox(),
                  borderRadius: BorderRadius.circular(12),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  selectedItemBuilder: (context) {
                    return [
                      const CircleAvatar(child: Text("🇺🇿")),
                      const CircleAvatar(child: Text("🇬🇧")),
                      const CircleAvatar(child: Text("🇷🇺")),
                    ];
                  },
                  items: const [
                    DropdownMenuItem(
                      value: "uz",
                      child: Row(
                        children: [
                          Text("🇺🇿 "),
                          SizedBox(width: 6),
                          Text(
                            "Uzbek",
                            style: TextStyle(fontFamily: FontFamily.comfortaa),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "en",
                      child: Row(
                        children: [
                          Text("🇬🇧 "),
                          SizedBox(width: 6),
                          Text(
                            "English",
                            style: TextStyle(fontFamily: FontFamily.comfortaa),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "ru",
                      child: Row(
                        children: [
                          Text("🇷🇺 "),
                          SizedBox(width: 6),
                          Text(
                            "Русский",
                            style: TextStyle(fontFamily: FontFamily.comfortaa),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedLang = value!;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
