import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Home/notification_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/login.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xFF6366F1),
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            fontFamily: 'Inter',
            textTheme: TextTheme(
              headlineSmall: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
              ),
              bodyLarge: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          home: ProfileScreen(),
        );
      },
    );
  }
}

class ProfileScreen extends StatelessWidget {
  Future<Map<String, String>> _getUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('user_info')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          return {
            'name': doc['first_name'] ?? 'User',
            'email': doc['email'] ?? user.email ?? 'No email',
            'phone': doc['phone_number'] ?? 'Not set'
          };
        }
      } catch (e) {
        debugPrint("Error fetching user info: $e");
      }
    }
    return {
      'name': 'User',
      'email': user?.email ?? 'No email',
      'phone': 'Not set'
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8.r,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Profile',
                      style: Theme.of(context).textTheme.headlineSmall),
                  IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.w),
              child: FutureBuilder<Map<String, String>>(
                future: _getUserInfo(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final userInfo = snapshot.data ?? {
                    'name': 'User',
                    'email': 'No email',
                    'phone': 'Not set'
                  };
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 2.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12.r,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 48.r,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              const AssetImage('assets/images/dr4.png'),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(userInfo['name']!,
                          style: Theme.of(context).textTheme.headlineSmall),
                      SizedBox(height: 2.h),
                      Text(userInfo['email']!,
                          style: Theme.of(context).textTheme.bodyLarge),
                      SizedBox(height: 2.h),
                      Text(userInfo['phone']!,
                          style: Theme.of(context).textTheme.bodyLarge),
                      SizedBox(height: 6.h),
                      OutlinedButton.icon(
                        icon: Icon(Icons.edit_outlined, size: 16.r),
                        label: Text('Edit Profile',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Theme.of(context).primaryColor,
                            )),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Theme.of(context).primaryColor),
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                currentName: userInfo['name']!,
                                currentEmail: userInfo['email']!,
                                currentPhone: userInfo['phone']!,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24.r))),
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  children: [
                    _buildSectionHeader('General'),
                    _buildListItem(
                      icon: FontAwesomeIcons.bank,
                      title: 'Bank Location',
                      subtitle: '7307 Grand Ave, Flushing NY 11347',
                      color: const Color(0xFF6366F1),
                      ontap: () {},
                    ),
                    _buildListItem(
                      icon: FontAwesomeIcons.wallet,
                      title: 'My Wallet',
                      subtitle: 'Manage your saved wallet',
                      color: const Color(0xFF10B981),
                      ontap: () {},
                    ),
                    _buildSectionHeader('Account'),
                    _buildListItem(
                      icon: FontAwesomeIcons.userGear,
                      title: 'Account Settings',
                      color: const Color(0xFF3B82F6),
                      ontap: () {},
                    ),
                    _buildListItem(
                        icon: FontAwesomeIcons.bell,
                        title: 'Notifications',
                        color: const Color(0xFFF59E0B),
                        ontap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NotificationsPage()),
                          );
                        }),
                    _buildListItem(
                        icon: FontAwesomeIcons.shieldHalved,
                        title: 'Privacy',
                        color: const Color(0xFF8B5CF6),
                        ontap: () {}),
                    _buildListItem(
                        icon: FontAwesomeIcons.circleInfo,
                        title: 'About',
                        color: const Color(0xFF64748B),
                        ontap: () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Text(title,
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
              letterSpacing: 1.2)),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color color,
    required VoidCallback ontap,
  }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(icon, size: 20.r, color: color),
      ),
      title: Text(title,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1E293B))),
      subtitle: subtitle != null
          ? Text(subtitle,
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF94A3B8)))
          : null,
      trailing: Icon(Icons.chevron_right_rounded,
          size: 20.r, color: const Color(0xFFCBD5E1)),
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      onTap: ontap,
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentPhone;

  const EditProfileScreen({
    required this.currentName,
    required this.currentEmail,
    required this.currentPhone,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _emailController = TextEditingController(text: widget.currentEmail);
    _phoneController = TextEditingController(text: widget.currentPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('user_info')
            .doc(user.uid)
            .update({
          'first_name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF6366F1),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: _updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}