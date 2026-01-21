import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../models/block_shape.dart';

class BlockPiece extends StatelessWidget {
  final BlockShape block;
  final bool isSelected;
  final VoidCallback? onTap;
  final double cellSize;
  final bool isDragging;
  
  const BlockPiece({
    super.key,
    required this.block,
    this.isSelected = false,
    this.onTap,
    this.cellSize = 30,
    this.isDragging = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDragging ? 0.3 : 1.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(block.height, (row) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(block.width, (col) {
                final isBlock = block.shape[row][col] == 1;
                return Container(
                  width: cellSize,
                  height: cellSize,
                  margin: const EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                    gradient: isBlock
                        ? GameColors.blockGradients[block.colorIndex % GameColors.blockGradients.length]
                        : null,
                    borderRadius: BorderRadius.circular(6),
                    border: isBlock && isSelected
                        ? Border.all(color: Colors.white.withOpacity(0.8), width: 2)
                        : null,
                    boxShadow: isBlock
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 6,
                              offset: const Offset(2, 2),
                            ),
                          ]
                        : null,
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}

class DraggableBlockPiece extends StatelessWidget {
  final BlockShape block;
  final int index;
  final double cellSize;
  final double boardCellSize;
  final Function(BlockShape, int) onDragStarted;
  final VoidCallback onDragEnd;
  
  const DraggableBlockPiece({
    super.key,
    required this.block,
    required this.index,
    required this.cellSize,
    required this.boardCellSize,
    required this.onDragStarted,
    required this.onDragEnd,
  });
  
  @override
  Widget build(BuildContext context) {
    return Draggable<Map<String, dynamic>>(
      data: {'block': block, 'index': index},
      feedback: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(block.height, (row) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(block.width, (col) {
                final isBlock = block.shape[row][col] == 1;
                return Container(
                  width: boardCellSize,
                  height: boardCellSize,
                  margin: const EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                    gradient: isBlock
                        ? GameColors.blockGradients[block.colorIndex % GameColors.blockGradients.length]
                        : null,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: isBlock
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 8,
                              offset: const Offset(3, 3),
                            ),
                          ]
                        : null,
                  ),
                );
              }),
            );
          }),
        ),
      ),
      childWhenDragging: BlockPiece(
        block: block,
        cellSize: cellSize,
        isDragging: true,
      ),
      onDragStarted: () => onDragStarted(block, index),
      onDragEnd: (_) => onDragEnd(),
      child: BlockPiece(
        block: block,
        cellSize: cellSize,
      ),
    );
  }
}
