import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future _imagePicker(context, ImageSource source) async {
    File imageFile;
    final appFolder = await getApplicationDocumentsDirectory();

    if (source == ImageSource.camera) {
      PickedFile cameraPickedFile = await ImagePicker().getImage(
        source: source,
        maxWidth: 600,
      );
      imageFile = File(cameraPickedFile.path);
    } else if (source == ImageSource.gallery) {
      PickedFile galleryPickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 200,
        maxHeight: 200,
      );
      imageFile = File(galleryPickedFile.path);
    }

    if (imageFile == null) {
      return;
    }

    final String fileName = basename(imageFile.path);
    // Incorrect string it produces:
    //
    //    "Directory: '/path/to/file'"
    //
    // This is because string templates default to calling the `toString()`
    // method and the type of `appFolder` is `Directory` not `String`
    final malformedDestPath = "$appFolder/$fileName";

    // Correct string, it produces
    // "/path/to/file"
    final destPath = join(appFolder.path, fileName);
    final File savedImage = await imageFile.copy(destPath);

    return savedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _imagePicker(null, ImageSource.gallery);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
