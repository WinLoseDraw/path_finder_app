import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_finder_app/controllers/control_panel_controller.dart';
import 'package:path_finder_app/widgets/grid_widget.dart';
import 'package:provider/provider.dart';
import '../widgets/control_panel.dart';
import 'package:flutter/foundation.dart';

class PathFinderPage extends StatefulWidget {
  const PathFinderPage({Key? key}) : super(key: key);

  @override
  State<PathFinderPage> createState() => _PathFinderPageState();
}

class _PathFinderPageState extends State<PathFinderPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 60.0,
          title: Text(
            "Path Finder",
            style: GoogleFonts.quicksand(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.all(15.0),
          child: !kIsWeb ? Column(
            children: [
              SizedBox(
                height: 15.0,
              ),
              Text(
                "This app demonstrates the use of the A* algorithm to search for a path from the start cell to the goal cell.",
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 40.0,
              ),
              Consumer<ControlPanelController>(
                builder: (BuildContext context, controller, Widget? child) {
                  return GridWidget(size: controller.gridSize.toInt());
                },
              ),
              Expanded(
                child: ControlPanel(),
              ),
            ],
          ) : Column(
            children: [
              SizedBox(
                height: 15.0,
              ),
              Text(
                "This app demonstrates the use of the A* algorithm to search for a path from the start cell to the goal cell.",
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 40.0,
              ),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 80.0,),
                    Consumer<ControlPanelController>(
                      builder: (BuildContext context, controller, Widget? child) {
                        return GridWidget(size: controller.gridSize.toInt());
                      },
                    ),
                    SizedBox(width: 80.0,),
                    Expanded(
                      child: ControlPanel(),
                    ),
                    SizedBox(width: 80.0,),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
