import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mind_care/blocs/booking/booking_bloc.dart';
import 'package:mind_care/blocs/booking/booking_event.dart';
import 'package:mind_care/blocs/booking/booking_state.dart';
import 'package:mind_care/config/colors.dart';
import 'package:mind_care/utils/custom_message_notifier.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ExpertBookingScreen extends StatefulWidget {
  const ExpertBookingScreen({super.key});

  @override
  _ExpertBookingScreenState createState() => _ExpertBookingScreenState();
}

class _ExpertBookingScreenState extends State<ExpertBookingScreen> {
  DateTime? _selectedDate;
  String? _selectedTime;

  final List<DateTime> _availableDates = List.generate(
    5,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  final List<String> _availableTimes = ['8:30', '9:30', '10:30'];

  void _showBookingConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Booking'),
          content: const Text(
              'Do you want to book a consultation with Dr. Uroos Fatima for 2000 rs?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(dialogContext).pop();

                // Trigger booking event
                context.read<BookingBloc>().add(SubmitBookingEvent());
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          "assets/images/take_help.png",
          height: 6.h,
        ),
      ),
      body: BlocProvider(
        create: (context) => BookingBloc(),
        child: BlocConsumer<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state.isBooked) {
              CustomMessageNotifier.showSnackBar(
                context,
                "Booking Successful! Consultation Fee: 2000 rs",
                onSuccess: true,
              );
              Navigator.of(context).pop();
            }
            if (state.errorMessage != null) {
              CustomMessageNotifier.showSnackBar(
                context,
                state.errorMessage!,
                onError: true,
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  //! Expert Card
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/expart_girl.png",
                        height: 20.h,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        height: 20.h,
                        width: 56.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(27),
                          border:
                              Border.all(width: 6, color: AppColors.primary),
                          color: AppColors.moodYellow,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dr. Uroos Fatima',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Psychiatrist',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'MBBS, MD',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                            const Spacer(),
                            const Divider(
                              color: AppColors.primary,
                              thickness: 5,
                            ),
                            Text(
                              '2000 rs',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  //! Date Selection
                  Text(
                    'Select Date',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 15),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _availableDates
                          .map((date) => _buildDateChip(context, date))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  //! Time Selection
                  Text(
                    'Select Time',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 15),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _availableTimes
                          .map((time) => _buildTimeChip(context, time))
                          .toList(),
                    ),
                  ),
                  const Spacer(),
                  //! Book Appointment Button
                  GestureDetector(
                    onTap: _selectedDate != null && _selectedTime != null
                        ? () {
                            //! Showing confirmation dialog before booking
                            _showBookingConfirmationDialog(context);
                          }
                        : null,
                    child: Container(
                      height: 8.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: const Color(0xff96D1BD),
                        border: const Border(
                          top: BorderSide(width: 5, color: AppColors.primary),
                          left: BorderSide(width: 5, color: AppColors.primary),
                          right:
                              BorderSide(width: 10, color: AppColors.primary),
                          bottom:
                              BorderSide(width: 10, color: AppColors.primary),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Book Appointment',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateChip(BuildContext context, DateTime date) {
    final formattedDate = DateFormat('EEE dd').format(date);
    final isSelected = _selectedDate == date;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDate = date;
          });
          context.read<BookingBloc>().add(SelectDateEvent(date));
        },
        child: Container(
          width: 20.w,
          height: 15.h,
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xff6885B8) : const Color(0xffCFDAED),
            borderRadius: BorderRadius.circular(20),
            border: const Border(
              left: BorderSide(
                color: AppColors.primary,
                width: 5,
              ),
              top: BorderSide(
                color: AppColors.primary,
                width: 5,
              ),
              right: BorderSide(
                color: AppColors.primary,
                width: 10,
              ),
              bottom: BorderSide(
                color: AppColors.primary,
                width: 10,
              ),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                formattedDate,
                textAlign: TextAlign.center,
                style: GoogleFonts.kodchasan(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeChip(BuildContext context, String time) {
    final isSelected = _selectedTime == time;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTime = time;
          });
          context.read<BookingBloc>().add(SelectTimeEvent(time));
        },
        child: Container(
          width: 35.w,
          height: 8.h,
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xff6885B8) : const Color(0xffCFDAED),
            borderRadius: BorderRadius.circular(35),
            border: const Border(
              left: BorderSide(
                color: AppColors.primary,
                width: 5,
              ),
              top: BorderSide(
                color: AppColors.primary,
                width: 5,
              ),
              right: BorderSide(
                color: AppColors.primary,
                width: 10,
              ),
              bottom: BorderSide(
                color: AppColors.primary,
                width: 10,
              ),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    time,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.kodchasan(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
