import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/services/location_service.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool _locationPermissionGranted = false;
  bool _notificationPermissionGranted = false;
  bool _isLocating = false;
  String? _cityPreview;

  Future<void> _requestLocationWithMessage() async {
    setState(() {
      _isLocating = true;
    });
    final snap = await LocationService.getFast(requestPermission: true);
    if (!mounted) return;
    setState(() {
      _isLocating = false;
      _locationPermissionGranted = snap != null;
      _cityPreview = snap?.city;
    });
    if (snap != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            snap.city != null ? 'Konum kaydedildi: ${snap.city}' : 'Konum kaydedildi',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konum alınamadı. İzin verip tekrar deneyin.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 24 : 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              
              // Logo ve Başlık
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  size: 60,
                  color: Color(0xFFCCFF00),
                ),
              ),
              const SizedBox(height: 32),
              
              Text(
                'Hoş Geldiniz!',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              Text(
                'Ürünleri keşfetmeye başlamak için izinleri onaylayın',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFFB3B3B3),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (_isLocating)
                const Text(
                  'Konumunuz alınıyor...',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFCCFF00), fontWeight: FontWeight.w600),
                )
              else if (_cityPreview != null)
                Text(
                  'Tespit edilen şehir: $_cityPreview',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              const SizedBox(height: 48),

              // İzinler
              _PermissionCard(
                icon: Icons.location_on_outlined,
                title: 'Konum İzni',
                description: 'Size en yakın ürünleri ve teslimat seçeneklerini göstermek için',
                isGranted: _locationPermissionGranted,
                onTap: () {
                  if (_isLocating) return;
                  _requestLocationWithMessage();
                },
              ),
              const SizedBox(height: 16),
              
              _PermissionCard(
                icon: Icons.notifications_outlined,
                title: 'Bildirim İzni',
                description: 'Kampanyalar ve sipariş durumu hakkında bilgilendirme için',
                isGranted: _notificationPermissionGranted,
                onTap: () {
                  setState(() {
                    _notificationPermissionGranted = !_notificationPermissionGranted;
                  });
                },
              ),
              
              const Spacer(),
              
              // Keşfetmeye Devam Et Butonu (Öncelikli)
              ElevatedButton(
                onPressed: () {
                  final authProvider = context.read<AuthProvider>();
                  authProvider.enableGuestMode();
                  context.go('/explore');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCCFF00),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Keşfetmeye Devam Et',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Giriş Yap Butonu (İkincil)
              OutlinedButton(
                onPressed: () {
                  context.push('/login');
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: const Color(0xFFCCFF00),
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Giriş Yap',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFCCFF00),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  final authProvider = context.read<AuthProvider>();
                  authProvider.enableGuestMode();
                  context.go('/home');
                },
                child: const Text(
                  'Ana Sayfaya Geç',
                  style: TextStyle(
                    color: Color(0xFFCCFF00),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isGranted;
  final VoidCallback onTap;

  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isGranted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isGranted
              ? const Color(0xFFCCFF00).withOpacity(0.12)
              : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isGranted
                ? const Color(0xFFCCFF00)
                : Colors.white24,
            width: isGranted ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isGranted
                    ? const Color(0xFFCCFF00)
                    : const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isGranted
                    ? Colors.black
                    : const Color(0xFFB3B3B3),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFB3B3B3),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isGranted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isGranted
                  ? const Color(0xFFCCFF00)
                  : const Color(0xFFB3B3B3),
            ),
          ],
        ),
      ),
    );
  }
}

