import 'package:flutter/material.dart';
import 'card.dart';
import 'constant.dart';

class GridViewer extends StatefulWidget {
  final size;
  final data;

  GridViewer(this.size, this.data);

  @override
  State<GridViewer> createState() => _GridViewerState();
}

class _GridViewerState extends State<GridViewer> {
  @override
  Widget build(BuildContext context) {
    int cards=(widget.data != null) ? widget.data.length : 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: GridView.builder(
          itemCount: cards,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5 * widget.size.width ~/ 1280,
              childAspectRatio: 1.3 * widget.size.width / 1280,
              mainAxisSpacing: 15,
              crossAxisSpacing: 10),
          itemBuilder: (context, index) {
            List<String> keys = [];
            for (var key in widget.data.keys) {
              keys.add(key);
            }
            // List<bool>tapped=List.filled(keys.length,false);
            return AthleteCard(
                widget.size, index, widget.data[keys[index]], keys[index]);
          }),
    );
  }
}
