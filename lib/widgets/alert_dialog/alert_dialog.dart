import 'package:flutter/material.dart';

class ShowValidAlert extends StatelessWidget {
  final String validHeader;
  final String validBody;
  const ShowValidAlert(
      {Key? key,
      this.validBody = "This is a successful dialog box",
      this.validHeader = "Success"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.warning_rounded),
          ),
          Text(validHeader),
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(validBody),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class ShowInvalidAlert extends StatelessWidget {
  final String invalidHeader;
  final String invalidBody;
  const ShowInvalidAlert(
      {Key? key,
      this.invalidBody = "This is a failed dialog box",
      this.invalidHeader = "Error"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
            child: Icon(
              Icons.warning_rounded,
              color: Colors.red,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Text(invalidHeader),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[Text(invalidBody)],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class ShowLoadingAlert extends StatelessWidget {
  final String loadingHeader;
  final String loadingBody;
  const ShowLoadingAlert(
      {Key? key,
      this.loadingBody = "This is a loading dialog box",
      this.loadingHeader = "Loading"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
          Text(loadingHeader),
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(loadingBody),
          ],
        ),
      ),
    );
  }
}
