import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/di/injection_container.dart';
import '../../core/services/pwa_service.dart';

/// Widget to show PWA install prompt banner
class PWAInstallPrompt extends StatefulWidget {
  const PWAInstallPrompt({super.key});

  @override
  State<PWAInstallPrompt> createState() => _PWAInstallPromptState();
}

class _PWAInstallPromptState extends State<PWAInstallPrompt> {
  final PWAService _pwaService = sl<PWAService>();
  bool _showPrompt = false;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _checkInstallability();
  }

  void _checkInstallability() {
    if (!kIsWeb) return;
    
    // Only show prompt if app is installable and not already installed
    if (_pwaService.isInstallable && !_pwaService.isInstalled && !_dismissed) {
      setState(() {
        _showPrompt = true;
      });
    }
  }

  void _dismiss() {
    setState(() {
      _showPrompt = false;
      _dismissed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_showPrompt || !kIsWeb) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.get_app,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Install App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: _dismiss,
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Install Smart Parking System for quick access and offline support.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _dismiss,
                child: const Text(
                  'Not now',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _pwaService.showInstallPrompt();
                  _dismiss();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Install',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Snackbar helper for PWA install prompt
class PWAInstallSnackbar {
  static void show(BuildContext context) {
    if (!kIsWeb) return;
    
    final pwaService = sl<PWAService>();
    
    if (!pwaService.isInstallable || pwaService.isInstalled) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.get_app, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Install app for offline access',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 8),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: 'Install',
          textColor: Colors.white,
          onPressed: () {
            pwaService.showInstallPrompt();
          },
        ),
      ),
    );
  }
}
