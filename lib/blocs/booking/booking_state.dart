class BookingState {
  final DateTime? selectedDate;
  final String? selectedTime;
  final bool isLoading;
  final bool isBooked;
  final String? errorMessage;

  BookingState({
    this.selectedDate,
    this.selectedTime,
    this.isLoading = false,
    this.isBooked = false,
    this.errorMessage,
  });

  BookingState copyWith({
    DateTime? selectedDate,
    String? selectedTime,
    bool? isLoading,
    bool? isBooked,
    String? errorMessage,
  }) {
    return BookingState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      isLoading: isLoading ?? this.isLoading,
      isBooked: isBooked ?? this.isBooked,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
