import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_care/blocs/booking_history/booking_history_bloc.dart';
import 'package:mind_care/blocs/booking_history/booking_history_event.dart';
import 'package:mind_care/screens/splash/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'config/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(AuthInitialize()),
        ),
        BlocProvider<BookingHistoryBloc>(
          create: (context) =>
              BookingHistoryBloc()..add(FetchBookingHistoryEvent()),
        ),
      ],
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            title: 'Mind Care',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
