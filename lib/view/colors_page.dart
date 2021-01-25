import 'package:archo/util/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ColorsPage extends StatelessWidget {
  static const String routeName = "ColorsPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("App Colors"),
        ),
        body: Scrollbar(
          child: ListView(
            children: [
              for (ColorModel model in AppColors.appColors)
                ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: model.color),
                    height: 60,
                    width: 60,
                  ),
                  title: Text(model.name),
                )
            ],
          ),
        ));
  }
}
