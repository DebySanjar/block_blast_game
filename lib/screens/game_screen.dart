import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/colors.dart';
import '../providers/game_provider.dart';
import '../models/block_shape.dart';
import '../widgets/game_board.dart';
import '../widgets/block_piece.dart';
import '../widgets/score_display.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});
  
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  BlockShape? _draggedBlock;
  Offset? _dragPosition;
  double _boardCellSize = 30.0;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    _controller.forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _onBlockDropped(int row, int col, BlockShape block, int index) {
    final provider = Provider.of<GameProvider>(context, listen: false);
    
    if (provider.gameState.canPlaceBlock(block, row, col)) {
      provider.gameState.placeBlock(block, row, col);
      provider.gameState.currentBlocks.removeAt(index);
      
      if (provider.gameState.currentBlocks.isEmpty) {
        provider.gameState.generateNewBlocks();
      }
      
      setState(() {
        _draggedBlock = null;
        _dragPosition = null;
      });
      
      provider.notifyListeners();
      
      if (!provider.hasValidMoves()) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            _showGameOverDialog(context);
          }
        });
      }
    } else {
      setState(() {
        _draggedBlock = null;
        _dragPosition = null;
      });
    }
  }
  
  void _showGameOverDialog(BuildContext context) {
    final provider = Provider.of<GameProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final fontSize = isSmallScreen ? 16.0 : 18.0;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: GameColors.boardBackground,
        title: const Text(
          'O\'yin tugadi!',
          style: TextStyle(color: GameColors.textPrimary),
        ),
        content: Text(
          'Ball: ${provider.gameState.score}\nDaraja: ${provider.gameState.level}',
          style: TextStyle(
            color: GameColors.textSecondary,
            fontSize: fontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              provider.resetGame();
            },
            child: Text(
              'Qayta boshlash',
              style: TextStyle(
                color: GameColors.buttonColor,
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  double _calculateBoardCellSize(double screenWidth, bool isTablet) {
    final totalPadding = isTablet ? 100.0 : 70.0;
    return (screenWidth - totalPadding) / 8;
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final isTablet = size.width > 600;
    
    // Taxta katakchalar o'lchami
    _boardCellSize = _calculateBoardCellSize(size.width, isTablet);
    
    return Scaffold(
      backgroundColor: GameColors.background,
      appBar: AppBar(
        backgroundColor: GameColors.boardBackground,
        elevation: 0,
        title: Text(
          'Block Lock',
          style: TextStyle(
            color: GameColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 18 : 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: GameColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: GameColors.textPrimary),
            onPressed: () {
              Provider.of<GameProvider>(context, listen: false).resetGame();
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Listener(
          onPointerMove: (details) {
            if (_draggedBlock != null) {
              setState(() {
                _dragPosition = details.position;
              });
            }
          },
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    SizedBox(height: size.height * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? size.width * 0.1 : 16,
                      ),
                      child: Consumer<GameProvider>(
                        builder: (context, provider, child) {
                          return ScoreDisplay(
                            score: provider.gameState.score,
                            level: provider.gameState.level,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? size.width * 0.1 : 16,
                          ),
                          child: SizedBox(
                            width: size.width - (isTablet ? size.width * 0.2 : 32),
                            child: Consumer<GameProvider>(
                              builder: (context, provider, child) {
                                return GameBoard(
                                  gameState: provider.gameState,
                                  onBlockDropped: _onBlockDropped,
                                  hoveredBlock: _draggedBlock,
                                  hoverPosition: _dragPosition,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Consumer<GameProvider>(
                      builder: (context, provider, child) {
                        // Pastdagi bloklar uchun kichikroq o'lcham
                        final blockCellSize = isSmallScreen ? 20.0 : (isTablet ? 30.0 : 24.0);
                        
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? size.width * 0.1 : 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              provider.gameState.currentBlocks.length,
                              (index) => DraggableBlockPiece(
                                block: provider.gameState.currentBlocks[index],
                                index: index,
                                cellSize: blockCellSize,
                                boardCellSize: _boardCellSize,
                                onDragStarted: (block, idx) {
                                  setState(() {
                                    _draggedBlock = block;
                                  });
                                },
                                onDragEnd: () {
                                  setState(() {
                                    _draggedBlock = null;
                                    _dragPosition = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: size.height * 0.01),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
