import 'package:mind_care/blocs/booking_history/booking_history_event.dart';

class CancelBookingEvent extends BookingHistoryEvent {
  final String bookingId;
  CancelBookingEvent(this.bookingId);
}
