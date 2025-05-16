import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stitchpal/services/notification_service.dart';
import 'package:stitchpal/screens/crochet_tools_screen.dart';
import 'package:stitchpal/screens/intro_screen.dart';
import 'package:stitchpal/screens/project_input_screen.dart';
import 'package:stitchpal/screens/saved_projects_screen.dart';
import 'package:stitchpal/services/project_service.dart';
import 'package:stitchpal/theme.dart';
import 'package:stitchpal/widgets/global_assistant_modal.dart';
import 'package:stitchpal/widgets/cute_stitch_pal_icon.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables before running the app
  try {
    await dotenv.load(fileName: ".env");
    if (dotenv.env['OPENAI_API_KEY'] != null && dotenv.env['OPENAI_API_KEY']!.isNotEmpty) {
      debugPrint('Environment variables loaded successfully');
    } else {
      debugPrint('Warning: OPENAI_API_KEY not found in .env file');
    }
  } catch (e) {
    // If .env file doesn't exist, continue without it
    debugPrint('Warning: .env file not found. Some features may not work properly.');
    debugPrint('Error details: $e');
  }
  
  // Initialize the project service
  ProjectService().initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'StitchPal',
      theme: StitchPalTheme.themeData,
      home: const IntroScreen(), // Start with the intro screen
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const ProjectInputScreen(),
    const SavedProjectsScreen(),
    const CrochetToolsScreen(),
  ];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const GlobalAssistantModal(),
          );
        },
        backgroundColor: Colors.white,
        child: const CuteStitchPalIcon(size: 40),
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            label: 'My Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman_outlined),
            label: 'Tools',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: StitchPalTheme.primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

// The MyHomePage widget has been replaced by ProjectInputScreen
