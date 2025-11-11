import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/points_provider.dart';
import '../../models/transaction_model.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      context.read<PointsProvider>().loadTransactions(
            userId: authProvider.currentUser?.id,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final pointsProvider = context.watch<PointsProvider>();
    final authProvider = context.watch<AuthProvider>();

    return RefreshIndicator(
      onRefresh: () => pointsProvider.loadTransactions(
        userId: authProvider.currentUser?.id,
      ),
      child: pointsProvider.transactions.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Noch keine Transaktionen'),
                ],
              ),
            )
          : Column(
              children: [
                // Summary Card
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kontoauszug',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _SummaryItem(
                              icon: Icons.arrow_upward,
                              label: 'Verdient',
                              value: _calculateTotal(
                                pointsProvider.transactions,
                                positive: true,
                              ),
                              color: Colors.green,
                            ),
                            _SummaryItem(
                              icon: Icons.arrow_downward,
                              label: 'Ausgegeben',
                              value: _calculateTotal(
                                pointsProvider.transactions,
                                positive: false,
                              ),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Transaction List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: pointsProvider.transactions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final transaction = pointsProvider.transactions[index];
                      return _TransactionCard(transaction: transaction);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  int _calculateTotal(List<TransactionModel> transactions, {required bool positive}) {
    return transactions
        .where((t) => positive ? t.points > 0 : t.points < 0)
        .fold(0, (sum, t) => sum + t.points.abs());
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          '$value',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
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

class _TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isPositive = transaction.points > 0;
    final dateFormat = DateFormat('dd.MM.yyyy');
    final timeFormat = DateFormat('HH:mm');

    Color backgroundColor;
    Color iconColor;

    switch (transaction.type) {
      case TransactionType.award:
        backgroundColor = Colors.green.shade50;
        iconColor = Colors.green.shade700;
        break;
      case TransactionType.deduction:
        backgroundColor = Colors.red.shade50;
        iconColor = Colors.red.shade700;
        break;
      case TransactionType.reset:
        backgroundColor = Colors.orange.shade50;
        iconColor = Colors.orange.shade700;
        break;
      case TransactionType.rewardRedemption:
        backgroundColor = Colors.purple.shade50;
        iconColor = Colors.purple.shade700;
        break;
      case TransactionType.refund:
        backgroundColor = Colors.blue.shade50;
        iconColor = Colors.blue.shade700;
        break;
    }

    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                transaction.icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.reason,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 14,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        transaction.adminName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${dateFormat.format(transaction.timestamp)} • ${timeFormat.format(transaction.timestamp)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '${isPositive ? '+' : ''}${transaction.points}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
