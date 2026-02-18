import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/pwa_service.dart';
import '../../../domain/entities/vehicle_type.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/parking_lot/parking_lot_bloc.dart';
import '../../bloc/parking_lot/parking_lot_event.dart';
import '../../bloc/parking_lot/parking_lot_state.dart';
import '../../widgets/pwa_install_prompt.dart';
import '../parking_lot/parking_lot_screen.dart';

/// Home screen displaying list of parking lots
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ParkingLotBloc>()
        ..add(const LoadParkingLotsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Parking System'),
          elevation: 2,
          actions: [
            if (kDebugMode) ...[
              IconButton(
                icon: const Icon(Icons.get_app),
                tooltip: 'Test PWA Install',
                onPressed: () {
                  if (kDebugMode) {
                    print('🧪 Test PWA install button clicked');
                  }
                  // Manually trigger install prompt UI for testing
                  sl<PWAService>().debugTriggerInstallPrompt();
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications_active),
                tooltip: 'Test Notification',
                onPressed: () {
                  if (kDebugMode) {
                    print('🧪 Test notification button clicked');
                  }
                  
                  // Manually trigger a test notification
                  final testMessage = RemoteMessage(
                    notification: const RemoteNotification(
                      title: '🔔 Test Notification',
                      body: 'If you can see this, notifications are working correctly!',
                    ),
                    data: {'test': 'true', 'timestamp': '${DateTime.now().millisecondsSinceEpoch}'},
                    messageId: 'test-${DateTime.now().millisecondsSinceEpoch}',
                  );
                  
                  // Trigger test notification
                  sl<NotificationService>().debugTriggerNotification(testMessage);
                },
              ),
            ],
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          context.read<AuthBloc>().add(const LogoutEvent());
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ParkingLotBloc, ParkingLotState>(
          builder: (context, state) {
            if (state is ParkingLotLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            if (state is ParkingLotError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ParkingLotBloc>().add(
                              const LoadParkingLotsEvent(),
                            );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            if (state is ParkingLotLoaded) {
              final parkingLots = state.parkingLots;
              
              if (parkingLots.isEmpty) {
                return const Center(
                  child: Text('No parking lots available'),
                );
              }
              
              return Column(
                children: [
                  // PWA Install Prompt (web only) - reactive to installability changes
                  if (kIsWeb)
                    ValueListenableBuilder<bool>(
                      valueListenable: sl<PWAService>().isInstallableListenable,
                      builder: (context, isInstallable, child) {
                        final isInstalled = sl<PWAService>().isInstalled;
                        if (isInstallable && !isInstalled) {
                          return const PWAInstallPrompt();
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  
                  // Parking Lots List
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<ParkingLotBloc>().add(
                              const LoadParkingLotsEvent(),
                            );
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: parkingLots.length,
                        itemBuilder: (context, index) {
                          final lot = parkingLots[index];
                    
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () {
                          context.read<ParkingLotBloc>().add(
                                SelectParkingLotEvent(lot.id),
                              );
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ParkingLotScreen(
                                parkingLot: lot,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.local_parking,
                                    size: 32,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lot.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          lot.address,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right),
                                ],
                              ),
                              const Divider(height: 24),
                              Row(
                                children: [
                                  _buildSlotInfo(
                                    '🚗 Cars',
                                    lot.getAvailableCountByType(
                                      VehicleType.car,
                                    ),
                                    lot.getTotalSlotsByType(VehicleType.car),
                                  ),
                                  const SizedBox(width: 24),
                                  _buildSlotInfo(
                                    '🏍️ Bikes',
                                    lot.getAvailableCountByType(
                                      VehicleType.bike,
                                    ),
                                    lot.getTotalSlotsByType(VehicleType.bike),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
            
            return const Center(
              child: Text('Unknown state'),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildSlotInfo(String label, int available, int total) {
    final percentage = total > 0 ? (available / total) : 0.0;
    final color = percentage > 0.5
        ? Colors.green
        : percentage > 0.2
            ? Colors.orange
            : Colors.red;
    
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$available / $total available',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
