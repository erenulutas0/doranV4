import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  final List<Map<String, dynamic>> _addresses = [
    {
      'id': '1',
      'title': 'Home',
      'name': 'John Doe',
      'address': '123 Main Street, Apt 4B',
      'city': 'Istanbul',
      'postalCode': '34000',
      'phone': '+90 555 123 45 67',
      'isDefault': true,
    },
    {
      'id': '2',
      'title': 'Work',
      'name': 'John Doe',
      'address': '456 Business Avenue, Floor 5',
      'city': 'Istanbul',
      'postalCode': '34000',
      'phone': '+90 555 987 65 43',
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Addresses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddAddressDialog(context),
          ),
        ],
      ),
      body: _addresses.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final address = _addresses[index];
                return _buildAddressCard(context, address, index);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAddressDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Address'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No addresses yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first address to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddAddressDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Address'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, Map<String, dynamic> address, int index) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      address['title'] == 'Home'
                          ? Icons.home_outlined
                          : address['title'] == 'Work'
                              ? Icons.work_outline
                              : Icons.location_on_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      address['title'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (address['isDefault'] == true) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Default',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                      onTap: () => _showEditAddressDialog(context, address, index),
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          Icon(
                            address['isDefault'] == true
                                ? Icons.star
                                : Icons.star_outline,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(address['isDefault'] == true
                              ? 'Remove Default'
                              : 'Set as Default'),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          for (var addr in _addresses) {
                            addr['isDefault'] = false;
                          }
                          _addresses[index]['isDefault'] = !address['isDefault'];
                        });
                      },
                    ),
                    PopupMenuItem(
                      child: const Row(
                        children: [
                          Icon(Icons.delete_outline, size: 20, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _addresses.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Address deleted')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              address['name'],
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              address['address'],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              '${address['city']}, ${address['postalCode']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  address['phone'],
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    _showAddressDialog(context, null, -1);
  }

  void _showEditAddressDialog(BuildContext context, Map<String, dynamic> address, int index) {
    _showAddressDialog(context, address, index);
  }

  void _showAddressDialog(BuildContext context, Map<String, dynamic>? address, int index) {
    final titleController = TextEditingController(text: address?['title'] ?? '');
    final nameController = TextEditingController(text: address?['name'] ?? '');
    final addressController = TextEditingController(text: address?['address'] ?? '');
    final cityController = TextEditingController(text: address?['city'] ?? '');
    final postalCodeController = TextEditingController(text: address?['postalCode'] ?? '');
    final phoneController = TextEditingController(text: address?['phone'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(address == null ? 'Add Address' : 'Edit Address'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Address Title (Home, Work, etc.)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: postalCodeController,
                decoration: const InputDecoration(
                  labelText: 'Postal Code',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
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
              if (index == -1) {
                setState(() {
                  _addresses.add({
                    'id': DateTime.now().millisecondsSinceEpoch.toString(),
                    'title': titleController.text,
                    'name': nameController.text,
                    'address': addressController.text,
                    'city': cityController.text,
                    'postalCode': postalCodeController.text,
                    'phone': phoneController.text,
                    'isDefault': _addresses.isEmpty,
                  });
                });
              } else {
                setState(() {
                  _addresses[index] = {
                    ..._addresses[index],
                    'title': titleController.text,
                    'name': nameController.text,
                    'address': addressController.text,
                    'city': cityController.text,
                    'postalCode': postalCodeController.text,
                    'phone': phoneController.text,
                  };
                });
              }
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(address == null ? 'Address added!' : 'Address updated!'),
                ),
              );
            },
            child: Text(address == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }
}

