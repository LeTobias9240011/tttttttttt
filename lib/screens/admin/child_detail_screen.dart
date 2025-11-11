import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/user_model.dart';
import '../../models/transaction_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/points_provider.dart';
import '../../providers/rewards_provider.dart';

class ChildDetailScreen extends StatefulWidget {
  final UserModel child;

  const ChildDetailScreen({super.key, required this.child});

  @override
  State<ChildDetailScreen> createState() => _ChildDetailScreenState();
}

class _ChildDetailScreenState extends State<ChildDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PointsProvider>().loadTransactions(userId: widget.child.id);
      context.read<RewardsProvider>().loadRewards();
    });
  }

  Future<void> _showPointsDialog({required bool isAward}) async {
    final pointsController = TextEditingController();
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isAward ? 'Punkte vergeben' : 'Punkte abziehen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: pointsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Anzahl Punkte',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Grund',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Bestätigen'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final points = int.tryParse(pointsController.text);
      final reason = reasonController.text.trim();

      if (points == null || points <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bitte gültige Punktzahl eingeben')),
        );
        return;
      }

      if (reason.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bitte Grund angeben')),
        );
        return;
      }

      final authProvider = context.read<AuthProvider>();
      final pointsProvider = context.read<PointsProvider>();

      final error = isAward
          ? await pointsProvider.awardPoints(
              userId: widget.child.id,
              userName: widget.child.displayName,
              points: points,
              reason: reason,
              adminId: authProvider.currentUser!.id,
              adminName: authProvider.currentUser!.displayName,
            )
          : await pointsProvider.deductPoints(
              userId: widget.child.id,
              userName: widget.child.displayName,
              points: points,
              reason: reason,
              adminId: authProvider.currentUser!.id,
              adminName: authProvider.currentUser!.displayName,
            );

      if (context.mounted) {
        if (error == null) {
          await authProvider.refreshUserData();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error ??
                  (isAward
                      ? 'Punkte erfolgreich vergeben'
                      : 'Punkte erfolgreich abgezogen'),
            ),
            backgroundColor: error == null
                ? Colors.green
                : Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _showResetDialog() async {
    final reasonController = TextEditingController(text: 'Monatliches Reset');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Punkte zurücksetzen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Möchten Sie die Punkte von ${widget.child.displayName} wirklich auf 0 zurücksetzen?',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Grund',
                border: OutlineInputBorder(),
              ),
            ),
          ],
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

      final error = await pointsProvider.resetPoints(
        userId: widget.child.id,
        userName: widget.child.displayName,
        reason: reasonController.text.trim(),
        adminId: authProvider.currentUser!.id,
        adminName: authProvider.currentUser!.displayName,
      );

      if (context.mounted) {
        if (error == null) {
          await authProvider.refreshUserData();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Punkte erfolgreich zurückgesetzt'),
            backgroundColor: error == null
                ? Colors.green
                : Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _showGrantRewardDialog() async {
    final rewardsProvider = context.read<RewardsProvider>();
    
    if (rewardsProvider.rewards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keine Belohnungen verfügbar')),
      );
      return;
    }

    String? selectedRewardId;
    final noteController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Belohnung vergeben'),
        content: StatefulBuilder(
          builder: (context, setState) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Wähle eine Belohnung für ${widget.child.displayName}:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ...rewardsProvider.rewards.map((reward) {
                  final canAfford = widget.child.currentPoints >= reward.pointsCost;
                  return Card(
                    color: selectedRewardId == reward.id
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    child: InkWell(
                      onTap: canAfford
                          ? () => setState(() => selectedRewardId = reward.id)
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    reward.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  '${reward.pointsCost} Punkte',
                                  style: TextStyle(
                                    color: canAfford
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              reward.description,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (!canAfford)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Nicht genug Punkte',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Notiz (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Belohnung vergeben'),
          ),
        ],
      ),
    );

    if (confirmed == true && selectedRewardId != null && context.mounted) {
      final reward = rewardsProvider.rewards.firstWhere((r) => r.id == selectedRewardId);
      final authProvider = context.read<AuthProvider>();

      final error = await rewardsProvider.grantRewardDirectly(
        userId: widget.child.id,
        userName: widget.child.displayName,
        rewardId: reward.id,
        rewardTitle: reward.title,
        pointsCost: reward.pointsCost,
        adminId: authProvider.currentUser!.id,
        adminName: authProvider.currentUser!.displayName,
        note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
      );

      if (context.mounted) {
        if (error == null) {
          await authProvider.refreshUserData();
          await context.read<PointsProvider>().loadTransactions(userId: widget.child.id);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Belohnung erfolgreich vergeben'),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.child.displayName),
      ),
      body: Column(
        children: [
          // Points Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    '${widget.child.currentPoints}',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  Text(
                    'Aktuelle Punkte',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: (widget.child.currentPoints / widget.child.weeklyGoal)
                        .clamp(0.0, 1.0),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Wochenziel: ${widget.child.weeklyGoal}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _showPointsDialog(isAward: true),
                    icon: const Icon(Icons.add),
                    label: const Text('Punkte vergeben'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: () => _showPointsDialog(isAward: false),
                    icon: const Icon(Icons.remove),
                    label: const Text('Punkte abziehen'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _showGrantRewardDialog,
                    icon: const Icon(Icons.card_giftcard),
                    label: const Text('Belohnung vergeben'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: _showResetDialog,
              icon: const Icon(Icons.restore),
              label: const Text('Punkte zurücksetzen'),
            ),
          ),

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Transaktionsverlauf',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),

          // Transaction History
          Expanded(
            child: pointsProvider.transactions.isEmpty
                ? const Center(
                    child: Text('Noch keine Transaktionen'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: pointsProvider.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = pointsProvider.transactions[index];
                      return _TransactionTile(transaction: transaction);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.points > 0;
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPositive
              ? Colors.green.withOpacity(0.2)
              : Colors.red.withOpacity(0.2),
          child: Text(
            transaction.icon,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(transaction.reason),
        subtitle: Text(
          'Von ${transaction.adminName} • ${dateFormat.format(transaction.timestamp)}',
        ),
        trailing: Text(
          '${isPositive ? '+' : ''}${transaction.points}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isPositive ? Colors.green : Colors.red,
              ),
        ),
      ),
    );
  }
}
