class BlockShape {
  final List<List<int>> shape;
  final int colorIndex;
  
  BlockShape(this.shape, this.colorIndex);
  
  // Turli xil blok shakllari
  static List<BlockShape> getAllShapes() {
    return [
      // 1x1 blok
      BlockShape([[1]], 0),
      
      // 2x1 bloklar
      BlockShape([[1, 1]], 1),
      BlockShape([[1], [1]], 1),
      
      // 3x1 bloklar
      BlockShape([[1, 1, 1]], 2),
      BlockShape([[1], [1], [1]], 2),
      
      // L shakli
      BlockShape([
        [1, 0],
        [1, 1]
      ], 3),
      
      // T shakli
      BlockShape([
        [1, 1, 1],
        [0, 1, 0]
      ], 4),
      
      // Kvadrat 2x2
      BlockShape([
        [1, 1],
        [1, 1]
      ], 0),
      
      // Kvadrat 3x3
      BlockShape([
        [1, 1, 1],
        [1, 1, 1],
        [1, 1, 1]
      ], 1),
      
      // Z shakli
      BlockShape([
        [1, 1, 0],
        [0, 1, 1]
      ], 2),
    ];
  }
  
  int get width => shape[0].length;
  int get height => shape.length;
}
