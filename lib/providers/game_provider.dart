import 'package:flutter/foundation.dart';
import '../models/game_state.dart';
import '../models/block_shape.dart';

class GameProvider extends ChangeNotifier {
  late GameState _gameState;
  BlockShape? _selectedBlock;
  int? _selectedBlockIndex;
  
  GameProvider() {
    _gameState = GameState();
    _gameState.generateNewBlocks();
  }
  
  GameState get gameState => _gameState;
  BlockShape? get selectedBlock => _selectedBlock;
  int? get selectedBlockIndex => _selectedBlockIndex;
  
  void selectBlock(int index) {
    if (_selectedBlockIndex == index) {
      _selectedBlock = null;
      _selectedBlockIndex = null;
    } else {
      _selectedBlock = _gameState.currentBlocks[index];
      _selectedBlockIndex = index;
    }
    notifyListeners();
  }
  
  bool placeBlock(int row, int col) {
    if (_selectedBlock == null || _selectedBlockIndex == null) return false;
    
    if (_gameState.canPlaceBlock(_selectedBlock!, row, col)) {
      _gameState.placeBlock(_selectedBlock!, row, col);
      _gameState.currentBlocks.removeAt(_selectedBlockIndex!);
      _selectedBlock = null;
      _selectedBlockIndex = null;
      
      if (_gameState.currentBlocks.isEmpty) {
        _gameState.generateNewBlocks();
      }
      
      notifyListeners();
      return true;
    }
    return false;
  }
  
  bool hasValidMoves() {
    return _gameState.hasValidMoves();
  }
  
  void resetGame() {
    _gameState.reset();
    _selectedBlock = null;
    _selectedBlockIndex = null;
    notifyListeners();
  }
}
