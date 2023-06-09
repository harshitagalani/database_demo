import 'package:database_demo/View.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    home: Dashboard(),
    debugShowCheckedModeBanner: false,
  ));
}

class Dashboard extends StatefulWidget {
  Map?m;
  Dashboard([this.m]);
  static Database? database;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    create_db();
    if(widget.m!=null)
      {
        t1.text=widget.m!['name'];
        t2.text=widget.m!['contact'];
      }
    else
      {

      }
  }

  create_db() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    Dashboard.database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE contact_book (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, value INTEGER,contact TEXT  )');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (widget.m!=null)?Text("update contact"):Text("Add contact"),
      ),
      body: Column(
        children: [
          TextField(controller: t1,),
          TextField(controller: t2,),
          ElevatedButton(onPressed: () {
            String name = t1.text;
            String contact = t2.text;
            if(widget.m!=null)
              {
                  String sql=
                      "update contact_book set name='$name',contact='$contact' where id=${widget.m!['id']}";
                  Dashboard.database!.rawUpdate(sql);
              }else{
            String qry = "INSERT INTO contact_book(name,contact) VALUES ('$name','$contact')";
            Dashboard.database!.rawInsert(qry).then((value){
     print("ID : $value");
            });
            }
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return view();
            // },));
            setState(() {

            });
            }, child: Text("submit")),
          ElevatedButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return view();
                },));
          }, child: Text("View Contact")),
        ],
      ),
    );
  }
}
