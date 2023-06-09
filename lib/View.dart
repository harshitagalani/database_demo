import 'package:database_demo/main.dart';
import 'package:flutter/material.dart';

class view extends StatefulWidget {
  const view({Key? key}) : super(key: key);

  @override
  State<view> createState() => _viewState();
}

class _viewState extends State<view> {
  List<Map> l = [];
  bool t = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data();
  }
  get_data()async {
    String sql = "select * from contact_book";
    l =  await Dashboard.database!.rawQuery(sql);
    print(l);
    t = true;
    setState(() {

    });

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View"),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Dashboard();
            },));
          }, icon: Icon(Icons.add))
        ],
      ),
      body: (t==true)?ListView.builder(itemCount: l.length,
        itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text("${l[index]['name']}"),
            subtitle: Text("${l[index]['contact']}"),
            trailing: Wrap(children: [
              IconButton(onPressed: () {
                String sql="delete from contact_book where id=${l[index]['id']}";
                Dashboard.database!.rawQuery(sql);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return view();
                },));
              }, icon: Icon(Icons.delete)
              ),
              IconButton(onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Dashboard(l[index]);
                  },));
              }, icon: Icon(Icons.edit)
              ),
            ],),
          ),
        );
      },)
          :CircularProgressIndicator()
     );
  }
}
