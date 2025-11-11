import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/auth_provider.dart';

class PointsOverviewScreen extends StatelessWidget {
  const PointsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final progress = (user.currentPoints / user.weeklyGoal).clamp(0.0, 1.0);
    final remainingPoints = (user.weeklyGoal - user.currentPoints).clamp(0, user.weeklyGoal);

    return RefreshIndicator(
      onRefresh: () => authProvider.refreshUserData(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Points Card
            Card(
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Dein Punktestand',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${user.currentPoints}',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 72,
                          ),
                    ),
                    Text(
                      'Punkte',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 24),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white30,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Ziel: ${user.weeklyGoal}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Progress Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fortschritt zum Wochenziel',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 60,
                          sections: [
                            PieChartSectionData(
                              value: user.currentPoints.toDouble(),
                              title: '${user.currentPoints}',
                              color: Theme.of(context).colorScheme.primary,
                              radius: 50,
                              titleStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            PieChartSectionData(
                              value: remainingPoints.toDouble(),
                              title: '$remainingPoints',
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              radius: 50,
                              titleStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LegendItem(
                          color: Theme.of(context).colorScheme.primary,
                          label: 'Erreichte Punkte',
                        ),
                        const SizedBox(width: 24),
                        _LegendItem(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          label: 'Verbleibend',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Motivational Messages
            if (progress >= 1.0)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.celebration, color: Colors.green.shade700, size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fantastisch! 🎉',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade900,
                              ),
                            ),
                            Text(
                              'Du hast dein Wochenziel erreicht!',
                              style: TextStyle(color: Colors.green.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (progress >= 0.75)
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.orange.shade700, size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fast geschafft! 💪',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade900,
                              ),
                            ),
                            Text(
                              'Noch $remainingPoints Punkte bis zum Ziel!',
                              style: TextStyle(color: Colors.orange.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.blue.shade700, size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Weiter so! 🌟',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            Text(
                              'Noch $remainingPoints Punkte bis zum Wochenziel!',
                              style: TextStyle(color: Colors.blue.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
