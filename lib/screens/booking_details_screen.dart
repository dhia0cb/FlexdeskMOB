import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/api_service.dart';
import '../../widgets/status_badge.dart';

class BookingDetailsScreen extends StatefulWidget {
  final Booking booking;

  const BookingDetailsScreen({super.key, required this.booking});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool _isCancelling = false;

  Future<void> _cancelBooking() async {
    setState(() {
      _isCancelling = true;
    });

    try {
      await ApiService().cancelBooking(widget.booking.id);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking cancelled successfully')),
      );

      Navigator.pop(context, true); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to cancel booking: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCancelling = false;
        });
      }
    }
  }

  void _confirmCancel() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Cancellation'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
              _cancelBooking(); 
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Booking Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text("Space Type"),
              subtitle: Text("${widget.booking.spaceType} ${widget.booking.space['name'] ?? widget.booking.id}"),
            ),
            ListTile(
              title: const Text("Time"),
              subtitle: Text("${widget.booking.startTime} - ${widget.booking.endTime}"),
            ),
            ListTile(
              title: const Text("Status"),
              subtitle: StatusBadge(status: widget.booking.status ?? "confirmed"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isCancelling ? null : _confirmCancel,
              icon: const Icon(Icons.cancel),
              label: _isCancelling
                  ? const Text("Cancelling...")
                  : const Text("Cancel Booking"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
