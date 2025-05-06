import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trucklogix/firebase_options.dart';
import 'screens/dashboard_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/timecard_screen.dart';
import 'screens/tickets_screen.dart';
import 'features/tickets/screens/ticket_details_screen.dart';
import 'features/tickets/screens/ticket_form_screen.dart';
import 'package:intl/intl.dart';
import 'firebase_options.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TruckLogix',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF15385E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF15385E),
          primary: const Color(0xFF15385E),
        ),
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/timecard': (context) => const TimecardScreen(),
        '/tickets': (context) => const TicketsScreen(),
        '/ticket/new': (context) => const TicketFormScreen(),
        '/ticket/details': (context) {
          final String? ticketId =
              ModalRoute.of(context)?.settings.arguments as String?;
          if (ticketId != null) {
            return TicketDetailsScreen(ticketId: ticketId);
          }
          return const TicketsScreen();
        },
        // Placeholder routes for other features
        '/map': (context) =>
            const PlaceholderScreen(title: 'Map', icon: Icons.map),
        '/profile': (context) =>
            const PlaceholderScreen(title: 'Profile', icon: Icons.person),
      },
    );
  }
}

// A simple placeholder screen for features not yet implemented
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF15385E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: const Color(0xFF15385E),
            ),
            const SizedBox(height: 16),
            Text(
              '$title Feature',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF15385E),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This feature is coming soon!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF15385E),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
