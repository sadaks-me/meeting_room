import 'package:archo/model/user.dart';
import 'package:archo/provider/home_provider.dart';
import 'package:archo/view/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lazy_loading_list/lazy_loading_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  static const String routeName = "HomePage";

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlutterLogo(
            style: FlutterLogoStyle.markOnly,
            colors: Colors.orange,
          ),
        ),
        title: Text(
          "Archo",
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Get.toNamed(SettingsPage.routeName),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (_, home, __) {
          if (home.users != null && !home.isLoading && home.users.length > 0)
            return ListView.builder(
                itemBuilder: (context, index) {
                  User user = home.users[index];
                  return LazyLoadingList(
                    key: ValueKey(user),
                    index: index,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {},
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.avatar),
                          ),
                          title: Text(
                            user.firstName + " " + user.lastName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(user.email),
                        ),
                        Divider(
                          height: 0.5,
                          indent: 65,
                          endIndent: 16,
                        )
                      ],
                    ),
                    loadMore: () {},
                    hasMore: true,
                  );
                },
                itemCount: home.users.length);

          return Container(
            alignment: Alignment.center,
            child: Text('Go to the Settings and trigger User Api'),
          );
        },
      ),
    );
  }
}
