import 'package:flutter/material.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<SampleItem> items = [];
  String filter = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,// Đặt màu nền của AppBar thành đen
        centerTitle: true,
        title: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            'Quản lý danh sách mục',
            style: TextStyle(color: Colors.white), // Đặt màu chữ thành trắng
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(95.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  filter = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Tìm kiếm',

                border: OutlineInputBorder(

                  borderRadius: BorderRadius.circular(15), // Làm cong viền
                  borderSide: BorderSide(color: Colors.white),// Đặt màu viền thành trắng
                ),
                labelStyle: TextStyle(color: Colors.white), // Đặt màu chữ của nhãn thành trắng
              ),
              style: TextStyle(color: Colors.white), // Đặt màu chữ khi nhập thành trắn

            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/pic1.jpg', // Đường dẫn đến tệp ảnh nền
            fit: BoxFit.cover, // Đảm bảo ảnh bao phủ toàn bộ phần trên cùng của Stack
            width: double.infinity,
            height: double.infinity,
          ),
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              if (items[index].name.contains(filter)) {
                return Padding(
                  padding: EdgeInsets.only(top: 8), // Lùi đoạn code này xuống 20px
                  child: Card( // Thêm Card để tạo hiệu ứng bo viền và đổ bóng
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Làm cong viền
                    ),
                    color: Colors.black45, // Thêm màu cho danh sách
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        title: Text(
                          '${items[index].id}: ${items[index].name}',
                          style: TextStyle(color: Colors.white), // Đặt màu chữ thành trắng
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white, // Đặt màu của biểu tượng thành trắng
                          ),
                          onPressed: () {
                            setState(() {
                              items.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Đã xóa thành công!')),
                            );
                          },
                        ),
                        onTap: () async {
                          final updatedItem = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UpdateItemScreen(item: items[index])),
                          );
                          if (updatedItem != null) {
                            setState(() {
                              items[index] = updatedItem;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black, // Đặt màu nền của FloatingActionButton thành đen
        foregroundColor: Colors.white, // Đặt màu của biểu tượng và viền thành trắng
        child: Icon(Icons.add),
        onPressed: () async {
          final item = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemScreen(id: items.length + 1)),
          );
          if (item != null) {
            setState(() {
              items.add(item);
            });
          }
        },
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 3.0)),

      ),
    );
  }
}

class AddItemScreen extends StatefulWidget {
  final int id;

  AddItemScreen({required this.id});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Thêm mục mới', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Tên mục',
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder( // Tạo viền màu trắng khi TextField không được nhấn vào
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.white, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder( // Tạo viền màu trắng khi TextField được nhấn vào
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.white, width: 1.5),
            ),
          ),
        ),
      ),



      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black, // Đặt màu nền của FloatingActionButton thành đen
        foregroundColor: Colors.white, // Đặt màu của biểu tượng và viền thành trắng
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pop(context, SampleItem(widget.id, controller.text));

        },
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 3.0)),
      ),
    );
  }
}


class UpdateItemScreen extends StatefulWidget {
  final SampleItem item;

  UpdateItemScreen({required this.item});

  @override
  _UpdateItemScreenState createState() => _UpdateItemScreenState();
}

class _UpdateItemScreenState extends State<UpdateItemScreen> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.item.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Cập nhật mục', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Tên mục',
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder( // Tạo viền màu trắng khi TextField không được nhấn vào
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.white, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder( // Tạo viền màu trắng khi TextField được nhấn vào
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.white, width: 1.5),
            ),
          ),
        ),
      ),


      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black, // Đặt màu nền của FloatingActionButton thành đen
        foregroundColor: Colors.white, // Đặt màu của biểu tượng và viền thành trắng
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pop(context, SampleItem(widget.item.id, controller.text));
        },
        shape: CircleBorder(side: BorderSide(color: Colors.white, width: 3.0)),
      ),
    );
  }
}


class SampleItem {
  final int id;
  final String name;

  SampleItem(this.id, this.name);
}
