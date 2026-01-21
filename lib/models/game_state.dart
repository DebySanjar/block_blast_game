import 'dart:math';
import 'block_shape.dart';

class GameState {
  static const int boardSize = 8;
  List<List<int>> board;
  int score;
  int level;
  List<BlockShape> currentBlocks;
  
  GameState({
    List<List<int>>? board,
    this.score = 0,
    this.level = 1,
    List<BlockShape>? currentBlocks,
  }) : board = board ?? List.generate(boardSize, (_) => List.filled(boardSize, -1)),
       currentBlocks = currentBlocks ?? [];
  
  void generateNewBlocks() {
    final random = Random();
    final allShapes = BlockShape.getAllShapes();
    currentBlocks = List.generate(
      3,
      (_) => allShapes[random.nextInt(allShapes.length)],
    );
  }
  
  bool canPlaceBlock(BlockShape block, int row, int col) {
    for (int i = 0; i < block.height; i++) {
      for (int j = 0; j < block.width; j++) {
        if (block.shape[i][j] == 1) {
          final boardRow = row + i;
          final boardCol = col + j;
          
          if (boardRow >= boardSize || boardCol >= boardSize) {
            return false;
          }
          
          if (board[boardRow][boardCol] != -1) {
            return false;
          }
        }
      }
    }
    return true;
  }
  
  void placeBlock(BlockShape block, int row, int col) {
    for (int i = 0; i < block.height; i++) {
      for (int j = 0; j < block.width; j++) {
        if (block.shape[i][j] == 1) {
          board[row + i][col + j] = block.colorIndex;
        }
      }
    }
    checkAndClearLines();
  }
  
  List<int> getRowsThatWillClear(BlockShape block, int row, int col) {
    List<int> rowsToClear = [];
    
    // Blokning qaysi qatorlarga ta'sir qilishini tekshirish
    Set<int> affectedRows = {};
    for (int i = 0; i < block.height; i++) {
      for (int j = 0; j < block.width; j++) {
        if (block.shape[i][j] == 1) {
          affectedRows.add(row + i);
        }
      }
    }
    
    // Har bir ta'sirlangan qatorni tekshirish
    for (int r in affectedRows) {
      if (r >= boardSize) continue;
      
      bool willBeFull = true;
      for (int c = 0; c < boardSize; c++) {
        bool isBlockCell = false;
        for (int i = 0; i < block.height; i++) {
          for (int j = 0; j < block.width; j++) {
            if (block.shape[i][j] == 1 && row + i == r && col + j == c) {
              isBlockCell = true;
              break;
            }
          }
          if (isBlockCell) break;
        }
        
        if (!isBlockCell && board[r][c] == -1) {
          willBeFull = false;
          break;
        }
      }
      
      if (willBeFull) {
        rowsToClear.add(r);
      }
    }
    
    return rowsToClear;
  }
  
  List<int> getColsThatWillClear(BlockShape block, int row, int col) {
    List<int> colsToClear = [];
    
    // Blokning qaysi ustunga ta'sir qilishini tekshirish
    Set<int> affectedCols = {};
    for (int i = 0; i < block.height; i++) {
      for (int j = 0; j < block.width; j++) {
        if (block.shape[i][j] == 1) {
          affectedCols.add(col + j);
        }
      }
    }
    
    // Har bir ta'sirlangan ustunni tekshirish
    for (int c in affectedCols) {
      if (c >= boardSize) continue;
      
      bool willBeFull = true;
      for (int r = 0; r < boardSize; r++) {
        bool isBlockCell = false;
        for (int i = 0; i < block.height; i++) {
          for (int j = 0; j < block.width; j++) {
            if (block.shape[i][j] == 1 && row + i == r && col + j == c) {
              isBlockCell = true;
              break;
            }
          }
          if (isBlockCell) break;
        }
        
        if (!isBlockCell && board[r][c] == -1) {
          willBeFull = false;
          break;
        }
      }
      
      if (willBeFull) {
        colsToClear.add(c);
      }
    }
    
    return colsToClear;
  }
  
  void checkAndClearLines() {
    List<int> rowsToClear = [];
    List<int> colsToClear = [];
    
    // Qatorlarni tekshirish
    for (int i = 0; i < boardSize; i++) {
      if (board[i].every((cell) => cell != -1)) {
        rowsToClear.add(i);
      }
    }
    
    // Ustunlarni tekshirish
    for (int j = 0; j < boardSize; j++) {
      bool columnFull = true;
      for (int i = 0; i < boardSize; i++) {
        if (board[i][j] == -1) {
          columnFull = false;
          break;
        }
      }
      if (columnFull) {
        colsToClear.add(j);
      }
    }
    
    // Qatorlarni tozalash
    for (int row in rowsToClear) {
      for (int j = 0; j < boardSize; j++) {
        board[row][j] = -1;
      }
      score += 10;
    }
    
    // Ustunlarni tozalash
    for (int col in colsToClear) {
      for (int i = 0; i < boardSize; i++) {
        board[i][col] = -1;
      }
      score += 10;
    }
    
    // Daraja yangilash
    if (score > level * 100) {
      level++;
    }
  }
  
  bool hasValidMoves() {
    for (var block in currentBlocks) {
      for (int i = 0; i < boardSize; i++) {
        for (int j = 0; j < boardSize; j++) {
          if (canPlaceBlock(block, i, j)) {
            return true;
          }
        }
      }
    }
    return false;
  }
  
  void reset() {
    board = List.generate(boardSize, (_) => List.filled(boardSize, -1));
    score = 0;
    level = 1;
    generateNewBlocks();
  }
}
