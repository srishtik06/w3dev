import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth import
import '../services/notification_service.dart';
import '../themes/app_theme.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final sheight = MediaQuery.of(context).size.height;
    final swidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: lightColorScheme.primary,
        elevation: 4,
        title: Center(
          child: Text(
            'Home Screen',
            style: GoogleFonts.poppins(
              fontSize: swidth * 0.05,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[300],
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 3, color: Colors.white),
            insets: EdgeInsets.symmetric(horizontal: 20),
          ),
          tabs: const [
            Tab(icon: Icon(Icons.home), text: "Home"),
            Tab(icon: Icon(Icons.person), text: "Profile"),
            Tab(icon: Icon(Icons.settings), text: "Settings"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          KeepAlivePage(child: _buildHomeTab(sheight, swidth)),
          KeepAlivePage(child: _buildProfileTab(sheight, swidth)), // Profile Tab
          KeepAlivePage(child: _buildSettingsTab(sheight, swidth)),
        ],
      ),
    );
  }

  Widget _buildHomeTab(double sheight, double swidth) {
    return Padding(
      padding: EdgeInsets.all(swidth * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dashboard, size: sheight * 0.12, color: lightColorScheme.primary),
          SizedBox(height: sheight * 0.02),
          Text(
            "Welcome to Home!",
            style: GoogleFonts.poppins(fontSize: swidth * 0.05, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: sheight * 0.01),
          Text(
            "This is a simple dashboard with modern UI.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: swidth * 0.04, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }


  Widget _buildProfileTab(double sheight, double swidth) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first, // Fetch user data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show loader while fetching data
        }
        final user = snapshot.data;

        return Padding(
          padding: EdgeInsets.all(swidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: sheight * 0.08,
                backgroundColor: lightColorScheme.primary.withOpacity(0.1),
                backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                child: user?.photoURL == null ? Icon(Icons.person, size: sheight * 0.1, color: lightColorScheme.primary) : null,
              ),
              SizedBox(height: sheight * 0.02),
              Text(
                user?.displayName ?? "Guest User", // Display name
                style: GoogleFonts.poppins(fontSize: swidth * 0.05, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: sheight * 0.01),
              Text(
                user?.email ?? "No Email Found", // Email
                style: GoogleFonts.poppins(fontSize: swidth * 0.04, color: Colors.grey[600]),
              ),
              SizedBox(height: sheight * 0.03),
              ElevatedButton(
                onPressed: () async {
                  await AuthService().signout(context: context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(horizontal: swidth * 0.2, vertical: sheight * 0.015),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Logout",
                  style: GoogleFonts.poppins(fontSize: swidth * 0.04, fontWeight: FontWeight.bold),
                ),
              ),

            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsTab(double sheight, double swidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: swidth * 0.05, vertical: sheight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Icon(Icons.settings, size: sheight * 0.12, color: lightColorScheme.primary),
                SizedBox(height: sheight * 0.02),
                Text(
                  "Settings & Notifications",
                  style: TextStyle(fontSize: swidth * 0.05, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: sheight * 0.02),
                Text("Manage your preferences here.",
                    textAlign: TextAlign.center, style: TextStyle(fontSize: swidth * 0.04, color: Colors.grey[600])),
                SizedBox(height: sheight * 0.03),
              ],
            ),
          ),

          SizedBox(height: sheight * 0.02),

          Center(
            child: ElevatedButton.icon(
              onPressed: () => NotificationService.showImmediateNotification(),
              icon: Icon(Icons.notifications_active),
              label: Text("Show Immediate Notification"),
              style: ElevatedButton.styleFrom(
                backgroundColor: lightColorScheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
          SizedBox(height: sheight * 0.02),

          // Schedule Notification Button
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                if (_notificationsEnabled) {
                  await NotificationService().scheduleNotification();
                }
              },
              icon: Icon(Icons.notifications_active, size: swidth * 0.05),
              label: Text("Schedule Notification", style: TextStyle(fontSize: swidth * 0.045)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: sheight * 0.015, horizontal: swidth * 0.05),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Ensures tab state retention using AutomaticKeepAliveClientMixin
class KeepAlivePage extends StatefulWidget {
  final Widget child;
  const KeepAlivePage({super.key, required this.child});

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Ensures state retention

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
