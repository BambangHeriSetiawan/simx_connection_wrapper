// lib/ui/components/internet_status_overlay.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simx_connection_wrapper/internet_connection_notifier.dart';

class InternetStatusOverlay extends ConsumerWidget {
  const InternetStatusOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(internetConnectionProvider);

    if (status == InternetConnectionStatus.disconnected) {
      return Stack(
        children: [
          // Block interaction with a ModalBarrier
          ModalBarrier(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.8),
            dismissible: false,
          ),
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
                  Icon(
                    Icons.wifi_off,
                    size: 60,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Tidak Terhubung ke Internet",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Koneksi internet hilang. Harap periksa koneksi Anda.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 20),
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

    return const SizedBox.shrink();
  }
}
