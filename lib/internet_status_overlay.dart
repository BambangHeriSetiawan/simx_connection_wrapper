// lib/ui/components/internet_status_overlay.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simx_connection_wrapper/internet_connection_notifier.dart';

class InternetStatusOverlay extends HookConsumerWidget {
  const InternetStatusOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(internetConnectionProvider);

    if (status != InternetConnectionStatus.disconnected) {
      return const SizedBox.shrink();
    }

    String title;
    String description;
    IconData icon;
    Color iconColor = Theme.of(context).colorScheme.error;

    if (status == InternetConnectionStatus.connecting) {
      title = "Mengecek Koneksi Internet...";
      description = "Mohon tunggu sebentar.";
      icon = Icons.wifi;
      iconColor = Theme.of(context).colorScheme.primary;
    } else {
      title = "Tidak Terhubung ke Internet";
      description = "Koneksi internet hilang. Harap periksa koneksi Anda.";
      icon = Icons.wifi_off;
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 5000), () {
          if (ref.read(internetConnectionProvider) ==
              InternetConnectionStatus.connecting) {
            ref.read(internetConnectionProvider.notifier).checkNow();
          }
        });
      });
      return null;
    }, [status]);
    return Stack(
      children: [
        ModalBarrier(color: Colors.black.withOpacity(0.8), dismissible: false),
        Center(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 60, color: iconColor),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onBackground.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (status == InternetConnectionStatus.disconnected)
                  const SizedBox(height: 20),
                if (status == InternetConnectionStatus.disconnected)
                  ElevatedButton(
                    onPressed: () {
                      ref.read(internetConnectionProvider.notifier).checkNow();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text("Coba Lagi"),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}