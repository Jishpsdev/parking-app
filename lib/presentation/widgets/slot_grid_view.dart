import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/slot_with_booking.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_type.dart';
import '../../domain/usecases/get_user_by_id_usecase.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/slot/slot_bloc.dart';
import '../bloc/slot/slot_event.dart';
import 'slot_card.dart';

/// Grid view displaying parking slots with their bookings
class SlotGridView extends StatelessWidget {
  final List<SlotWithBooking> slots;
  final String parkingLotId;
  
  const SlotGridView({
    super.key,
    required this.slots,
    required this.parkingLotId,
  });
  
  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return const Center(
        child: Text('No slots available'),
      );
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slotWithBooking = slots[index];
        
        return SlotCard(
          slotWithBooking: slotWithBooking,
          onTap: () => _handleSlotTap(context, slotWithBooking),
        );
      },
    );
  }
  
  void _handleSlotTap(BuildContext context, SlotWithBooking slotWithBooking) async {
    final slot = slotWithBooking.slot;
    final booking = slotWithBooking.booking;
    
    // Get current user from AuthBloc
    final authState = context.read<AuthBloc>().state;
    
    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to interact with slots'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final user = authState.user;
    final userId = user.id;
    final isAdmin = user.userType == UserType.admin;
    
    // Admin users can reserve, regular users cannot
    final canReserve = isAdmin;
    
    // Fetch occupied user info if slot is booked by someone
    User? occupiedUser;
    if (booking != null && booking.userId != userId) {
      final getUserByIdUseCase = sl<GetUserByIdUseCase>();
      final result = await getUserByIdUseCase(booking.userId);
      result.fold(
        (failure) => null,
        (fetchedUser) => occupiedUser = fetchedUser,
      );
    }
    
    if (!context.mounted) return;
    
    // Capture the SlotBloc reference before opening modal
    final slotBloc = context.read<SlotBloc>();
    
    showModalBottomSheet(
      context: context,
      builder: (modalContext) {
        return Container(
          padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Slot ${slot.slotNumber}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  slot.locationDisplay,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Status: ${slotWithBooking.status.displayName}',
                  style: const TextStyle(fontSize: 16),
                ),
                // Show user info if occupied and not by current user
                if (occupiedUser != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, size: 20, color: Colors.grey[700]),
                            const SizedBox(width: 8),
                            Text(
                              'Occupied by',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          occupiedUser!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              occupiedUser!.userType == UserType.admin 
                                ? Icons.admin_panel_settings 
                                : Icons.person_outline,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              occupiedUser!.userType.name.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              // Reserve button - Only for admin on available slots
              if (slotWithBooking.canBeReserved() && canReserve)
                ElevatedButton.icon(
                  onPressed: () {
                    slotBloc.add(
                      ReserveSlotEvent(
                        parkingLotId: parkingLotId,
                        slotId: slot.id,
                        userId: userId,
                      ),
                    );
                    Navigator.pop(modalContext);
                  },
                  icon: const Icon(Icons.bookmark),
                  label: const Text('Reserve Slot'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              // Occupy button - Available for all users who reserved the slot
              if (slotWithBooking.canBeOccupied(userId) && booking != null)
                ElevatedButton.icon(
                  onPressed: () {
                    slotBloc.add(
                      OccupySlotEvent(bookingId: booking.id),
                    );
                    Navigator.pop(modalContext);
                  },
                  icon: const Icon(Icons.local_parking),
                  label: const Text('Occupy Slot'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              // Release button - Available for users who occupied the slot
              if (slotWithBooking.canBeReleased(userId) && booking != null)
                ElevatedButton.icon(
                  onPressed: () {
                    slotBloc.add(
                      ReleaseSlotEvent(
                        bookingId: booking.id,
                        userId: userId,
                      ),
                    );
                    Navigator.pop(modalContext);
                  },
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text('Release Slot'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              // Show message when no actions available
              if (!slotWithBooking.canBeReserved() &&
                  !slotWithBooking.canBeOccupied(userId) &&
                  !slotWithBooking.canBeReleased(userId) &&
                  occupiedUser == null)
                const Text(
                  'This slot is not available',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
