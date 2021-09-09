import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class SideBar extends StatelessWidget {

  const SideBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Drawer(
            child: Container(
              color: Colors.white,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    height: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top) * 0.15,
                    child: DrawerHeader(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Menu",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      decoration: BoxDecoration( color: Colors.lightBlue, ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.sp, top: 25.sp),
                    child: ListTile(
                        leading: IconButton(
                          icon: Icon(Icons.home),
                          iconSize: 20.sp,
                          color: Colors.lightBlue,
                          tooltip: 'Home',
                          onPressed: () => Navigator.pushNamed(context, '/main'),
                        ),
                        title: GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/main'),
                            child: Text(
                              'Home',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 15.0.sp,
                              ),
                            )
                        )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.sp, top: 25.sp),
                    child:  ListTile(
                        leading: IconButton(
                          icon: Icon(Icons.settings_applications_sharp),
                          iconSize: 20.sp,
                          color: Colors.lightBlue,
                          tooltip: 'Settings',
                          onPressed: () => Navigator.pushNamed(context, '/settings'),
                        ),
                        title: GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/settings'),
                            child: Text(
                              'Settings',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 15.0.sp,
                              ),
                            )
                        )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.sp, top: 25.sp),
                    child: ListTile(
                        leading: IconButton(
                          icon: Icon(Icons.power_settings_new_outlined),
                          iconSize: 20.sp,
                          color: Colors.lightBlue,
                          tooltip: 'Exit',
                          onPressed: () => print('Exit'),
                        ),
                        title: GestureDetector(
                            onTap: () => print('Exit'),
                            child: Text(
                              'Exit',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 15.0.sp,
                              ),
                            )
                        )
                    ),
                  )
                ],
              ),
            )
        )
    );
  }
}
