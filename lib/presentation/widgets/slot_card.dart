import 'package:flutter/material.dart';
import '../../domain/entities/slot_status.dart';
import '../../domain/entities/slot_with_booking.dart';

/// Card widget for displaying a parking slot with its booking status
class SlotCard extends StatelessWidget {
  final SlotWithBooking slotWithBooking;
  final VoidCallback onTap;
  
  const SlotCard({
    super.key,
    required this.slotWithBooking,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final slot = slotWithBooking.slot;
    final status = slotWithBooking.status;
    final color = _getColorForStatus(status);
    
    return Card(
      elevation: 2,
      color: color.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: color,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconForStatus(status),
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                slot.slotNumber,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'F${slot.floor} W${slot.wing}',
                style: TextStyle(
                  fontSize: 10,
                  color: color.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status.displayName,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getColorForStatus(SlotStatus status) {
    switch (status) {
      case SlotStatus.available:
        return Colors.green;
      case SlotStatus.reserved:
        return Colors.orange;
      case SlotStatus.occupied:
        return Colors.red;
    }
  }
  
  IconData _getIconForStatus(SlotStatus status) {
    switch (status) {
      case SlotStatus.available:
        return Icons.check_circle;
      case SlotStatus.reserved:
        return Icons.bookmark;
      case SlotStatus.occupied:
        return Icons.local_parking;
    }
  }
}
