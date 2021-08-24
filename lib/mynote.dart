import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/drawer.dart';
import '../common/noon_appbar.dart';



Widget textSection = Container(
  height: 50,
  width: double.maxFinite,
  decoration: BoxDecoration(
      color: Color(0x000000000),
  ),
  child: Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      IconButton(icon: Icon(Icons.arrow_left), onPressed: (){},),
      IconButton(icon: Icon(Icons.arrow_right), onPressed: (){},),
    ],
  ),
);

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = '나의 단어장';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar:  new AppBar2(),
        body: Column(
          children:[
          const MyStatefulWidget(),
            textSection
          ]
        )
      ),
    );
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    required this.headerValue,
    required this.EngValue,
    required this.KorValue,
    this.isExpanded = false,
  });

  String headerValue;
  String EngValue;
  String KorValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: '단어장 $index',
      EngValue : 'Apple',
      KorValue : '사과',
    );
  });
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final List<Item> _data = generateItems(4);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
              title: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.body1,
                  children: [
                    TextSpan(text: item.KorValue),
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Icon(Icons.volume_up),
                      ),
                    ),
                    TextSpan(text: item.EngValue),
                  ],
                ),
              ),
              trailing: const Icon(Icons.delete),
              ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }


}