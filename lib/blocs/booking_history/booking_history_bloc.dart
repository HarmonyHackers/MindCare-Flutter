import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_care/blocs/booking_history/booking_history_event.dart';
import 'package:mind_care/blocs/booking_history/booking_history_state.dart';
import 'package:mind_care/blocs/booking_history/cancel_booking_event.dart';
import 'package:mind_care/models/booking_model.dart';

class BookingHistoryBloc
    extends Bloc<BookingHistoryEvent, BookingHistoryState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  BookingHistoryBloc() : super(BookingHistoryInitial()) {
    on<FetchBookingHistoryEvent>(_onFetchBookingHistory);
    on<CancelBookingEvent>(_onCancelBooking);
  }

  void _onFetchBookingHistory(
    FetchBookingHistoryEvent event,
    Emitter<BookingHistoryState> emit,
  ) async {
    try {
      emit(BookingHistoryLoading());

      //! Get current user
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        emit(BookingHistoryError('User not authenticated'));
        return;
      }

      //! Fetch bookings from Firestore
      final QuerySnapshot querySnapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      //! Convert to list of BookingModel
      final List<BookingModel> bookings = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return BookingModel(
          id: doc.id,
          expertName: data['expertName'] ?? '',
          expertSpecialty: data['expertSpecialty'] ?? '',
          userId: data['userId'] ?? '',
          userName: data['userName'] ?? '',
          userEmail: data['userEmail'] ?? '',
          date: (data['date'] as Timestamp).toDate(),
          time: data['time'] ?? '',
          consultationFee: (data['consultationFee'] ?? 0.0).toDouble(),
          status: data['status'] ?? 'Pending',
          createdAt: data['createdAt'] != null
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
        );
      }).toList();

      bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      emit(BookingHistoryLoaded(bookings));
    } catch (e) {
      emit(BookingHistoryError(e.toString()));
    }
  }

  void _onCancelBooking(
    CancelBookingEvent event,
    Emitter<BookingHistoryState> emit,
  ) async {
    try {
      //! Update the booking's status to "Cancelled" in Firestore
      await _firestore
          .collection('bookings')
          .doc(event.bookingId)
          .update({'status': 'Cancelled'});

      add(FetchBookingHistoryEvent());
    } catch (e) {
      emit(BookingHistoryError(e.toString()));
    }
  }
}
