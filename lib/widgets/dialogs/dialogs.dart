import 'package:flutter/material.dart';

class ShowRemoveConfirmationDialog extends StatelessWidget {
  final String type;
  const ShowRemoveConfirmationDialog({Key? key, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Remove confirmation'),
      content: Text(
          'Are you sure you want to remove $type from your saved records?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Yes'),
        ),
      ],
    );
  }
}

class ShowOpenTrailerLinkDialog extends StatelessWidget {
  final String movieName;
  final String? trailerName;
  const ShowOpenTrailerLinkDialog(
      {Key? key, required this.trailerName, required this.movieName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(trailerName ?? 'No trailer name'),
      content: Text(
        'Opening trailer in YouTube browser or app for the movie $movieName',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Dismiss'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Let\'s go'),
        ),
      ],
    );
  }
}
