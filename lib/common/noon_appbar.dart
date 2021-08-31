import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBar1 extends StatelessWidget with PreferredSizeWidget{
  const AppBar1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Container(
          padding: EdgeInsets.only(top: 5.0),
          child: Image.asset("imgs/appbar.jpg"),
          height: AppBar().preferredSize.height * 1.25,
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
        padding: EdgeInsets.only(top: 5.0),
        child: Image.asset("imgs/appbar.jpg"),
        height: AppBar().preferredSize.height * 1.25,
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
                tooltip: 'Search',
                iconSize: AppBar().preferredSize.height * 0.94,
                onPressed: () => showSearch(context: context, delegate: Search(list)),
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

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          onPressed: () => query = "",
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back)
    );
  }

  String selectedResult = "";

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  final List<String> listExample;
  Search(this.listExample);

  List<String> recentList = ["Text 4", "Text 3"];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList //In the true case
        : suggestionList.addAll(listExample.where(
      // In the false case
          (element) => element.contains(query),
    ));

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(
            suggestionList[index],
          ),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
          onTap: (){
            selectedResult = suggestionList[index];
            showResults(context);
          },
        ),
    );
  }

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