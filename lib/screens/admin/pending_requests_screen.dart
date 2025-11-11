import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/rewards_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/reward_model.dart';

class PendingRequestsScreen extends StatelessWidget {
  const PendingRequestsScreen({super.key});

  Future<void> _handleApprove(BuildContext context, RewardRequest request) async {
    final noteController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Belohnung genehmigen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${request.userName} möchte "${request.rewardTitle}" einlösen.'),
            const SizedBox(height: 8),
            Text('Kosten: ${request.pointsCost} Punkte'),
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Genehmigen'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final authProvider = context.read<AuthProvider>();
      final rewardsProvider = context.read<RewardsProvider>();

      final error = await rewardsProvider.approveRewardRequest(
        requestId: request.id,
        adminId: authProvider.currentUser!.id,
        adminName: authProvider.currentUser!.displayName,
        note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Belohnung wurde genehmigt'),
            backgroundColor:
                error == null ? Colors.green : Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _handleReject(BuildContext context, RewardRequest request) async {
    final noteController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Belohnung ablehnen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Möchten Sie die Anfrage von ${request.userName} wirklich ablehnen?'),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Grund (optional)',
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
            child: const Text('Ablehnen'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final authProvider = context.read<AuthProvider>();
      final rewardsProvider = context.read<RewardsProvider>();

      final error = await rewardsProvider.rejectRewardRequest(
        requestId: request.id,
        adminId: authProvider.currentUser!.id,
        adminName: authProvider.currentUser!.displayName,
        note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Anfrage wurde abgelehnt'),
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
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');

    return RefreshIndicator(
      onRefresh: () => rewardsProvider.loadPendingRequests(),
      child: rewardsProvider.pendingRequests.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Keine offenen Anfragen'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rewardsProvider.pendingRequests.length,
              itemBuilder: (context, index) {
                final request = rewardsProvider.pendingRequests[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primaryContainer,
                              child: Text(
                                request.userName[0].toUpperCase(),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
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
                                    request.userName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    dateFormat.format(request.requestedAt),
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            const Icon(Icons.card_giftcard, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                request.rewardTitle,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 20, color: Colors.amber),
                            const SizedBox(width: 8),
                            Text(
                              '${request.pointsCost} Punkte',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _handleReject(context, request),
                                icon: const Icon(Icons.close),
                                label: const Text('Ablehnen'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () => _handleApprove(context, request),
                                icon: const Icon(Icons.check),
                                label: const Text('Genehmigen'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
