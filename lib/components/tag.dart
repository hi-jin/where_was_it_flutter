import 'package:flutter/material.dart';

class TagCard extends StatelessWidget {
  final String tag;
  Function? removeTagFunc;

  TagCard({Key? key, required this.tag, this.removeTagFunc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (removeTagFunc != null) removeTagFunc!();
      },
      child: Container(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("#$tag"),
            const Icon(Icons.close, size: 15.0,),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          border: Border.all(color: Colors.teal.shade100)
        ),
      ),
    );
  }
}
