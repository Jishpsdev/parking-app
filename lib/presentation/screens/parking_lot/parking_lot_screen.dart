import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/parking_lot.dart';
import '../../../domain/entities/slot_with_booking.dart';
import '../../../domain/entities/vehicle_type.dart';
import '../../bloc/slot/slot_bloc.dart';
import '../../bloc/slot/slot_event.dart';
import '../../bloc/slot/slot_state.dart';
import '../../widgets/slot_grid_view.dart';

/// Screen displaying parking lot details and slots
class ParkingLotScreen extends StatefulWidget {
  final ParkingLot parkingLot;
  
  const ParkingLotScreen({
    super.key,
    required this.parkingLot,
  });
  
  @override
  State<ParkingLotScreen> createState() => _ParkingLotScreenState();
}

class _ParkingLotScreenState extends State<ParkingLotScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _lastUpdateTime;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Listen to action messages separately from slot data
    _listenToActionMessages();
  }
  
  void _listenToActionMessages() {
    final slotBloc = context.read<SlotBloc>();
    slotBloc.actionMessages.listen((actionMessage) {
      if (!mounted) return;
      
      if (actionMessage.status == SlotActionStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(actionMessage.message),
            backgroundColor: Colors.green,
          ),
        );
      } else if (actionMessage.status == SlotActionStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(actionMessage.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SlotBloc>()
        ..add(WatchSlotsEvent(widget.parkingLot.id)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.parkingLot.name),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '🚗 Cars'),
              Tab(text: '🏍️ Bikes'),
            ],
          ),
        ),
        body: BlocBuilder<SlotBloc, SlotState>(
          builder: (context, state) {
            if (state is SlotLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            if (state is SlotError) {
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
                  ],
                ),
              );
            }
            
            // Only SlotLoaded carries slots - action feedback is separate
            if (state is SlotLoaded) {
              _lastUpdateTime = DateTime.now();
            }
            
            final slots = state is SlotLoaded ? state.slots : <SlotWithBooking>[];

            final carSlots = slots
                .where((slotWithBooking) => slotWithBooking.slot.type == VehicleType.car)
                .toList();

            final bikeSlots = slots
                .where((slotWithBooking) => slotWithBooking.slot.type == VehicleType.bike)
                .toList();

            
            return Column(
              children: [
                _buildInfoBar(carSlots, bikeSlots),
                if (_lastUpdateTime != null) _buildRealtimeIndicator(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SlotGridView(
                        slots: carSlots,
                        parkingLotId: widget.parkingLot.id,
                      ),
                      SlotGridView(
                        slots: bikeSlots,
                        parkingLotId: widget.parkingLot.id,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildInfoBar(List<SlotWithBooking> carSlots, List<SlotWithBooking> bikeSlots) {
    final availableCars = carSlots.where((s) => s.canBeReserved()).length;
    final availableBikes = bikeSlots.where((s) => s.canBeReserved()).length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: _buildStatusChip(
              'Available',
              availableCars + availableBikes,
              Colors.green,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatusChip(
              'Reserved',
              carSlots.where((s) => s.status.isReserved).length +
                  bikeSlots.where((s) => s.status.isReserved).length,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatusChip(
              'Occupied',
              carSlots.where((s) => s.status.isOccupied).length +
                  bikeSlots.where((s) => s.status.isOccupied).length,
              Colors.red,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatusChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRealtimeIndicator() {
    final now = DateTime.now();
    final diff = now.difference(_lastUpdateTime!);
    String timeText;
    
    if (diff.inSeconds < 5) {
      timeText = 'Just now';
    } else if (diff.inSeconds < 60) {
      timeText = '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      timeText = '${diff.inMinutes}m ago';
    } else {
      timeText = '${diff.inHours}h ago';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.green[50],
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Live updates • Updated $timeText',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.sync,
            size: 16,
            color: Colors.green[700],
          ),
        ],
      ),
    );
  }
}
