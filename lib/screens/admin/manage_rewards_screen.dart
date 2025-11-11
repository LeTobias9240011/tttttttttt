import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/rewards_provider.dart';
import '../../models/reward_model.dart';

class ManageRewardsScreen extends StatelessWidget {
  const ManageRewardsScreen({super.key});

  Future<void> _showAddRewardDialog(BuildContext context) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final pointsController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Neue Belohnung'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Titel',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Beschreibung',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: pointsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Punktekosten',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Erstellen'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final title = titleController.text.trim();
      final description = descriptionController.text.trim();
      final points = int.tryParse(pointsController.text);

      if (title.isEmpty || description.isEmpty || points == null || points <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bitte alle Felder korrekt ausfüllen')),
        );
        return;
      }

      final rewardsProvider = context.read<RewardsProvider>();
      final error = await rewardsProvider.createReward(
        title: title,
        description: description,
        pointsCost: points,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Belohnung erfolgreich erstellt'),
            backgroundColor:
                error == null ? Colors.green : Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rewardsProvider = context.watch<RewardsProvider>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => rewardsProvider.loadRewards(),
        child: rewardsProvider.rewards.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.card_giftcard, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('Noch keine Belohnungen erstellt'),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => _showAddRewardDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text('Belohnung hinzufügen'),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rewardsProvider.rewards.length,
                itemBuilder: (context, index) {
                  final reward = rewardsProvider.rewards[index];
                  return _RewardCard(reward: reward);
                },
              ),
      ),
      floatingActionButton: rewardsProvider.rewards.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showAddRewardDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Neue Belohnung'),
            )
          : null,
    );
  }
}

class _RewardCard extends StatelessWidget {
  final RewardModel reward;

  const _RewardCard({required this.reward});

  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Belohnung löschen?'),
        content: Text(
          'Möchten Sie die Belohnung "${reward.title}" wirklich löschen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final rewardsProvider = context.read<RewardsProvider>();
      final error = await rewardsProvider.deleteReward(reward.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Belohnung erfolgreich gelöscht'),
            backgroundColor:
                error == null ? Colors.green : Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.card_giftcard,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          reward.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(reward.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${reward.pointsCost}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Löschen',
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
