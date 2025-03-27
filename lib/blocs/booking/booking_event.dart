abstract class BookingEvent {}

class SelectDateEvent extends BookingEvent {
  final DateTime selectedDate;
  SelectDateEvent(this.selectedDate);
}

class SelectTimeEvent extends BookingEvent {
  final String selectedTime;
  SelectTimeEvent(this.selectedTime);
}

class SubmitBookingEvent extends BookingEvent {}
