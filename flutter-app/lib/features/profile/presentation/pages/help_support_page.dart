import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HelpSupportPage extends StatefulWidget {
  const HelpSupportPage({super.key});

  @override
  State<HelpSupportPage> createState() => _HelpSupportPageState();
}

class _HelpSupportPageState extends State<HelpSupportPage> {
  final List<Map<String, dynamic>> _tickets = [
    {
      'id': '1',
      'subject': 'Order not delivered',
      'status': 'Open',
      'date': '2024-01-15',
      'priority': 'High',
    },
    {
      'id': '2',
      'subject': 'Product quality issue',
      'status': 'Resolved',
      'date': '2024-01-10',
      'priority': 'Medium',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Support Options
            _buildSupportOption(
              context,
              icon: Icons.chat_bubble_outline,
              title: 'Live Support',
              subtitle: 'Chat with our support team',
              color: Colors.green,
              onTap: () => _showLiveSupport(context),
            ),
            const SizedBox(height: 12),
            _buildSupportOption(
              context,
              icon: Icons.support_agent_outlined,
              title: 'Support Tickets',
              subtitle: 'View and manage your tickets',
              color: Colors.blue,
              onTap: () => _showTickets(context),
            ),
            const SizedBox(height: 24),

            // FAQ Section
            _buildSectionHeader(context, 'Frequently Asked Questions'),
            Card(
              child: ExpansionTile(
                title: const Text('How do I track my order?'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'You can track your order by going to the Orders section in your profile. You will receive tracking updates via email and push notifications.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: ExpansionTile(
                title: const Text('How can I return a product?'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'You can return products within 14 days of delivery. Go to your Orders section, select the order, and click on "Return Item".',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: ExpansionTile(
                title: const Text('What payment methods do you accept?'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'We accept credit cards, debit cards, and digital wallets. You can add your payment methods in the Payment Methods section.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: ExpansionTile(
                title: const Text('How do I change my password?'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Go to Settings > Account > Change Password. You will receive an email with instructions to reset your password.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Contact Information
            _buildSectionHeader(context, 'Contact Us'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildContactItem(
                      context,
                      icon: Icons.email_outlined,
                      title: 'Email',
                      value: 'support@ecommerce.com',
                      onTap: () {},
                    ),
                    const Divider(),
                    _buildContactItem(
                      context,
                      icon: Icons.phone_outlined,
                      title: 'Phone',
                      value: '+90 850 123 45 67',
                      onTap: () {},
                    ),
                    const Divider(),
                    _buildContactItem(
                      context,
                      icon: Icons.access_time_outlined,
                      title: 'Support Hours',
                      value: 'Monday - Friday, 9:00 AM - 6:00 PM',
                      onTap: () {},
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

  Widget _buildSupportOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  void _showLiveSupport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.support_agent,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Live Support',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          'Online',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        children: [
                          _buildChatMessage(
                            context,
                            isUser: false,
                            message: 'Hello! How can I help you today?',
                            time: '10:30 AM',
                          ),
                          _buildChatMessage(
                            context,
                            isUser: true,
                            message: 'Hi, I have a question about my order.',
                            time: '10:31 AM',
                          ),
                          _buildChatMessage(
                            context,
                            isUser: false,
                            message: 'Sure! Can you please provide your order number?',
                            time: '10:32 AM',
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Type your message...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FloatingActionButton(
                            mini: true,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Message sent!')),
                              );
                            },
                            child: const Icon(Icons.send),
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

  Widget _buildChatMessage(
    BuildContext context, {
    required bool isUser,
    required String message,
    required String time,
  }) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isUser ? Colors.white : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 10,
                color: isUser
                    ? Colors.white.withOpacity(0.7)
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTickets(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Support Tickets',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _tickets.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.support_agent_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No tickets yet',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create a new support ticket',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _tickets.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _tickets.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: ElevatedButton.icon(
                              onPressed: () => _showCreateTicketDialog(context),
                              icon: const Icon(Icons.add),
                              label: const Text('Create New Ticket'),
                            ),
                          );
                        }
                        final ticket = _tickets[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getStatusColor(ticket['status']).withOpacity(0.1),
                              child: Icon(
                                _getStatusIcon(ticket['status']),
                                color: _getStatusColor(ticket['status']),
                              ),
                            ),
                            title: Text(ticket['subject']),
                            subtitle: Text('${ticket['date']} • ${ticket['priority']}'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(ticket['status']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                ticket['status'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _getStatusColor(ticket['status']),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            onTap: () {
                              // View ticket details
                            },
                          ),
                        );
                      },
                    ),
            ),
            if (_tickets.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _showCreateTicketDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Create New Ticket'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCreateTicketDialog(BuildContext context) {
    final subjectController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Support Ticket'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ticket created successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Icons.access_time;
      case 'resolved':
        return Icons.check_circle;
      case 'closed':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
}

