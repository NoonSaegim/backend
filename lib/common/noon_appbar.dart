import 'package:flutter/material.dart';
import '../search/voca_search.dart';
import 'package:sizer/sizer.dart';

class AppBar1 extends StatelessWidget with PreferredSizeWidget{
  const AppBar1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Container(
          padding: EdgeInsets.only(top: 5.0.sp),
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, '/main'),
            child: Image.asset("imgs/appbar.jpg"),
          ),
          height: AppBar().preferredSize.height * 1.285,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
        leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu,),
                iconSize: AppBar().preferredSize.height * 0.58,
                color: Colors.lightBlue,
                tooltip: 'Menu',
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            }
        ),
      );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
final List<String> list = List.generate(10, (index) => "Text $index");

class AppBar2 extends StatelessWidget with PreferredSizeWidget{
  const AppBar2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Container(
        padding: EdgeInsets.only(top: 5.0.sp),
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, '/main'),
          child: Image.asset("imgs/appbar.jpg"),
        ),
        height: AppBar().preferredSize.height * 1.285,
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0.0,
      leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              iconSize: AppBar().preferredSize.height * 0.58,
              color: Colors.lightBlue,
              tooltip: 'Menu',
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          }
      ),
      actions: <Widget>[
        Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.search_rounded),
                color: Colors.lightBlue,
                iconSize: AppBar().preferredSize.height * 0.94,
                onPressed: () async {
                  showSearch(context: context, delegate: await vocaSearch(context));
                }
              );
            }
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class TransparentAppBar extends StatelessWidget with PreferredSizeWidget{
  const TransparentAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,

        child: AppBar(
          leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.menu),
                  color: Colors.lightBlueAccent,
                  iconSize: AppBar().preferredSize.height * 0.58,
                  tooltip: 'Menu',
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              }
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        )
    );
  }
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}