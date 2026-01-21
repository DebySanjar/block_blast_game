import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../models/game_state.dart';
import '../models/block_shape.dart';

class GameBoard extends StatelessWidget {
  final GameState gameState;
  final Function(int, int, BlockShape, int)? onBlockDropped;
  final BlockShape? hoveredBlock;
  final Offset? hoverPosition;
  
  const GameBoard({
    super.key,
    required this.gameState,
    this.onBlockDropped,
    this.hoveredBlock,
    this.hoverPosition,
  });
  
  int? _getHoveredRow(double localY, double cellSize, double padding) {
    if (hoverPosition == null) return null;
    final adjustedY = localY - padding;
    final totalCellHeight = cellSize + 3.0;
    final row = (adjustedY / totalCellHeight).floor();
    return row >= 0 && row < GameState.boardSize ? row : null;
  }
  
  int? _getHoveredCol(double localX, double cellSize, double padding) {
    if (hoverPosition == null) return null;
    final adjustedX = localX - padding;
    final totalCellWidth = cellSize + 3.0;
    final col = (adjustedX / totalCellWidth).floor();
    return col >= 0 && col < GameState.boardSize ? col : null;
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final totalPadding = isTablet ? 100.0 : 70.0;
    final cellSize = (screenWidth - totalPadding) / GameState.boardSize;
    final containerPadding = 6.0;
    
    return DragTarget<Map<String, dynamic>>(
      onWillAccept: (data) => data != null,
      onAccept: (data) {
        final block = data['block'] as BlockShape;
        final index = data['index'] as int;
        
        if (hoverPosition != null) {
          final RenderBox box = context.findRenderObject() as RenderBox;
          final localPosition = box.globalToLocal(hoverPosition!);
          
          final row = _getHoveredRow(localPosition.dy, cellSize, containerPadding);
          final col = _getHoveredCol(localPosition.dx, cellSize, containerPadding);
          
          if (row != null && col != null && onBlockDropped != null) {
            onBlockDropped!(row, col, block, index);
          }
        }
      },
      builder: (context, candidateData, rejectedData) {
        int? hoveredRow;
        int? hoveredCol;
        bool canPlace = false;
        List<int> rowsThatWillClear = [];
        List<int> colsThatWillClear = [];
        
        if (hoveredBlock != null && hoverPosition != null) {
          final RenderBox? box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final localPosition = box.globalToLocal(hoverPosition!);
            hoveredRow = _getHoveredRow(localPosition.dy, cellSize, containerPadding);
            hoveredCol = _getHoveredCol(localPosition.dx, cellSize, containerPadding);
            
            if (hoveredRow != null && hoveredCol != null) {
              canPlace = gameState.canPlaceBlock(hoveredBlock!, hoveredRow, hoveredCol);
              
              if (canPlace) {
                rowsThatWillClear = gameState.getRowsThatWillClear(hoveredBlock!, hoveredRow, hoveredCol);
                colsThatWillClear = gameState.getColsThatWillClear(hoveredBlock!, hoveredRow, hoveredCol);
              }
            }
          }
        }
        
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: GameColors.boardBackground,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(GameState.boardSize, (row) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(GameState.boardSize, (col) {
                  final cellValue = gameState.board[row][col];
                  final isEmpty = cellValue == -1;
                  
                  bool shouldHighlight = false;
                  bool willClear = false;
                  
                  if (hoveredBlock != null && hoveredRow != null && hoveredCol != null && canPlace) {
                    final blockRow = row - hoveredRow;
                    final blockCol = col - hoveredCol;
                    
                    if (blockRow >= 0 && blockRow < hoveredBlock!.height &&
                        blockCol >= 0 && blockCol < hoveredBlock!.width) {
                      if (hoveredBlock!.shape[blockRow][blockCol] == 1) {
                        shouldHighlight = true;
                      }
                    }
                    
                    // To'liq qator yoki ustunni tekshirish
                    if (rowsThatWillClear.contains(row) || colsThatWillClear.contains(col)) {
                      willClear = true;
                    }
                  }
                  
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: cellSize,
                    height: cellSize,
                    margin: const EdgeInsets.all(1.5),
                    decoration: BoxDecoration(
                      gradient: isEmpty
                          ? null
                          : (willClear
                              ? GameColors.clearLineGradient
                              : GameColors.blockGradients[cellValue % GameColors.blockGradients.length]),
                      color: isEmpty ? GameColors.emptyCell : null,
                      borderRadius: BorderRadius.circular(6),
                      border: shouldHighlight
                          ? Border.all(color: Colors.white, width: 2)
                          : (willClear
                              ? Border.all(color: GameColors.clearLineColor, width: 2)
                              : null),
                      boxShadow: isEmpty
                          ? null
                          : [
                              BoxShadow(
                                color: willClear
                                    ? GameColors.clearLineColor.withOpacity(0.6)
                                    : Colors.black.withOpacity(0.2),
                                blurRadius: willClear ? 10 : 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                    ),
                    child: isEmpty
                        ? Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: GameColors.emptyCell.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          )
                        : null,
                  );
                }),
              );
            }),
          ),
        );
      },
    );
  }
}
