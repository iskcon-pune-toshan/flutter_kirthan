import 'package:flutter_kirthan/services/firebasemessage_service.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/notification_view_model.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/tabItem.dart';
import 'package:scoped_model/scoped_model.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({
    this.onSelectTab,
    this.tabs,
  });
  final ValueChanged<int> onSelectTab;
  final List<TabItem> tabs;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: tabs
          .map(
            (e) => _buildItem(
          index: e.getIndex(),
          icon: e.icon,
          tabName: e.tabName,
        ),
      )
          .toList(),
      onTap: (index) => onSelectTab(
        index,
      ),
    );
  }

  BottomNavigationBarItem _buildItem(
      {int index, IconData icon, String tabName}) {
    return BottomNavigationBarItem(
      icon: tabName=="Notifications"?ScopedModel<NotificationViewModel>(
        model: NotificationViewModel(),
        child: ScopedModelDescendant<NotificationViewModel>(
            builder: (context, child, model) {
              FirebaseMessageService fms  = new FirebaseMessageService();
              fms.initMessageHandler(context);
              print(model.newNotificationCount);
              bool visibilty = true;
              if(model.newNotificationCount == 0 ) visibilty = false;
              return Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Icon(Icons.notifications),
                  if(visibilty) Positioned(
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minHeight: 12,
                        minWidth: 12,
                      ),
                      child: Text(
                        model.newNotificationCount.toString(),
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ) ,
                ],
              );
            }),
      )
          :Icon(
        icon,
        color: _tabColor(index: index),
        //size: 20,
      ),
      title: Text(
        tabName,
        style: TextStyle(
          color: _tabColor(index: index),
          fontSize: 12,
        ),
      ),
    );
  }

  Color _tabColor({int index}) {
    return AppState.currentTab == index
        ? KirthanStyles.colorPallete10
        : Colors.grey;
  }
}
