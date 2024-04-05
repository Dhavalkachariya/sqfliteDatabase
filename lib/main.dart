import 'package:flutter/material.dart';


import 'database_helper.dart';

// import 'invoice_form.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const Invoice(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'SQLITE',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // All journals
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;

  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _GstController = TextEditingController();
  final TextEditingController _ProductTypeController = TextEditingController();
  final TextEditingController _TotalPriceController = TextEditingController();
  final TextEditingController _DiscountController = TextEditingController();

  // final TextEditingController _descriptionController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showInvoice(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
      _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
      _DiscountController.text = existingJournal['discount'];
      _TotalPriceController.text = existingJournal['totalprice'];
      _ProductTypeController.text = existingJournal['producttype'];
      _GstController.text = existingJournal['gst'];
    }
  }


  void _showForm(int? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingJournal =
      _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
      // _descriptionController.text = existingJournal['description'];
      _DiscountController.text = existingJournal['discount'];
      _TotalPriceController.text = existingJournal['totalprice'];
      _ProductTypeController.text = existingJournal['producttype'];
      _GstController.text = existingJournal['gst'];
    }




      showModalBottomSheet(
          context: context,
          elevation: 5,
          isScrollControlled: true,
          builder: (_) =>
              Container(
                padding: EdgeInsets.only(
                  top: 15,
                  left: 15,
                  right: 15,
                  // this will prevent the soft keyboard from covering the text fields
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom + 120,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(hintText: 'Title'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          hintText: 'Description'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _GstController,
                      decoration: const InputDecoration(hintText: 'Gst'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _ProductTypeController,
                      decoration: const InputDecoration(
                          hintText: 'Product Type'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _TotalPriceController,
                      decoration: const InputDecoration(
                          hintText: 'Total Price'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _DiscountController,
                      decoration: const InputDecoration(hintText: 'Discount'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Save new journal
                        if (id == null) {
                          await _addItem();
                        }

                        if (id != null) {
                          await _updateItem(id);
                        }

                        // Clear the text fields
                        _titleController.text = '';
                        _descriptionController.text = '';

                        // Close the bottom sheet
                        Navigator.of(context).pop();
                      },
                      child: Text(id == null ? 'Create New' : 'Update'),
                    )
                  ],
                ),
              ));
    }

// Insert a new journal to the database
    Future<void> _addItem() async {
      await SQLHelper.createItem(
          _titleController.text, _descriptionController.text,
          _GstController.text, _ProductTypeController.text,
          _TotalPriceController.text, _DiscountController.text);
      _refreshJournals();
    }

    // Update an existing journal
    Future<void> _updateItem(int id) async {
      await SQLHelper.updateItem(
          id,
          _titleController.text,
          _descriptionController.text,
          _GstController.text,
          _ProductTypeController.text,
          _TotalPriceController.text,
          _DiscountController.text);
      _refreshJournals();
    }

    // Delete an item
    void _deleteItem(int id) async {
      await SQLHelper.deleteItem(id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Successfully deleted a journal!'),
      ));
      _refreshJournals();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('SQL'),
        ),
        body: _isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : ListView.builder(
          itemCount: _journals.length,
          itemBuilder: (context, index) =>
              Card(
                color: Colors.orange[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                    onTap: () {
                      _showInvoice(_journals[index]['id']);
                      invoice();

                    },
                    title: Text(_journals[index]['title']),
                    subtitle: Text(_journals[index]['description']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showForm(_journals[index]['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteItem(_journals[index]['id']),
                          ),
                        ],
                      ),
                    )),
              ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () { _showForm(null);
          }
        ),
      );
    }


    Future<void> invoice() async {
      return showDialog(context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
                    Text("${_titleController.text}"),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Description',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
                    Text("${_descriptionController.text}"),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Gst',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
                    Text("${_GstController.text}"),
                    SizedBox(
                      height: 10,
                    ),
                    Text('ProductType',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
                    Text("${_ProductTypeController.text}"),
                    SizedBox(
                      height: 10,
                    ),
                    Text('TotalPrice',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
                    Text("${_TotalPriceController.text}"),
                  ],
                ),
              ),
            );
          });
    }
  }
