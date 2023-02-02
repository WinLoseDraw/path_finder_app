import 'package:flutter/material.dart';
import 'package:path_finder_app/controllers/control_panel_controller.dart';
import 'package:provider/provider.dart';

enum CellStatus { inactive, start, goal, invalid, visited, current, path }

class GridCell extends StatefulWidget {
  final int xCoOrdinate;
  final int yCoOrdinate;
  double f = 0;
  int g = 0;
  double h = 0;
  GridCell? parent;
  CellStatus status = CellStatus.inactive;

  GridCell({Key? key, required this.xCoOrdinate, required this.yCoOrdinate})
      : super(key: key);

  @override
  State<GridCell> createState() => _GridCellState();
}

class _GridCellState extends State<GridCell> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ControlPanelController>(
        builder: (context, controller, child) {
      print("Building Cell ${widget.xCoOrdinate} ${widget.yCoOrdinate}");

      return Expanded(
        child: AspectRatio(
          aspectRatio: 1,
          child: GestureDetector(
            onTap: () {
              if (controller.currentStatus == Status.pickingStart) {
                widget.status = CellStatus.start;
                controller.setStartCell(widget);
              } else if (controller.currentStatus == Status.pickingGoal &&
                  widget != controller.startCell) {
                widget.status = CellStatus.goal;
                controller.setGoalCell(widget);
              } else if (controller.currentStatus == Status.pickingBlocked &&
                  widget != controller.startCell &&
                  widget != controller.goalCell) {
                if (!controller.blockedCells.contains(widget)) {
                  widget.status = CellStatus.invalid;
                  controller.addCellToBlocked(widget);
                }
              }
            },
            child: Container(
              margin: EdgeInsets.all(0.5),
              decoration: BoxDecoration(
                color: (widget.status == CellStatus.start ||
                        widget.status == CellStatus.visited)
                    ? Colors.cyan
                    : widget.status == CellStatus.goal
                        ? Colors.green
                        : widget.status == CellStatus.invalid
                            ? Colors.red
                            : widget.status == CellStatus.current
                                ? Colors.cyanAccent
                                : widget.status == CellStatus.path
                                    ? Colors.yellow
                                    : Colors.white,
              ),
              child: Center(child: SizedBox()),
            ),
          ),
        ),
      );
    });
  }
}
