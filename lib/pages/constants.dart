import 'package:flutter/material.dart';

class AppConstants {
  static const String tDashboard = "Dashboard";
  static const String tQuickAction = "Quick Action :";
  static const String tWaterLimitPerDay = "Water Limit Per Day";
  static const String tNotifications = "Notifications";

  //common
  static double dAppBarFontSize = 24;
  static double dAppBarIconSize = 34;

  static Color cAppbarFontColor = const Color(0xffA6E1FA);
  static Color cAppbarIconColor = Colors.white;
  static Color cAppbarBackgroundColor = const Color(0xffA6E1FA);
  static Color cBottomNvBarbgColor = const Color(0xff0A2472);
  static Color cBottomNvBarSelectedColor = Colors.white;
  static Color cBottomNvBarUnselectedColor = const Color(0xff0E6BA8);
  static Color cBackgroundColor = Colors.white;
  static Color cBackgroundFontColor = Colors.black;

  //profile Screen
  static const String tUserProfile = "User Profile";
  static const String tUserName = "Ustretrter Name";
  static const String tPhoneNumber = "0123456789";
  static const String tEmail = "abfgdgd,dfhscd@email.com";

  static double dUsernameFontSize = 25;

  //Usage Screen
  static double dDailyUsage = 1225;
  static double dWeeklyUsage = 8201;
  static double dMonthlyUsage = 35000;
  static double dUsageContainerFontSize = 20;
  static double dChartHeadingFontSize = 25;
  static double dUsageContainerWidth = 370;
  static double dUsageContainerHeight = 55;
  static double dChartBarWidth = 2;
  static double dUsageChartHeight = 9 * 24;
  static double dUsageChartWidth = 16 * 24;
  static double dContainerBorderRadius = 20;

  static const String tDaily = "Daily";
  static const String tWeekly = "Weekly";
  static const String tMonthly = "Monthly";
  static const String tWaterUsages = "Water Usages";
  static const String tLastDay = "Last Day";
  static const String tLastWeek = "Last Week";
  static const String tLastMonth = "Last Month";
  static const String tLiters = "Liters";
  static const String tHours = "Hours";
  static const String tDays = "Days";

  static Color cUsageContainerColor = const Color(0xff0E6BA8);
  static Color cUsageContainerFontColor = cBackgroundColor;
  static Color cChartBackgroundColor = const Color(0xff020227);
  static Color cChartLineColor = Colors.red;

  static bool bIsCurved = true;
}
