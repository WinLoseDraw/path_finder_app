import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/grid_cell.dart';
import 'package:collection/collection.dart';

enum Status {
  pickingSize,
  pickingStart,
  pickingGoal,
  pickingBlocked,
  inProgress,
  searchComplete,
}

class ControlPanelController extends ChangeNotifier {
  ControlPanelController() {
    createGrid();
  }

  double gridSize = 10;
  late GridCell? startCell;
  late GridCell? goalCell;
  List<GridCell> blockedCells = [];
  Status currentStatus = Status.pickingStart;
  late List<List<GridCell>> grid = [];
  bool goalFound = false;

  void reset() {
    gridSize = 10;
    startCell = null;
    goalCell = null;
    blockedCells.clear();
    currentStatus = Status.pickingStart;
    createGrid();
    goalFound = false;
    notifyListeners();
  }

  void createGrid() {
    grid.clear();
    for (int i = 0; i < gridSize; i++) {
      List<GridCell> row = [];
      for (int j = 0; j < gridSize; j++) {
        row.add(GridCell(xCoOrdinate: j, yCoOrdinate: i));
      }
      grid.add(row);
    }
  }

  void changeGridSize(double size) {
    gridSize = size;
    startCell = null;
    goalCell = null;
    blockedCells.clear();
    currentStatus = Status.pickingStart;
    createGrid();
    notifyListeners();
  }

  void setStartCell(GridCell start) {
    startCell = start;
    currentStatus = Status.pickingGoal;
    notifyListeners();
  }

  void setGoalCell(GridCell end) {
    goalCell = end;
    currentStatus = Status.pickingBlocked;
    notifyListeners();
  }

  void addCellToBlocked(GridCell cell) {
    blockedCells.add(cell);
    notifyListeners();
  }

  double _calculateDistanceFromGoal(GridCell cell) {
    return sqrt((cell.xCoOrdinate - goalCell!.xCoOrdinate) *
            (cell.xCoOrdinate - goalCell!.xCoOrdinate) +
        (cell.yCoOrdinate - goalCell!.yCoOrdinate) *
            (cell.yCoOrdinate - goalCell!.yCoOrdinate));
  }

  void beginSearch() {
    currentStatus = Status.inProgress;
    notifyListeners();
  }

  void performSearch() async {
    PriorityQueue<GridCell> frontier =
        PriorityQueue<GridCell>((a, b) => a.f.compareTo(b.f));
    List<GridCell> visited = [];
    startCell!.f = _calculateDistanceFromGoal(startCell!);
    frontier.add(startCell!);

    while (frontier.isNotEmpty) {
      GridCell? currentCell = frontier.removeFirst();
      currentCell.status = CellStatus.current;
      notifyListeners();

      await Future.delayed(Duration(milliseconds: gridSize > 10 ? 25 : 50));

      if (currentCell.xCoOrdinate == goalCell?.xCoOrdinate &&
          currentCell.yCoOrdinate == goalCell?.yCoOrdinate) {

        while (currentCell != null) {
          currentCell.status = CellStatus.path;
          currentCell = currentCell.parent;
        }

        print("Goal Found");
        goalFound = true;
        currentStatus = Status.searchComplete;
        notifyListeners();
        return;
      }

      currentCell.status = CellStatus.visited;
      visited.add(currentCell);
      notifyListeners();

      await Future.delayed(Duration(milliseconds: gridSize > 10 ? 25 : 50));

      List<GridCell> children = [];

      int x = currentCell.xCoOrdinate;
      int y = currentCell.yCoOrdinate;

      List<List<int>> neighbors = [
        [0, 1],
        [0, -1],
        [1, 0],
        [-1, 0],
      ];

      for (var offset in neighbors) {
        var neighborPos = [x + offset[0], y + offset[1]];

        if (neighborPos[0] >= gridSize ||
            neighborPos[0] < 0 ||
            neighborPos[1] >= gridSize ||
            neighborPos[1] < 0) {
          continue;
        }

        if (grid[neighborPos[1]][neighborPos[0]].status == CellStatus.invalid) {
          continue;
        }

        bool cnt = false;

        for (GridCell visitedChild in visited) {
          if (neighborPos[0] == visitedChild.xCoOrdinate &&
              neighborPos[1] == visitedChild.yCoOrdinate) {
            cnt = true;
            break;
          }
        }
        if (cnt) {
          continue;
        }
        grid[neighborPos[1]][neighborPos[0]].parent = currentCell;
        children.add(grid[neighborPos[1]][neighborPos[0]]);
      }

      for (GridCell child in children) {

        child.g = currentCell.g + 1;
        child.h = _calculateDistanceFromGoal(child);
        child.f = child.g + child.h;

        bool inFrontier = false;

        for (GridCell cell in frontier.toList()) {
          if (child.xCoOrdinate == cell.xCoOrdinate &&
              child.yCoOrdinate == cell.yCoOrdinate) {
            inFrontier = true;
            break;
          }
        }

        if (!inFrontier) {
          frontier.add(grid[child.yCoOrdinate][child.xCoOrdinate]);
        } else {
          for (GridCell cell in frontier.toList()) {
            if (child.xCoOrdinate == cell.xCoOrdinate &&
                child.yCoOrdinate == cell.yCoOrdinate) {
              if (child.g < cell.g) {
                cell.g = child.g;
                cell.parent = child.parent;
              }
            }
          }
        }
      }
    }
    print("Goal not found");
    currentStatus = Status.searchComplete;
    goalFound = false;
    notifyListeners();
  }
}
