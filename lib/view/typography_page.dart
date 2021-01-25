import 'package:archo/util/theme/app_text_styles.dart';
import 'package:archo/util/util.dart';
import 'package:flutter/material.dart';

/// NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyText1)
/// body2        14.0  regular  0.25  (bodyText2)
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5

class TypographyPage extends StatelessWidget {
  static const String routeName = "TypographyPage";

  const TypographyPage();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final styleItemsDefault = [
      _TextStyleItem(
        name: 'Headline 1',
        style: textTheme.headline1,
        text: 'Light 96sp',
      ),
      _TextStyleItem(
        name: 'Headline 2',
        style: textTheme.headline2,
        text: 'Light 60sp',
      ),
      _TextStyleItem(
        name: 'Headline 3',
        style: textTheme.headline3,
        text: 'Regular 48sp',
      ),
      _TextStyleItem(
        name: 'Headline 4',
        style: textTheme.headline4,
        text: 'Regular 34sp',
      ),
      _TextStyleItem(
        name: 'Headline 5',
        style: textTheme.headline5,
        text: 'Regular 24sp',
      ),
      _TextStyleItem(
        name: 'Headline 6',
        style: textTheme.headline6,
        text: 'Medium 20sp',
      ),
      _TextStyleItem(
        name: 'Subtitle 1',
        style: textTheme.subtitle1,
        text: 'Regular 16sp',
      ),
      _TextStyleItem(
        name: 'Subtitle 2',
        style: textTheme.subtitle2,
        text: 'Medium 14sp',
      ),
      _TextStyleItem(
        name: 'Body Text 1',
        style: textTheme.bodyText1,
        text: 'Regular 16sp',
      ),
      _TextStyleItem(
        name: 'Body Text 2',
        style: textTheme.bodyText2,
        text: 'Regular 14sp',
      ),
      _TextStyleItem(
        name: 'Button',
        style: textTheme.button,
        text: 'MEDIUM (ALL CAPS) 14sp',
      ),
      _TextStyleItem(
        name: 'Caption',
        style: textTheme.caption,
        text: 'Regular 12sp',
      ),
      _TextStyleItem(
        name: 'Overline',
        style: textTheme.overline,
        text: 'REGULAR (ALL CAPS) 10sp',
      ),
    ];

    final styleItemsCustom = [
      _TextStyleItem(
        name: 'headingTypeA',
        style: AppTextStyles.headingTypeA,
        text: AppTextStyles.headingTypeA.fontWeight.toString() +
            " " +
            AppTextStyles.headingTypeA.fontSize.toString() +
            "sp",
      ),
      _TextStyleItem(
        name: 'headingStyleB',
        style: AppTextStyles.headingStyleB,
        text: AppTextStyles.headingStyleB.fontWeight.toString() +
            " " +
            AppTextStyles.headingStyleB.fontSize.toString() +
            "sp",
      ),
      _TextStyleItem(
        name: 'activeTab',
        style: AppTextStyles.activeTab,
        text: AppTextStyles.activeTab.fontWeight.toString() +
            " " +
            AppTextStyles.activeTab.fontSize.toString() +
            "sp",
      ),
      _TextStyleItem(
        name: 'inactiveTab',
        style: AppTextStyles.inactiveTab,
        text: AppTextStyles.inactiveTab.fontWeight.toString() +
            " " +
            AppTextStyles.inactiveTab.fontSize.toString() +
            "sp",
      ),
      _TextStyleItem(
        name: 'articleListTitle',
        style: AppTextStyles.articleListTitle,
        text: AppTextStyles.articleListTitle.fontWeight.toString() +
            " " +
            AppTextStyles.articleListTitle.fontSize.toString() +
            "sp",
      ),
      _TextStyleItem(
        name: 'textLink',
        style: AppTextStyles.textLink,
        text: AppTextStyles.textLink.fontWeight.toString() +
            " " +
            AppTextStyles.textLink.fontSize.toString() +
            "sp",
      ),
      _TextStyleItem(
        name: 'bodyCopyTypeA',
        style: AppTextStyles.bodyCopyTypeA,
        text: AppTextStyles.bodyCopyTypeA.fontWeight.toString() +
            " " +
            AppTextStyles.bodyCopyTypeA.fontSize.toString() +
            "sp",
      ),
      _TextStyleItem(
        name: 'factcheckerTitle',
        style: AppTextStyles.factcheckerTitle,
        text: AppTextStyles.factcheckerTitle.fontWeight.toString() +
            " " +
            AppTextStyles.factcheckerTitle.fontSize.toString() +
            "sp",
      ),
      _TextStyleItem(
        name: 'arterialInfo',
        style: AppTextStyles.arterialInfo,
        text: AppTextStyles.arterialInfo.fontWeight.toString() +
            " " +
            AppTextStyles.arterialInfo.fontSize.toString() +
            "sp",
      ),
      _TextStyleItem(
        name: 'disabled',
        style: AppTextStyles.disabled,
        text: AppTextStyles.disabled.fontWeight.toString() +
            " " +
            AppTextStyles.disabled.fontSize.toString() +
            "sp",
      ),
      _TextStyleItem(
        name: 'timestamp',
        style: AppTextStyles.timestamp,
        text: AppTextStyles.timestamp.fontWeight.toString() +
            " " +
            AppTextStyles.timestamp.fontSize.toString() +
            "sp",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Typography"),
      ),
      body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Material(
                elevation: 1,
                color: Util.appTheme.primaryColor.withOpacity(0.5),
                child: TabBar(
                  tabs: [Tab(text: 'Repustar'), Tab(text: 'Default')],
                  indicatorColor: Util.appTheme.accentColor,
                ),
              ),
              Expanded(
                child: TabBarView(children: [
                  Scrollbar(child: ListView(children: styleItemsCustom)),
                  Scrollbar(child: ListView(children: styleItemsDefault))
                ]),
              ),
            ],
          )),
    );
  }
}

class _TextStyleItem extends StatelessWidget {
  const _TextStyleItem({
    Key key,
    @required this.name,
    @required this.style,
    @required this.text,
  })  : assert(name != null),
        assert(style != null),
        assert(text != null),
        super(key: key);

  final String name;
  final TextStyle style;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 72,
            child: Text(name, style: Theme.of(context).textTheme.caption),
          ),
          Expanded(
            child: Text(text, style: style),
          ),
        ],
      ),
    );
  }
}
