import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserShimmer extends StatelessWidget {
  const UserShimmer({Key key, this.length = 20}) : super(key: key);
  final int length;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[200],
        highlightColor: Colors.grey[100],
        child: ListView.separated(
          physics: length == 1
              ? NeverScrollableScrollPhysics()
              : BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: length,
          separatorBuilder: (_, index) => index != length - 1
              ? Divider(
                  height: 0.5,
                  indent: 16,
                  endIndent: 16,
                  color: Colors.white,
                )
              : SizedBox(),
          itemBuilder: (_, index) => Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: Container(
                height: 60,
                width: 60,
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
              title: Container(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 13,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 10,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
