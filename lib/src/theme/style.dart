import 'package:flutter/material.dart';

/// 样式表
class DxStyle {
  DxStyle._();

  /// 遮罩颜色
  static const Color mask = Color(0x33999999);
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color gray1 = Color(0xfff7f8fa);
  static const Color gray2 = Color(0xfff2f3f5);
  static const Color gray3 = Color(0xffebedf0);
  static const Color gray4 = Color(0xffdcdee0);
  static const Color gray5 = Color(0xffc8c9cc);
  static const Color gray6 = Color(0xff969799);
  static const Color gray7 = Color(0xff646566);
  static const Color gray8 = Color(0xff323233);
  static const Color red = Color(0xffee0a24);
  static const Color blue = Color(0xff1989fa);
  static const Color yellow = Color(0xffffd21e);
  static const Color orange = Color(0xffff976a);
  static const Color orangeDark = Color(0xffed6a0c);
  static const Color orangeLight = Color(0xfffffbe8);
  static const Color green = Color(0xff07c160);
  static const Color transparent = Colors.transparent;

  ///0区
  static const Color $00AE66 = Color(0xFF00AE66);
  static const Color $0984F9 = Color(0xFF0984F9);

  ///1区
  ///2区
  static const Color $222222 = Color(0xFF222222);

  ///3区
  static const Color $333333 = Color(0xFF333333);
  static const Color $3660C8 = Color(0xFF3660C8);
  static const Color $3E7AF5 = Color(0xFF3E7AF5);

  ///4区
  static const Color $404040 = Color(0xFF404040);
  static const Color $4078F4 = Color(0xFF4078F4);
  static const Color $4A92E3 = Color(0xFF4A92E3);
  static const Color $4E89F7 = Color(0xFF4E89F7);

  ///5区
  static const Color $5E5E5E = Color(0xFF5E5E5E);

  ///6区
  static const Color $666666 = Color(0xFF666666);
  static const Color $6791FA = Color(0xFF6791FA);
  static const Color $689EFD = Color(0xFF689EFD);

  ///7区

  ///8区
  static const Color $888888 = Color(0xFF888888);

  ///9区
  static const Color $999999 = Color(0xFF999999);

  ///A区
  static const Color $A9A9A9 = Color(0xFFA9A9A9);
  static const Color $AAAAAA = Color(0xFFAAAAAA);

  ///B区
  static const Color $BBBBBB = Color(0xFFBBBBBB);

  ///C区
  static const Color $C2C2C2 = Color(0xFFC2C2C2);
  static const Color $CCCCCC = Color(0xFFCCCCCC);
  static const Color $C5C5C5 = Color(0xFFC5C5C5);
  static const Color $CA3444 = Color(0xFFCA3444);

  ///D区
  static const Color $D8D8D8 = Color(0xFFD8D8D8);

  ///E区
  static const Color $E02020 = Color(0xFFE02020);
  static const Color $E0E0E0 = Color(0xFFE0E0E0);
  static const Color $E0EDFF = Color(0xFFE0EDFF);
  static const Color $ECF5FF = Color(0xFFECF5FF);
  static const Color $E4E4E4 = Color(0xFFE4E4E4);
  static const Color $E5E5E5 = Color(0xFFE5E5E5);
  static const Color $EAEAEA = Color(0xFFEAEAEA);
  static const Color $EBFFF7 = Color(0xFFEBFFF7);
  static const Color $EEEEEE = Color(0xFFEEEEEE);
  static const Color $EEF3FF = Color(0xFFEEF3FF);
  static const Color $EFEFEF = Color(0xFFEFEFEF);

  ///F区
  static const Color $F0F0F0 = Color(0xFFF0F0F0);
  static const Color $F1F1F1 = Color(0xFFF1F1F1);
  static const Color $F25643 = Color(0xFFF25643);
  static const Color $F2F2F2 = Color(0xFFF2F2F2);
  static const Color $F3F3F3 = Color(0xFFF3F3F3);
  static const Color $F5F5F5 = Color(0xFFF5F5F5);
  static const Color $F5F6F9 = Color(0xFFF5F6F9);
  static const Color $F8F8F8 = Color(0xFFF8F8F8);
  static const Color $FA3F3F = Color(0xFFFA3F3F);
  static const Color $FA5741 = Color(0xFFFA5741);
  static const Color $FAAD14 = Color(0xFFFAAD14);
  static const Color $FDFCEC = Color(0xFFFDFCEC);
  static const Color $FEEDED = Color(0xFFFEEDED);

