import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mind_care/blocs/booking_history/cancel_booking_event.dart';
import 'package:mind_care/config/colors.dart';
import 'package:mind_care/models/booking_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:mind_care/blocs/booking_history/booking_history_bloc.dart';
import 'package:mind_care/blocs/booking_history/booking_history_event.dart';
import 'package:mind_care/blocs/booking_history/booking_history_state.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  String _activeFilter = 'All';
  final List<String> _filters = ['All', 'Pending', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/images/take_help.png",
          height: 6.h,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: BlocProvider(
        create: (context) =>
            BookingHistoryBloc()..add(FetchBookingHistoryEvent()),
        child: BlocBuilder<BookingHistoryBloc, BookingHistoryState>(
          builder: (context, state) {
            if (state is BookingHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookingHistoryError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is BookingHistoryLoaded) {
              final filteredBookings = _activeFilter == 'All'
                  ? state.bookings
                  : state.bookings
                      .where((booking) => booking.status == _activeFilter)
                      .toList();

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Text(
                      'Booking History',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                    ),
                    SizedBox(height: 2.h),

                    //! Filters
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _filters
                            .map((filter) => _buildFilterChip(context, filter))
                            .toList(),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    //! Booking list
                    Expanded(
                      child: filteredBookings.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              itemCount: filteredBookings.length,
                              itemBuilder: (context, index) {
                                return _buildBookingCard(
                                    filteredBookings[index]);
                              },
                            ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String filter) {
    final isSelected = _activeFilter == filter;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeFilter = filter;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xff6885B8) : const Color(0xffCFDAED),
            borderRadius: BorderRadius.circular(20),
            border: const Border(
              left: BorderSide(color: AppColors.primary, width: 3),
              top: BorderSide(color: AppColors.primary, width: 3),
              right: BorderSide(color: AppColors.primary, width: 6),
              bottom: BorderSide(color: AppColors.primary, width: 6),
            ),
          ),
          child: Text(
            filter,
            style: GoogleFonts.kodchasan(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(BookingModel booking) {
    Color statusColor;

    switch (booking.status) {
      case 'Completed':
        statusColor = Colors.green;
        break;
      case 'Pending':
        statusColor = Colors.blue;
        break;
      case 'Cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 3, color: AppColors.primary),
        color: const Color(0xffF5F5F5),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xffCFDAED),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(width: 3, color: AppColors.primary),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.expertName,
                      style: GoogleFonts.kodchasan(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      booking.expertSpecialty,
                      style: GoogleFonts.kodchasan(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Text(
                    booking.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('EEE, MMM d').format(booking.date),
                      style: GoogleFonts.kodchasan(fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.watch_later_outlined,
                        color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      booking.time,
                      style: GoogleFonts.kodchasan(fontSize: 16),
                    ),
                  ],
                ),
                Text(
                  "${booking.consultationFee.toInt()} rs",
                  style: GoogleFonts.kodchasan(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          //! Cancel Booking button
          GestureDetector(
            onTap: () async {
              //! Confirmation dialog
              final shouldCancel = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Cancel Booking'),
                  content: const Text(
                      'Are you sure you want to cancel this booking?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
              if (shouldCancel == true) {
                //! Dispatch cancel booking event
                context
                    .read<BookingHistoryBloc>()
                    .add(CancelBookingEvent(booking.id));
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.cardRed,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border(
                  top: BorderSide(width: 3, color: AppColors.primary),
                ),
              ),
              child: Center(
                child: Text(
                  'Cancel Booking',
                  style: GoogleFonts.kodchasan(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 80,
            color: AppColors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No bookings found',
            style: GoogleFonts.kodchasan(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          if (_activeFilter != 'All')
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Try changing the filter',
                style: GoogleFonts.kodchasan(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
