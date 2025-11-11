import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _OrderCard(
            orderId: 'ORD-001',
            date: '2024-01-15',
            status: 'Delivered',
            total: 299.99,
            items: 3,
          ),
          _OrderCard(
            orderId: 'ORD-002',
            date: '2024-01-10',
            status: 'Shipped',
            total: 149.99,
            items: 2,
          ),
          _OrderCard(
            orderId: 'ORD-003',
            date: '2024-01-05',
            status: 'Processing',
            total: 89.99,
            items: 1,
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderId;
  final String date;
  final String status;
  final double total;
  final int items;

  const _OrderCard({
    required this.orderId,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderId,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Date: $date',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              '$items items',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // View details
                    },
                    child: const Text('View Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Reorder
                    },
                    child: const Text('Reorder'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

