import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_finder_app/controllers/control_panel_controller.dart';
import 'package:provider/provider.dart';

class ControlPanel extends StatefulWidget {
  const ControlPanel({Key? key}) : super(key: key);

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ControlPanelController>(builder: (context, controller, child) {
      return Container(
        padding: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
        child: controller.currentStatus != Status.inProgress && controller.currentStatus != Status.searchComplete ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Grid Size",
              style: GoogleFonts.quicksand(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10.0,
            ),
            Slider(
                min: 5,
                max: 15,
                divisions: 10,
                label: controller.gridSize.round().toString(),
                value: controller.gridSize,
                onChanged: (double newValue) {
                  controller.changeGridSize(newValue);
                }),
            SizedBox(
              height: 15.0,
            ),
            Text(
              controller.currentStatus == Status.pickingStart
                  ? "Click any cell to select it as the start."
                  : controller.currentStatus == Status.pickingGoal
                      ? "Click any cell to select it as the goal."
                      : "Click any cell to add it as an invalid cell.",
              style: GoogleFonts.quicksand(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 25.0,
            ),
            Visibility(
              visible:
                  controller.currentStatus == Status.pickingBlocked,
              child: GestureDetector(
                onTap: () async {
                  controller.beginSearch();
                  await Future.delayed(Duration(milliseconds: 500));
                  controller.performSearch();
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    "Begin",
                    style: GoogleFonts.quicksand(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ],
        ) :
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              controller.currentStatus == Status.inProgress ? "Searching for the goal..." : "Search completed!",
              style: GoogleFonts.quicksand(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5.0,
            ),
            Visibility(
              visible: controller.currentStatus == Status.searchComplete,
              child: Text(
                controller.goalFound
                    ? "Goal found!"
                    : "Goal not found.",
                style: GoogleFonts.quicksand(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            GestureDetector(
              onTap: () {
                controller.reset();
              },
              child: Container(
                padding:
                EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  "Reset",
                  style: GoogleFonts.quicksand(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        )
      );
    });
  }
}
