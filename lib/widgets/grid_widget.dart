import 'package:flutter/material.dart';
import 'package:path_finder_app/controllers/control_panel_controller.dart';
import 'package:provider/provider.dart';
import 'grid_cell.dart';

class GridWidget extends StatefulWidget {
  int size;

  GridWidget({Key? key, required this.size}) : super(key: key);

  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  @override
  Widget build(BuildContext context) {
    print("Building Grid");

    return AspectRatio(
      aspectRatio: 1,
      child: Consumer<ControlPanelController>(
          builder: (context, controller, child) {
        return Container(
          padding: EdgeInsets.all(2.0),
          width: double.infinity,
          child: Column(
            children: [
              for (List<GridCell> row in controller.grid)
                Row(
                  children: row,
                ),
            ],
          ),
        );
      }),
    );
  }
}
