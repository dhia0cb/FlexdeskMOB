import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../screens/booking_details_screen.dart';
import '../services/api_service.dart'; 
import '../widgets/status_badge.dart'; 

class MyBookingsScreen extends StatefulWidget {
  final int userId;
  const MyBookingsScreen({super.key, required this.userId});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late Future<List<Booking>> _bookingsFuture;
  List<Booking>? _allBookings; 
  List<Booking>? _filteredBookings;

  DateTime? _startDate;
  DateTime? _endDate;

  bool _isCalendarView = false;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    _bookingsFuture = ApiService().fetchBookingsByUserId(widget.userId);
    final data = await _bookingsFuture;
    _allBookings = data;
    _filteredBookings = data;
    setState(() {});
  }

  void _filterBookings() {
    if (_allBookings == null) return;

    setState(() {
      _filteredBookings = _allBookings!.where((booking) {
        final bookingStart = DateTime.parse(booking.startTime);
        final bookingEnd = DateTime.parse(booking.endTime);

        bool afterStart = _startDate == null || bookingEnd.isAfter(_startDate!.subtract(const Duration(days: 1)));
        bool beforeEnd = _endDate == null || bookingStart.isBefore(_endDate!.add(const Duration(days: 1)));

        return afterStart && beforeEnd;
      }).toList();
    });
  }

  Future<void> _pickStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: _endDate ?? DateTime(2100),
    );
    if (date != null) {
      _startDate = date;
      _filterBookings();
    }
  }

  Future<void> _pickEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      _endDate = date;
      _filterBookings();
    }
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
      _filteredBookings = _allBookings;
    });
  }

  void _toggleView() {
    setState(() {
      _isCalendarView = !_isCalendarView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
        actions: [
          IconButton(
            icon: Icon(_isCalendarView ? Icons.view_list : Icons.calendar_today),
            onPressed: _toggleView,
            tooltip: _isCalendarView ? "List View" : "Calendar View",
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickStartDate,
                    child: Text(_startDate == null
                        ? "Start Date"
                        : _startDate!.toLocal().toString().split(' ')[0]),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickEndDate,
                    child: Text(_endDate == null
                        ? "End Date"
                        : _endDate!.toLocal().toString().split(' ')[0]),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: 'Clear Filters',
                  onPressed: _clearFilters,
                )
              ],
            ),
          ),

          if (_isCalendarView)
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.blue[50],
              child: const Text(
                " Calendar View Coming Soon",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

          Expanded(
            child: _filteredBookings == null
                ? const Center(child: CircularProgressIndicator())
                : _filteredBookings!.isEmpty
                    ? const Center(child: Text("No bookings found"))
                    : ListView.builder(
                        itemCount: _filteredBookings!.length,
                        itemBuilder: (context, index) {
                          final booking = _filteredBookings![index];
                          String status = booking.status ?? "confirmed";

                          return ListTile(
                            title: Text(
                                "${booking.spaceType} ${booking.space['name'] ?? booking.id}"),
                            subtitle: Text(
                                "${booking.startTime} - ${booking.endTime}"),
                            trailing: StatusBadge(status: status),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookingDetailsScreen(booking: booking),
                                ),
                              );

                              if (result == true) {
                                _loadBookings();
                              }
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
