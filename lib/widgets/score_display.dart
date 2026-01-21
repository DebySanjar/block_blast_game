import 'package:flutter/material.dart';
import '../config/colors.dart';

class ScoreDisplay extends StatelessWidget {
  final int score;
  final int level;
  
  const ScoreDisplay({
    super.key,
    required this.score,
    required this.level,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: GameColors.scoreBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildScoreItem('Ball', score.toString()),
          Container(
            width: 2,
            height: 30,
            color: GameColors.textSecondary.withOpacity(0.3),
          ),
          _buildScoreItem('Daraja', level.toString()),
        ],
      ),
    );
  }
  
  Widget _buildScoreItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: GameColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: GameColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
