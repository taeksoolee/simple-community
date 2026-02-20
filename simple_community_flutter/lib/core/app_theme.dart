import 'package:flutter/cupertino.dart';

/// 앱 전역 네비게이션 바 스타일 상수
abstract class AppTheme {
  AppTheme._();

  /// 네비게이션 바 아이콘 크기 (iOS HIG 권장 22pt)
  static const double navBarIconSize = 22;

  /// 네비게이션 바 아이콘 버튼 터치 영역 (iOS HIG 최소 44pt)
  static const double navBarButtonSize = 44;

  /// 네비게이션 바 타이틀 스타일
  static const TextStyle navBarTitleStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 17,
  );

  /// 네비게이션 바 아이콘 버튼 (크기·터치영역 통일)
  static Widget navBarIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
    Color? color,
  }) =>
      CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size(navBarButtonSize, navBarButtonSize),
        onPressed: onPressed,
        child: SizedBox(
          width: navBarButtonSize,
          height: navBarButtonSize,
          child: Center(
            child: Icon(
              icon,
              size: navBarIconSize,
              color: color,
            ),
          ),
        ),
      );

  /// 네비게이션 바 아이콘 위젯 (크기 통일, 버튼 내부용)
  static Widget navBarIcon(IconData icon, {Color? color}) => Icon(
        icon,
        size: navBarIconSize,
        color: color,
      );
}