  // 渐变色
  static const LinearGradient $GRADIENT$4A92E3$4078F4 = LinearGradient(
    colors: [$4A92E3, $4078F4],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 文字样式
  static const $GRAY6$12 = TextStyle(color: gray6, fontSize: 12);
  static const $WHITE$10 = TextStyle(color: white, fontSize: 10);
  static const $WHITE$11 = TextStyle(color: white, fontSize: 11);
  static const $0984F9$11 = TextStyle(color: $0984F9, fontSize: 11);
  static const $333333$14 = TextStyle(color: $333333, fontSize: 14);
  static const $333333$15$W500 = TextStyle(color: $333333, fontSize: 15, fontWeight: FontWeight.w500);
  static const $0984F9$12 = TextStyle(color: $0984F9, fontSize: 12);
  static const $0984F9$12$W600 = TextStyle(color: $0984F9, fontSize: 12, fontWeight: FontWeight.w600);
  static const $3E7AF5$13W500 = TextStyle(color: $3E7AF5, fontSize: 13, fontWeight: FontWeight.w500);
  static const $0984F9$13 = TextStyle(color: $0984F9, fontSize: 13);
  static const $0984F9$13$W500 = TextStyle(color: $0984F9, fontSize: 13, fontWeight: FontWeight.w500);
  static const $3660C8$14 = TextStyle(color: $3660C8, fontSize: 14);
  static const $0984F9$14 = TextStyle(color: $0984F9, fontSize: 14);
  static const $0984F9$14$W500 = TextStyle(color: $0984F9, fontSize: 14, fontWeight: FontWeight.w500);
  static const $00AE66$12 = TextStyle(color: $00AE66, fontSize: 12);
  static const $00AE66$14$W500 = TextStyle(color: $00AE66, fontSize: 14, fontWeight: FontWeight.w500);
  static const $FA3F3F$12 = TextStyle(color: $FA3F3F, fontSize: 12);
  static const $FA3F3F$14$W500 = TextStyle(color: $FA3F3F, fontSize: 14, fontWeight: FontWeight.w500);
  static const $0984F9$15 = TextStyle(color: $0984F9, fontSize: 15);
  static const $5E5E5E$14 = TextStyle(color: $5E5E5E, fontSize: 14);
  static const $222222$12 = TextStyle(color: $222222, fontSize: 12);
  static const $222222$14 = TextStyle(color: $222222, fontSize: 14);
  static const $222222$14$W500 = TextStyle(color: $222222, fontSize: 14, fontWeight: FontWeight.w500);
  static const $22222$15 = TextStyle(color: $222222, fontSize: 15);
  static const $22222$15$W500 = TextStyle(color: $222222, fontSize: 15, fontWeight: FontWeight.w500);
  static const $22222$16$500 = TextStyle(color: $222222, fontSize: 16, fontWeight: FontWeight.w500);
  static const $4A92E3$14 = TextStyle(color: $4A92E3, fontSize: 14);
  static const $404040$12 = TextStyle(color: $404040, fontSize: 12);
  static const $404040$14 = TextStyle(color: $404040, fontSize: 14);
  static const $404040$14$W500 = TextStyle(color: $404040, fontSize: 14, fontWeight: FontWeight.w500);
  static const $404040$14$W600 = TextStyle(color: $404040, fontSize: 14, fontWeight: FontWeight.w600);
  static const $404040$15 = TextStyle(color: $404040, fontSize: 15);
  static const $404040$15$W500 = TextStyle(color: $404040, fontSize: 15, fontWeight: FontWeight.w500);
  static const $404040$16$W500 = TextStyle(color: $404040, fontSize: 16, fontWeight: FontWeight.w500);
  static const $CCCCCC$12 = TextStyle(color: $CCCCCC, fontSize: 12);
  static const $CCCCCC$14 = TextStyle(color: $CCCCCC, fontSize: 14);
  static const $CCCCCC$14$W500 = TextStyle(color: $CCCCCC, fontSize: 14, fontWeight: FontWeight.w500);
  static const $999999$12 = TextStyle(color: $999999, fontSize: 12);
  static const $999999$14 = TextStyle(color: $999999, fontSize: 14);
  static const $999999$14$W500 = TextStyle(color: $999999, fontSize: 14, fontWeight: FontWeight.w500);
  static const $666666$12 = TextStyle(color: $666666, fontSize: 12);
  static const $666666$13 = TextStyle(color: $666666, fontSize: 13);
  static const $666666$13$W500 = TextStyle(color: $666666, fontSize: 13, fontWeight: FontWeight.w500);
  static const $666666$14$W500 = TextStyle(color: $666666, fontSize: 14, fontWeight: FontWeight.w500);
  static const $666666$14 = TextStyle(color: $666666, fontSize: 14);
  static const $A9A9A9$14$W400 = TextStyle(color: $A9A9A9, fontSize: 14, fontWeight: FontWeight.w400);
  static const $F25643$12 = TextStyle(color: $F25643, fontSize: 12);
  static const $FOF0F0$12 = TextStyle(color: $F0F0F0, fontSize: 12);
  static const $E0E0E0$12 = TextStyle(color: $E0E0E0, fontSize: 12);

  // Gradient Colors
  static const gradientRed = LinearGradient(colors: [Color(0xffff6034), Color(0xffee0a24)]);
  static const gradientOrange = LinearGradient(colors: [Color(0xffffd01e), Color(0xffff8917)]);

  // Component Colors
  static const textColor = gray8;
  static const activeColor = gray2;
  static const activeOpacity = 0.7;
  static const disabledOpacity = 0.5;
  static const backgroundColor = gray1;
  static const backgroundColorLight = Color(0xfffafafa);

  // padding
  static const paddingBase = 4.0;
  static const paddingXs = paddingBase * 2;
  static const paddingSm = paddingBase * 3;
  static const paddingMd = paddingBase * 4;
  static const paddingLg = paddingBase * 6;
  static const paddingXl = paddingBase * 8;

  // padding2
  static const paddingBase2 = 5.0;
  static const paddingXs2 = paddingBase2 * 2;
  static const paddingSm2 = paddingBase2 * 3;
  static const paddingMd2 = paddingBase2 * 4;
  static const paddingLg2 = paddingBase2 * 6;
  static const paddingXl2 = paddingBase2 * 8;

  // Font
  static const fontSizeXs = 10.0;
  static const fontSize11 = 11.0;
  static const fontSizeSm = 12.0;
  static const fontSizeMd = 14.0;
  static const fontSizeLg = 16.0;
  static const fontWeightBold = FontWeight.w500;
  static const double lineHeightXs = 14.0;
  static const double lineHeightSm = 18.0;
  static const double lineHeightMd = 20.0;
  static const double lineHeightLg = 22.0;
  static const TextHeightBehavior textHeightBehavior =
      TextHeightBehavior(leadingDistribution: TextLeadingDistribution.even);

  // interval
  static const intervalBase = 2.0;
  static const intervalSm = intervalBase * 2;
  static const intervalMd = intervalBase * 3;
  static const intervalLg = intervalBase * 4;
  static const intervalXl = intervalBase * 6;

  // BoxShadow
  static const boxShadow = BoxShadow(color: Colors.black12, blurRadius: 4.0, spreadRadius: 0, offset: Offset(0, 0));

  // ActionBar
  static const Color actionBarBackgroundColor = white;
  static const double actionBarHeight = 50.0;
  static const double actionBarIconWidth = 48.0;
  static const String actionBarIconHeight = '100%';
  static const Color actionBarIconColor = textColor;
  static const double actionBarIconSize = 18.0;
  static const double actionBarIconFontSize = fontSizeXs;
  static const Color actionBarIconActiveColor = activeColor;
  static const Color actionBarIconTextColor = gray7;
  static const double actionBarButtonHeight = 40.0;
  static const LinearGradient actionBarButtonWarningColor = gradientOrange;
  static const LinearGradient actionBarButtonDangerColor = gradientRed;

  // Animation
  static const animationDuration200 = Duration(milliseconds: 200);
  static const animationDurationBase = Duration(milliseconds: 500);
  static const animationDurationFast = Duration(milliseconds: 300);
  static const animationDurationSlow = Duration(milliseconds: 1000);
  static const Curve animationTimingFunctionEnter = Curves.easeOut;
  static const Curve animationTimingFunctionLeave = Curves.easeIn;

  // Border
  static const borderColor = gray3;
  static const borderWidthBase = 1.0;
  static const borderWidthHair = 0.5;
  static const borderRadiusSm = 2.0;
  static const borderRadiusMd = 4.0;
  static const borderRadiusLg = 8.0;
  static const borderRadiusMax = 999.0;

  // ActionSheet
  static const actionSheetHeaderPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static const actionSheetHeaderFontSize = fontSizeLg;
  static const actionSheetHeaderBorderRadius = 20.0;
  static const actionSheetDescriptionColor = gray7;
  static const actionSheetDescriptionFontSize = fontSizeMd;
  static const actionSheetItemHeight = 50.0;
  static const actionSheetItemBackground = white;
  static const actionSheetItemTextColor = textColor;
  static const actionSheetItemDisabledTextColor = gray5;
  static const actionSheetSubNameColor = gray7;
  static const actionSheetSubNameFontSize = fontSizeSm;
  static const actionSheetCloseIconSize = 18.0;
  static const actionSheetCloseIconColor = gray6;
  static const actionSheetCloseIconPadding = paddingSm;
  static const actionSheetCancelPaddingTop = paddingXs;
  static const actionSheetCancelPaddingColor = backgroundColor;

  // AddressEdit
  static const addressEditPadding = paddingSm;
  static const addressEditButtonsPadding = EdgeInsets.symmetric(vertical: paddingXl, horizontal: paddingBase);
  static const addressEditButtonMarginBottom = paddingSm;
  static const addressEditSwitchHeight = 20.0;
  static const addressEditSwitchColor = blue;

  // AddressList
  static const addressListPadding = EdgeInsets.all(paddingSm);
  static const addressListDisabledTextColor = gray6;
  static const addressListDisabledTextPadding = EdgeInsets.symmetric(vertical: paddingLg);
  static const addressListDisabledTextFontSize = fontSizeMd;
  static const addressListTitleFontSize = fontSizeLg;
  static const addressListItemPadding = EdgeInsets.all(paddingSm);
  static const addressListItemBackground = white;
  static const addressListItemTextColor = textColor;
  static const addressListItemDisabledTextColor = gray5;
  static const addressListItemFontSize = 13.0;
  static const addressListItemRadioIconColor = red;
  static const addressListItemRadioIconFontSize = 20.0;
  static const addressListEditIconSize = 18.0;
  static const addressListEditIconColor = gray6;
  static const addressListAddPadding = EdgeInsets.symmetric(vertical: paddingSm, horizontal: paddingSm);
  static const addressListAddBackground = white;

  // Checkbox
  static const double checkboxSize = 14.0;
  static const Color checkboxBorderColor = gray5;
  static const Color checkboxBackgroundColor = white;
  static const Duration checkboxTransitionDuration = animationDurationFast;
  static const double checkboxLabelMargin = paddingXs;
  static const Color checkboxLabelColor = textColor;
  static const Color checkboxCheckedIconColor = blue;
  static const Color checkboxDisabledIconColor = gray5;
  static const Color checkboxDisabledLabelColor = gray5;
  static const Color checkboxDisabledBackgroundColor = borderColor;

  // GridItem
  static const EdgeInsets gridItemContentPadding = EdgeInsets.symmetric(vertical: paddingMd, horizontal: paddingXs);
  static const Color gridItemContentBackgroundColor = white;
  static const Color gridItemContentActiveColor = activeColor;
  static const double gridItemIconSize = 28.0;
  static const Color gridItemTextColor = gray7;
  static const double gridItemTextFontSize = fontSizeSm;

  // Avatar
  static const avatarWidthBase = 28.0;
  static const avatarWidthSm = 24.0;
  static const avatarWidthLg = 32.0;
  static const avatarBorderRadius = borderRadiusMd;
  static const avatarRoundBorderRadius = borderRadiusMax;
  static const avatarBackgroundColor = gray3;
  static const avatarIconColor = textColor;

  // Badge
  static const badgeDotPadding = 5.0;
  static const badgeValuePadding = EdgeInsets.symmetric(vertical: 2.0, horizontal: paddingBase);
  static const badgeTextColor = white;
  static const badgeBackgroundColor = red;
  static const badgeTextFontSize = 12.0;

  // Button
  static const buttonMiniHeight = 22.0;
  static const buttonMiniFontSize = fontSizeXs;
  static const buttonSmallHeight = 30.0;
  static const buttonSmallFontSize = fontSizeSm;
  static const buttonDefaultHeight = 44.0;
  static const buttonDefaultFontSize = fontSizeMd;
  static const buttonLargeHeight = 50.0;
  static const buttonLargeFontSize = fontSizeLg;
  static const buttonDefaultColor = textColor;
  static const buttonDefaultBackgroundColor = white;
  static const buttonDefaultBorderColor = borderColor;
  static const buttonPrimaryColor = white;
  static const buttonPrimaryBackgroundColor = green;
  static const buttonPrimaryBorderColor = green;
  static const buttonInfoColor = white;
  static const buttonInfoBackgroundColor = blue;
  static const buttonInfoBorderColor = blue;
  static const buttonDangerColor = white;
  static const buttonDangerBackgroundColor = red;
  static const buttonDangerBorderColor = red;
  static const buttonWarningColor = white;
  static const buttonWarningBackgroundColor = orange;
  static const buttonWarningBorderColor = orange;
  static const buttonBorderWidth = borderWidthBase;
  static const buttonHairBorderWidth = borderWidthHair;
  static const buttonBorderRadius = borderRadiusSm;
  static const buttonRoundBorderRadius = borderRadiusMax;
  static const buttonPlainBackgroundColor = white;
  static const buttonDisabledOpacity = disabledOpacity;

  // Calendar
  static const calendarBorderRadius = 20.0;
  static const calendarBackgroundColor = white;
  static const calendarPopHeight = .8;
  static const calendarHeaderBoxShadow =
      BoxShadow(color: Colors.black12, blurRadius: 10.0, spreadRadius: 0, offset: Offset(0, 2));
  static const calendarFontColor = textColor;
  static const calendarHeight = 400.0;
  static const calendarTitleHeight = 44.0;
  static const calendarTitleFontSize = fontSizeLg;
  static const calendarWeekdaysHeight = 30.0;
  static const calendarWeekdaysFontSize = fontSizeMd;
  static const calendarMonthTitleFontSize = fontSizeMd;
  static const calendarMonthMarkColor = gray2;
  static const calendarMonthMarkSize = 200.0;
  static const calendarMonthMarkFontSize = 150.0;
  static const calendarDayHeight = 60.0;
  static const calendarDayFontSize = fontSizeLg;
  static const calendarDayBorderRadius = borderRadiusMd;
  static const calendarRangeEdgeColor = white;
  static const calendarRangeEdgeBackgroundColor = blue;
  static const calendarRangeMiddleBackgroundOpacity = .1;
  static const calendarSelectedDaySize = 54.0;
  static const calendarSelectedDayColor = white;
  static const calendarInfoFontSize = fontSizeXs;
  static const calendarSelectedDayBackgroundColor = blue;
  static const calendarDayDisabledColor = gray5;
  static const calendarConfirmPadding = EdgeInsets.symmetric(vertical: 7.0, horizontal: paddingMd);
  static const calendarConfirmButtonHeight = 36.0;

  // Card
  static const cardPadding = EdgeInsets.symmetric(vertical: paddingSm, horizontal: paddingMd);
  static const cardFontSize = fontSizeSm;
  static const cardTextColor = textColor;
  static const cardBackgroundColor = white;
  static const cardThumbSize = 72.0;
  static const cardThumbBorderRadius = borderRadiusLg;
  static const cardDescColor = gray7;
  static const cardOriginPriceColor = gray6;
  static const cardNumColor = gray6;
  static const cardOriginPriceFontSize = fontSize11;

  // Cell
  static const cellFontSize = fontSizeMd;
  static const cellVerticalPadding = paddingSm;
  static const cellHorizontalPadding = paddingMd;
  static const cellTextColor = textColor;
  static const cellBackgroundColor = white;
  static const cellBorderColor = borderColor;
  static const cellRequiredColor = red;
  static const cellLabelColor = gray6;
  static const cellLabelFontSize = fontSizeSm;
  static const cellValueColor = gray6;
  static const cellIconSize = 18.0;
  static const cellRightIconColor = gray6;
  static const cellLargeVerticalPadding = paddingSm;
  static const cellLargeTitleFontSize = fontSizeLg;
  static const cellLargeLabelFontSize = fontSizeMd;

  // CellGroup
  static const cellGroupBackgroundColor = white;
  static const cellGroupTitleColor = gray6;
  static const cellGroupTitlePadding =
      EdgeInsets.only(left: paddingMd2, top: paddingMd2, right: paddingMd2, bottom: paddingXs2);
  static const cellGroupTitleFontSize = fontSizeMd;

  // Circle
  static const circleSize = 120.0;
  static const circleTextColor = textColor;
  static const circleTextFontSize = 14.0;

  // Collapse
  static const collapseItemTransitionDuration = animationDurationBase;
  static const collapseItemContentPadding = EdgeInsets.fromLTRB(0, paddingMd, paddingMd, paddingMd);
  static const collapseItemContentMargin = EdgeInsets.only(left: paddingMd);
  static const collapseItemContentFontSize = 13.0;
  static const collapseItemContentTextColor = gray6;
  static const collapseItemContentBackgroundColor = white;
  static const collapseItemTitleDisabledColor = gray5;

  // CountDown
  static const countDownTextColor = textColor;
  static const countDownFontSize = fontSizeMd;

  // ContactCard
  static const contactCardBackgroundColor = white;
  static const contactCardPadding = EdgeInsets.all(paddingMd);
  static const contactCardFontSize = fontSizeMd;
  static const contactCardTextColor = textColor;
  static const contactCardAddPadding = EdgeInsets.all(paddingBase);
  static const contactCardAddBackgroundColor = blue;
  static const contactCardAddColor = white;
  static const contactCardAddSize = 24.0;
  static const contactCardLeftIconPadding = EdgeInsets.only(right: paddingSm);
  static const contactCardLeftIconSize = 20.0;
  static const contactCardLeftIconColor = gray8;
  static const contactCardIconColor = gray6;
  static const contactCardIconSize = 16.0;
  static const contactCardBorderItemWidth = 16.0;
  static const contactCardBorderItemHeight = 2.0;
  static const contactCardBorderItemSpace = 4.0;

  // Coupon
  static const couponMargin = EdgeInsets.only(bottom: paddingMd);
  static const couponContentPadding = EdgeInsets.fromLTRB(paddingMd, paddingMd, paddingMd, paddingLg);
  static const couponBackgroundColor = white;
  static const couponBorderRadius = borderRadiusMd;
  static const couponBoxShadow = boxShadow;
  static const couponFontSize = fontSizeSm;
  static const couponColor = gray6;
  static const couponHeadWidth = 80.0;
  static const couponHeadHeight = 24.0;
  static const couponAmountColor = red;
  static const couponIconSize = 20.0;
  static const couponIconSelectedColor = red;
  static const couponNameFontSize = 20.0;
  static const couponNameColor = textColor;
  static const couponDisabledTextColor = gray6;
  static const couponDescriptionPadding = EdgeInsets.symmetric(vertical: paddingXs, horizontal: paddingMd);
  static const couponDescriptionBackgroundColor = backgroundColorLight;
  static const couponDescriptionFontSize = fontSizeSm;
  static const couponDescriptionColor = gray6;

  // CouponList
  static const couponListPadding = EdgeInsets.all(16);
  static const couponListBackgroundColor = backgroundColor;
  static const couponListExchangeButtonWidth = 60.0;
  static const couponListEmptyImageSize = 200.0;
  static const couponListEmptyTipColor = gray6;
  static const couponListEmptyTipFontSize = fontSizeMd;
  static const couponListTabBackground = white;
  static const couponListTabLabelColor = textColor;
  static const couponListTabUnselectedLabelColor = gray6;
  static const couponListTabIndicatorColor = blue;
  static const couponListCloseButtonHeight = 50.0;
  static const couponListCloseButtonBackground = white;
  static const couponListCloseButtonFontSize = 16.0;
  static const couponListCloseButtonColor = textColor;

  // Dialog
  static const dialogWidth = 320.0;
  static const dialogSmallScreenWidth = 280.0;
  static const dialogFontSize = fontSizeLg;
  static const dialogBorderRadius = 16.0;
  static const dialogTextColor = textColor;
  static const dialogBackgroundColor = white;
  static const dialogHeaderFontWeight = fontWeightBold;
  static const dialogHeaderPadding = EdgeInsets.fromLTRB(paddingLg, paddingLg, paddingLg, 0);
  static const dialogMessagePadding = paddingLg;
  static const dialogMessageFontSize = fontSizeMd;
  static const dialogHasTitleMessageTextColor = gray7;
  static const dialogHasTitleMessagePaddingTop = paddingSm;
  static const dialogConfirmButtonTextColor = blue;
  static const dialogCancelButtonTextColor = textColor;
  static const dialogButtonHeight = 50.0;

  // Divider
  static const dividerTextColor = gray6;
  static const dividerFontSize = fontSizeMd;
  static const dividerBorderColor = Color(0xFFF5F5F5);
  static const dividerContentPadding = EdgeInsets.symmetric(horizontal: 10);
  static const dividerContentLeftWidth = 32.0;
  static const dividerContentRightWidth = 32.0;

  // DropdownMenu
  static const dropdownMenuHeight = 50.0;
  static const dropdownMenuBackgroundColor = white;
  static const dropdownMenuTitleFontSize = 15.0;
  static const dropdownMenuTitleTextColor = textColor;
  static const dropdownMenuTitleActiveTextColor = blue;
  static const dropdownMenuTitleDisabledTextColor = gray6;
  static const dropdownMenuTitlePadding = EdgeInsets.symmetric(horizontal: paddingXs);
  static const dropdownMenuOptionActiveColor = white;
  static const dropdownMenuContentMaxHeight = 200.0;

  // Field
  static const fieldLabelWidth = 80.0;
  static const fieldMinHeight = 30.0;
  static const fieldFontSize = fontSizeMd;
  static const fieldPadding = EdgeInsets.symmetric(horizontal: paddingMd, vertical: 10);
  static const fieldInputPadding = EdgeInsets.symmetric(vertical: 5);
  static const fieldInputBackgroundColor = white;
  static const fieldInputTextColor = textColor;
  static const fieldInputCursorWidth = 1.0;
  static const fieldRequiredColor = red;
  static const fieldInputErrorTextColor = red;
  static const fieldInputDisabledTextColor = gray6;
  static const fieldPlaceholderTextColor = gray6;
  static const fieldIconSize = 16.0;
  static const fieldClearIconSize = 16.0;
  static const fieldClearIconColor = gray5;
  static const fieldRightIconColor = gray6;
  static const fieldErrorMessageColor = red;
  static const fieldErrorMessageTextSize = 12.0;
  static const fieldWordLimitColor = gray7;
  static const fieldWordLimitFontSize = fontSizeSm;

  // GoodsAction
  static const goodsActionBackgroundColor = white;
  static const goodsActionIconWidth = 48.0;
  static const goodsActionIconHeight = 50.0;
  static const goodsActionIconColor = textColor;
  static const goodsActionIconSize = 18.0;
  static const goodsActionFontSize = fontSizeXs;
  static const goodsActionIconTextColor = gray7;
  static const goodsActionButtonsPadding = EdgeInsets.symmetric(vertical: paddingXs, horizontal: paddingSm);
  static const goodsActionButtonHeight = 40.0;

  // ImagePreview
  static const imagePreviewIndexTextColor = white;
  static const imagePreviewIndexFontSize = fontSizeMd;
  static const imagePreviewImageHeight = 280.0;
  static const imagePreviewDuration = animationDurationSlow;
  static const imagePreviewCloseColor = gray5;
  static const imagePreviewCloseSize = 20.0;

  // ImageWall
  static const imageWallPadding = EdgeInsets.symmetric(horizontal: paddingSm);
  static const imageWallCloseButtonColor = gray6;
  static const imageWallCloseButtonFontSize = 16.0;
  static const imageWallItemSize = 80.0;
  static const imageWallItemGutter = 10.0;
  static const imageWallItemBorderRadius = 4.0;
  static const imageWallUploadBorderColor = borderColor;
  static const imageWallUploadBackground = white;
  static const imageWallUploadSize = 18.0;
  static const imageWallUploadColor = gray6;

  // List
  static const listIconMarginRight = EdgeInsets.only(right: 5.0);
  static const listTextColor = gray6;
  static const listTextFontSize = fontSizeMd;
  static const listTextHeight = 50.0;

  // Loading
  static const loadingTextColor = gray6;
  static const loadingTextFontSize = fontSizeMd;
  static const loadingSpinnerColor = blue;
  static const loadingSpinnerBackgroundColor = gray5;
  static const loadingSpinnerSize = 30.0;
  static const loadingSpinnerWidth = 2.0;
  static const loadingSpinnerAnimationDuration = Duration(milliseconds: 800);

  // NoticeBar
  static const noticeBarHeight = 40.0;
  static const noticeBarPadding = EdgeInsets.symmetric(vertical: paddingXs, horizontal: paddingMd);
  static const noticeBarFontSize = fontSizeMd;
  static const noticeBarTextColor = orangeDark;
  static const noticeBarBackgroundColor = orangeLight;
  static const noticeBarIconSize = 16.0;

  // NumberKeyBoard
  static const numberKeyboardBackgroundColor = white;
  static const numberKeyboardTitleTextColor = gray7;
  static const numberKeyboardTitlePadding = EdgeInsets.symmetric(vertical: paddingXs, horizontal: paddingMd);
  static const numberKeyboardTitleFontSize = fontSizeMd;
  static const numberKeyboardCloseColor = blue;
  static const numberKeyboardCloseFontSize = fontSizeMd;
  static const numberKeyboardNumSpacing = 0.8;
  static const numberKeyboardKeyBackground = gray3;
  static const numberKeyboardKeyFontSize = 24.0;
  static const numberKeyboardDeleteFontSize = fontSizeLg;

  // Pagination
  static const paginationHeight = 40.0;
  static const paginationButtonPadding = 20.0;
  static const paginationItemPadding = 10.0;
  static const paginationFontSize = fontSizeMd;
  static const paginationItemBackground = white;
  static const paginationItemColor = blue;
  static const paginationActiveItemBackground = blue;
  static const paginationActiveItemColor = white;
  static const paginationDescColor = gray7;
  static const paginationDisabledOpacity = disabledOpacity;

  // Panel
  static const panelBackgroundColor = white;
  static const panelHeaderValueFontSize = fontSizeMd;
  static const panelHeaderValueColor = red;
  static const panelContentPadding = 20.0;
  static const panelFooterPadding = EdgeInsets.symmetric(vertical: paddingXs, horizontal: paddingMd);

  // PasswordInput
  static const passwordInputHeight = 55.0;
  static const passwordInputMargin = EdgeInsets.symmetric(horizontal: paddingMd);
  static const passwordInputFontSize = 24.0;
  static const passwordInputColor = textColor;
  static const passwordInputGutter = 6.0;
  static const passwordInputBorderRadius = 6.0;
  static const passwordInputBackgroundColor = white;
  static const passwordInputInfoColor = gray6;
  static const passwordInputInfoFontSize = fontSizeMd;

  // Picker
  static const pickerBackgroundColor = white;
  static const pickerHeight = 260.0;
  static const pickerToolbarHeight = 44.0;
  static const pickerTitleFontSize = fontSizeLg;
  static const pickerActionPadding = EdgeInsets.symmetric(horizontal: paddingMd);
  static const pickerActionFontSize = fontSizeMd;
  static const pickerActionTextColor = blue;
  static const pickerOptionFontSize = fontSizeLg;
  static const pickerOptionTextColor = black;
  static const pickerLoadingIconColor = blue;
  static const pickerLoadingMaskColor = Colors.white70;

  // Price
  static const priceFontSize = 20.0;
  static const priceTextColor = textColor;
  static const priceTextRedColor = $E02020;
  static const priceIntegerFontWeight = fontWeightBold;

  // Progress
  static const progressHeight = 4.0;
  static const progressDisabledColor = gray5;
  static const progressBackgroundColor = gray3;
  static const progressMargin = EdgeInsets.symmetric(vertical: 10);
  static const progressPivotPadding = EdgeInsets.symmetric(horizontal: 6, vertical: 2);
  static const progressColor = blue;
  static const progressPivotFontSize = fontSizeSm;
  static const progressPivotTextColor = white;

  // Rate
  static const rateHorizontalGutter = 4.0;
  static const rateIconSize = 24.0;
  static const rateDisabledColor = gray5;
  static const rateActiveColor = yellow;
  static const rateInactiveColor = gray4;

  // Search
  static const searchBackgroundColor = white;
  static const searchInputBackgroundColor = gray1;
  static const searchPadding = EdgeInsets.symmetric(vertical: 10, horizontal: paddingSm);
  static const searchInputFontSize = fontSizeMd;
  static const searchInputPlaceholderColor = gray6;
  static const searchInputColor = textColor;
  static const searchLabelPadding = EdgeInsets.symmetric(horizontal: 5);
  static const searchLabelColor = textColor;
  static const searchLabelFontSize = fontSizeLg;
  static const searchLeftIconColor = gray6;
  static const searchActionPadding = EdgeInsets.only(left: paddingXs);
  static const searchActionTextColor = textColor;
  static const searchActionFontSize = fontSizeMd;

  // ShareSheet
  static const shareSheetHeaderBorderRadius = 20.0;
  static const shareSheetBackgroundColor = white;
  static const shareSheetHeaderPadding = EdgeInsets.fromLTRB(16, 12, 16, 4);
  static const shareSheetHeaderFontSize = fontSizeLg;
  static const shareSheetDescriptionColor = gray5;
  static const shareSheetDescriptionFontSize = fontSizeSm;
  static const shareSheetPadding = 16.0;
  static const shareSheetItemSize = 80.0;
  static const shareSheetItemIconSize = 48.0;
  static const shareSheetItemIconColor = gray7;
  static const shareSheetItemFontSize = fontSizeSm;
  static const shareSheetItemFontColor = gray7;
  static const shareSheetItemDescriptionFontColor = gray5;
  static const shareSheetCancelItemHeight = 50.0;
  static const shareSheetCancelItemFontSize = fontSizeMd;
  static const shareSheetCancelItemTextColor = gray6;
  static const shareSheetCancelPaddingTop = paddingXs;
  static const shareSheetCancelPaddingColor = backgroundColor;

  // Skeleton
  static const skeletonRowHeight = 16.0;
  static const skeletonTitleHeight = 20.0;
  static const skeletonRowBackgroundColor = activeColor;
  static const skeletonRowMarginBottom = EdgeInsets.only(bottom: paddingSm);
  static const skeletonAvatarSize = 36.0;
  static const skeletonAvatarBackgroundColor = activeColor;
  static const skeletonAvatarMarginRight = EdgeInsets.only(right: paddingSm);

  // SidebarItem
  static const sidebarFontSize = fontSizeMd;
  static const sidebarTextColor = textColor;
  static const sidebarDisabledTextColor = gray5;
  static const sidebarPadding = EdgeInsets.fromLTRB(paddingXs, 20, 40, 20);
  static const sidebarActiveColor = activeColor;
  static const sidebarBackgroundColor = backgroundColorLight;
  static const sidebarSelectedFontWeight = fontWeightBold;
  static const sidebarSelectedTextColor = textColor;
  static const sidebarSelectedBorderWidth = 3.0;
  static const sidebarSelectedBorderColor = red;
  static const sidebarSelectedBackgroundColor = white;

  // Steps
  static const stepsPadding = EdgeInsets.all(paddingSm);
  static const stepsBorderWidth = borderWidthBase;
  static const stepsBorderColor = borderColor;
  static const stepsBackgroundColor = white;

  // Step
  static const stepTextColor = gray6;
  static const stepProcessTextColor = textColor;
  static const stepFontSize = fontSizeMd;
  static const stepLineColor = borderColor;
  static const stepFinishLineColor = blue;
  static const stepFinishTextColor = textColor;
  static const stepIconSize = 14.0;
  static const stepCircleSize = 8.0;
  static const stepCircleColor = gray6;
  static const stepHorizontalTitleFontSize = fontSizeSm;
  static const stepVerticalProgressWidth = 20.0;

  // Stepper
  static const Color stepperActiveColor = Color(0xffe8e8e8);
  static const double stepperHeight = 28.0;
  static const stepperBackgroundColor = gray2;
  static const double stepperButtonWidth = 28.0;
  static const stepperButtonIconColor = textColor;
  static const stepperButtonIconSize = fontSizeMd;
  static const stepperButtonDisabledColor = backgroundColor;
  static const Color stepperButtonDisabledIconColor = gray5;
  static const stepperDisabledIconColor = gray5;
  static const Color stepperButtonRoundThemeColor = red;
  static const double stepperInputWidth = 32.0;
  static const double stepperInputHeight = 28.0;
  static const stepperInputFontSize = fontSizeMd;
  static const stepperInputTextColor = textColor;
  static const stepperInputDisabledTextColor = gray5;
  static const stepperInputDisabledBackgroundColor = activeColor;
  static const stepperBorderRadius = borderRadiusMd;

  // SubmitBar
  static const submitBarHeight = 50.0;
  static const submitBarBackgroundColor = white;
  static const submitBarButtonWidth = 110.0;
  static const submitBarPriceColor = red;
  static const submitBarPriceFontSize = 20.0;
  static const submitBarTextColor = textColor;
  static const submitBarTextFontSize = fontSizeMd;
  static const submitBarTipPadding = EdgeInsets.symmetric(vertical: paddingXs, horizontal: paddingSm);
  static const submitBarTipFontSize = fontSizeSm;
  static const submitBarTipColor = Color(0xfff56723);
  static const submitBarTipBackgroundColor = Color(0xfffff7cc);
  static const submitBarTipIconSize = 12.0;
  static const submitBarButtonHeight = 40.0;
  static const submitBarButtonColor = gradientRed;
  static const submitBarPadding = EdgeInsets.symmetric(horizontal: paddingMd);

  // Swipe
  static const swipeIndicatorSize = 8.0;
  static const swipeIndicatorInactiveOpacity = 0.3;
  static const swipeIndicatorActiveBackgroundColor = white;
  static const swipeIndicatorInactiveBackgroundColor = borderColor;
  static const swipeDuration = animationDurationSlow;

  // Tag
  static const tagPadding = EdgeInsets.symmetric(horizontal: 5.0);
  static const tagMargin = EdgeInsets.only(right: intervalLg);
  static const tagFontSize = fontSizeSm;
  static const tagMediumFontSize = fontSizeMd;
  static const tagLargeFontSize = fontSizeLg;
  static const tagTextColor = white;
  static const tagBorderRadius = borderRadiusSm;
  static const tagRoundBorderRadius = borderRadiusMax;
  static const tagDangerColor = red;
  static const tagPrimaryColor = blue;
  static const tagSuccessColor = green;
  static const tagWarningColor = orange;
  static const tagDefaultColor = gray6;
  static const tagPlainBackgroundColor = white;

  // Tab
  static const Color tabTextColor = gray7;
  static const Color tabActiveTextColor = textColor;
  static const Color tabDisabledTextColor = gray5;
  static const double tabFontSize = fontSizeMd;
  static const double tabLineHeight = lineHeightMd;

  // Tabs
  static const Color tabsDefaultColor = red;
  static const double tabsLineHeight = 44.0;
  static const double tabsCardHeight = 30.0;
  static const Color tabsNavBackgroundColor = white;
  static const double tabsBottomBarWidth = 40.0;
  static const double tabsBottomBarHeight = 3.0;
  static const Color tabsBottomBarColor = tabsDefaultColor;

  // TreeSelect
  static const treeSelectFontSize = fontSizeMd;
  static const treeSelectNavBackgroundColor = backgroundColorLight;
  static const treeSelectContentBackgroundColor = white;
  static const treeSelectContentPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 15);
  static const treeSelectItemColor = textColor;
  static const treeSelectItemFontWeight = fontWeightBold;
  static const treeSelectItemActiveColor = red;
  static const treeSelectItemDisabledColor = gray5;
}
