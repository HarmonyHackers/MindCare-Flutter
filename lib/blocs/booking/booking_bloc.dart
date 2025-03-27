import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_care/blocs/booking/booking_event.dart';
import 'package:mind_care/blocs/booking/booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  BookingBloc() : super(BookingState()) {
    on<SelectDateEvent>((event, emit) {
      emit(state.copyWith(selectedDate: event.selectedDate));
    });

    on<SelectTimeEvent>((event, emit) {
      emit(state.copyWith(selectedTime: event.selectedTime));
    });

    on<SubmitBookingEvent>((event, emit) async {
      // Validate date and time selection
      if (state.selectedDate == null || state.selectedTime == null) {
        emit(state.copyWith(errorMessage: 'Please select date and time'));
        return;
      }

      try {
        emit(state.copyWith(isLoading: true));

        // Get current user
        final User? currentUser = _auth.currentUser;
        if (currentUser == null) {
          emit(state.copyWith(
            errorMessage: 'User not authenticated',
            isLoading: false,
          ));
          return;
        }

        // Create booking document
        await _firestore.collection('bookings').add({
          'expertName': 'Dr. Uroos Fatima',
          'expertSpecialty': 'Psychiatrist',
          'userId': currentUser.uid,
          'userName': currentUser.displayName ?? 'Unknown User',
          'userEmail': currentUser.email,
          'date': state.selectedDate,
          'time': state.selectedTime,
          'consultationFee': 2000.00,
          'status': 'Pending',
          'createdAt': FieldValue.serverTimestamp(),
        });

        emit(state.copyWith(
          isLoading: false,
          isBooked: true,
          errorMessage: null,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Booking failed: ${e.toString()}',
        ));
      }
    });
  }
}
