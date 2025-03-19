import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        size: 20.r, color: const Color(0xFF64748B)),
                    onPressed: () {
                      //  Navigator.pop(context);
                    },
                  ),
                  Text('Profile',
                      style: Theme.of(context).textTheme.headlineSmall),
                  IconButton(
                    icon: Icon(Icons.settings_outlined,
                        size: 24.r, color: const Color(0xFF64748B)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Profile Section
            Container(
              padding: EdgeInsets.all(16.w),
              child: Column(
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
                        ]),
                    child: CircleAvatar(
                      radius: 48.r,
                      backgroundColor: Colors.white,
                      backgroundImage: const NetworkImage(
                        'https://i.pravatar.cc/300',
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text('Jacob Timberline',
                      style: Theme.of(context).textTheme.headlineSmall),
                  SizedBox(height: 2.h),
                  Text('jacobtimber@gmail.com',
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r)),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Content Sections
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
                    ),
                    _buildListItem(
                      icon: FontAwesomeIcons.wallet,
                      title: 'My Wallet',
                      subtitle: 'Manage your saved wallet',
                      color: const Color(0xFF10B981),
                    ),
                    _buildSectionHeader('Account'),
                    _buildListItem(
                      icon: FontAwesomeIcons.userGear,
                      title: 'Account Settings',
                      color: const Color(0xFF3B82F6),
                    ),
                    _buildListItem(
                      icon: FontAwesomeIcons.bell,
                      title: 'Notifications',
                      color: const Color(0xFFF59E0B),
                    ),
                    _buildListItem(
                      icon: FontAwesomeIcons.shieldHalved,
                      title: 'Privacy',
                      color: const Color(0xFF8B5CF6),
                    ),
                    _buildListItem(
                      icon: FontAwesomeIcons.circleInfo,
                      title: 'About',
                      color: const Color(0xFF64748B),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
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
    );
  }
}
