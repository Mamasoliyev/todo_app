import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/core/style/app_color.dart';
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
                // 🔽 Rasm
                Expanded(
                  flex: 4,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _texts.length,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32.r),
                          bottomRight: Radius.circular(32.r),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: _images[index],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: SizedBox(
                              width: 30.w,
                              height: 30.w,
                              child: const CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error, size: 40.sp, color: Colors.red),
                        ),
                      );
                    },
                  ),
                ),

                // 🔽 Text + indikator + button
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 16.h),
                        Text(
                          _texts[_currentIndex],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                        ),
                        SizedBox(height: 20.h),

                        // Page indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_texts.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: EdgeInsets.all(4.w),
                              width: _currentIndex == index ? 14.w : 8.w,
                              height: 8.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
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
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            onPressed: _nextPage,
                            child: Text(
                              _currentIndex == _texts.length - 1
                                  ? "Sign In"
                                  : "Next",
                              style: TextStyle(
                                fontSize: 16.sp,
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

            // 🔽 Language dropdown
            Positioned(
              top: 12.h,
              right: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  // color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  dropdownColor: AppColors.primary,
                  focusColor: AppColors.primary,
                  value: _selectedLang,
                  underline: const SizedBox(),
                  borderRadius: BorderRadius.circular(12.r),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  // dropdownColor: Colors.white,
                  alignment: AlignmentDirectional.topEnd,
                  selectedItemBuilder: (context) {
                    return [
                      const CircleAvatar(
                        backgroundColor: AppColors.productDark,
                        child: Text("🇺🇿"),
                      ),
                      const CircleAvatar(
                        backgroundColor: AppColors.productDark,
                        child: Text("🇬🇧"),
                      ),
                      const CircleAvatar(
                        backgroundColor: AppColors.productDark,
                        child: Text("🇷🇺"),
                      ),
                    ];
                  },
                  items: const [
                    DropdownMenuItem(
                      value: "uz",
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: [
                            Text("🇺🇿 "),
                            SizedBox(width: 6),
                            Text(
                              "Uzbek",
                              style: TextStyle(
                                fontFamily: FontFamily.comfortaa,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "en",
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: [
                            Text("🇬🇧 "),
                            SizedBox(width: 6),
                            Text(
                              "English",
                              style: TextStyle(
                                fontFamily: FontFamily.comfortaa,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: "ru",
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: [
                            Text("🇷🇺 "),
                            SizedBox(width: 6),
                            Text(
                              "Русский",
                              style: TextStyle(
                                fontFamily: FontFamily.comfortaa,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                 onChanged: (value) async {
                    setState(() {
                      _selectedLang = value!;
                    });

                    if (value == "en") {
                      await context.setLocale(const Locale("en", "US"));
                    } else if (value == "ru") {
                      await context.setLocale(const Locale("ru", "RU"));
                    } else if (value == "uz") {
                      await context.setLocale(const Locale("uz", "UZ"));
                    }
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
