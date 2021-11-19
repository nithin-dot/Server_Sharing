import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:quiver/iterables.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter File Upload',
      home: StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  void switchScreen(str, context) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => UploadPage(url: str)));
  @override
  Widget build(context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
        appBar: AppBar(title: Text('Flutter File Upload Example')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                  "Insert the URL that will receive the Multipart POST request (including the starting http://)",
                  style: Theme.of(context).textTheme.headline4),
              TextField(
                controller: controller,
                onSubmitted: (str) =>
                    switchScreen("http://10.10.110.5:3000/upload", context),
              ),
              FlatButton(
                child: Text("Take me to the upload screen"),
                onPressed: () => switchScreen(controller.text, context),
              )
            ],
          ),
        ));
  }
}

class UploadPage extends StatefulWidget {
  UploadPage({Key key, this.url}) : super(key: key);

  final String url;

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  Future<String> uploadImage(filename, url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // sleep(const Duration(seconds: 5));
    request.files.add(await http.MultipartFile.fromPath('picture', filename));

    var res = await request.send();
    return res.reasonPhrase;
  }

  String state = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter File Upload Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text(state)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var file = await FilePicker.getMultiFilePath();
          var files = file.values.toList();
          // print(files[0]);
          for (var i in range(file.length))
            var res = await uploadImage(files[i], widget.url);
          // for (var i in range(file.length)) {
          //   print(i);
          // }
          // setState(() {

          //   state = res;
          //   print(res);
          // });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
