import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/points_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import 'child_detail_screen.dart';

class ChildrenOverviewScreen extends StatelessWidget {
  const ChildrenOverviewScreen({super.key});

  Future<void> _showResetAllDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alle Punkte zurücksetzen?'),
        content: const Text(
          'Möchten Sie wirklich alle Punktestände auf 0 zurücksetzen? '
          'Diese Aktion kann nicht rückgängig gemacht werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Zurücksetzen'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final authProvider = context.read<AuthProvider>();
      final pointsProvider = context.read<PointsProvider>();

      final error = await pointsProvider.resetAllPoints(
        reason: 'Monatliches Reset',
        adminId: authProvider.currentUser!.id,
        adminName: authProvider.currentUser!.displayName,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error ?? 'Alle Punkte wurden zurückgesetzt',
            ),
            backgroundColor: error == null
                ? Colors.green
                : Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pointsProvider = context.watch<PointsProvider>();

    return Column(
      children: [
        // Statistics Card
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.people,
                  label: 'Kinder',
                  value: pointsProvider.children.length.toString(),
                ),
                _StatItem(
                  icon: Icons.star,
                  label: 'Ø Punkte',
                  value: pointsProvider.children.isEmpty
                      ? '0'
                      : (pointsProvider.children
                                  .map((c) => c.currentPoints)
                                  .reduce((a, b) => a + b) /
                              pointsProvider.children.length)
                          .toStringAsFixed(1),
                ),
                IconButton(
                  icon: const Icon(Icons.restore),
                  tooltip: 'Alle zurücksetzen',
                  onPressed: pointsProvider.children.isEmpty
                      ? null
                      : () => _showResetAllDialog(context),
                ),
              ],
            ),
          ),
        ),

        // Children List
        Expanded(
          child: pointsProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : pointsProvider.children.isEmpty
                  ? const Center(
                      child: Text('Noch keine Kinder registriert'),
                    )
                  : RefreshIndicator(
                      onRefresh: () => pointsProvider.loadChildren(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: pointsProvider.children.length,
                        itemBuilder: (context, index) {
                          final child = pointsProvider.children[index];
                          return _ChildCard(child: child);
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _ChildCard extends StatelessWidget {
  final UserModel child;

  const _ChildCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final progress = child.currentPoints / child.weeklyGoal;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChildDetailScreen(child: child),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Text(
                      child.displayName[0].toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          child.displayName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '@${child.username}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${child.currentPoints}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      Text(
                        'Punkte',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Wochenziel: ${child.weeklyGoal}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${(progress * 100).clamp(0, 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
