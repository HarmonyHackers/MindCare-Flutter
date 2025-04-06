import 'package:mind_care/models/booking_model.dart';

abstract class BookingHistoryState {}

class BookingHistoryInitial extends BookingHistoryState {}

class BookingHistoryLoading extends BookingHistoryState {}

class BookingHistoryLoaded extends BookingHistoryState {
  final List<BookingModel> bookings;

  BookingHistoryLoaded(this.bookings);
}

class BookingHistoryError extends BookingHistoryState {
  final String message;

  BookingHistoryError(this.message);
}
