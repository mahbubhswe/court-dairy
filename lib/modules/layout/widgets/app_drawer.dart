import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../../themes/theme_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../court_dairy/screens/buy_sms_screen.dart';
import '../../case/screens/add_case_screen.dart';
import '../../party/screens/add_party_screen.dart';
import '../../accounts/screens/add_transaction_screen.dart';
import '../../case/screens/all_case_screen.dart';
import '../../accounts/screens/all_transactions_screen.dart';
import '../../../screens/calculator_screen.dart';
import '../../../screens/customer_service_screen.dart';
import '../controllers/layout_controller.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final layoutController = Get.find<LayoutController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final cs = Theme.of(context).colorScheme;
    final navColor = cs.surface; // Match drawer background
    final navIconsBrightness =
        ThemeData.estimateBrightnessForColor(navColor) == Brightness.dark
            ? Brightness.light
            : Brightness.dark;
    return Drawer(
      width: width,
      backgroundColor: cs.surface,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: navColor,
          systemNavigationBarIconBrightness: navIconsBrightness,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
        child: Obx(() {
          final shop = layoutController.lawyer.value;
          final user = authController.user.value;

          if (shop == null || user == null) {
            return const Center(child: CupertinoActivityIndicator(radius: 15));
          }

          final now = DateTime.now();
          final subscriptionEnd = shop.subscriptionEndsAt;
          final daysLeft = subscriptionEnd.difference(now).inDays;

          final lastSignIn = user.metadata.lastSignInTime;
          final formattedSignIn = lastSignIn != null
              ? DateFormat('dd MMM yyyy, hh:mm a').format(lastSignIn)
              : 'অজানা';

          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button with rounded bg
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          CupertinoIcons.chevron_back,
                          size: 20,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Profile Info - Column layout with photo, name, email
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          backgroundImage: user.photoURL != null
                              ? CachedNetworkImageProvider(user.photoURL!)
                              : null,
                          child: user.photoURL == null
                              ? Text(
                                  shop.name.isNotEmpty
                                      ? shop.name[0].toUpperCase()
                                      : '?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                )
                              : null,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          user.displayName ?? shop.name,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user.email ?? shop.phone,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(CupertinoIcons.clock, size: 16),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'সর্বশেষ লগইন: $formattedSignIn',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // দ্রুত কার্যাবলী
                  _sectionHeader(context, 'দ্রুত কার্যাবলী'),
                  const SizedBox(height: 12),
                  _infoTile(
                    context,
                    icon: Icons.add_to_photos_rounded,
                    title: 'নতুন কেস',
                    subtitle: 'দ্রুত নতুন কেস যুক্ত করুন',
                    hasArrow: true,
                    onTap: () => Get.to(() => const AddCaseScreen(),
                        fullscreenDialog: true),
                  ),
                  _infoTile(
                    context,
                    icon: Icons.group_add_rounded,
                    title: 'নতুন পক্ষ',
                    subtitle: 'পক্ষ যুক্ত করুন',
                    hasArrow: true,
                    onTap: () => Get.to(() => const AddPartyScreen(),
                        fullscreenDialog: true),
                  ),
                  _infoTile(
                    context,
                    icon: Icons.attach_money_rounded,
                    title: 'নতুন লেনদেন',
                    subtitle: 'ব্যয়/আয় যোগ করুন',
                    hasArrow: true,
                    onTap: () => Get.to(() => const AddTransactionScreen(),
                        fullscreenDialog: true),
                  ),

                  const SizedBox(height: 24),

                  // নেভিগেশন
                  _sectionHeader(context, 'নেভিগেশন'),
                  const SizedBox(height: 12),
                  _infoTile(
                    context,
                    icon: Icons.folder_open_rounded,
                    title: 'সমস্ত কেস',
                    subtitle: 'আপনার সব কেস দেখুন',
                    hasArrow: true,
                    onTap: () => Get.to(() => AllCaseScreen()),
                  ),
                  _infoTile(
                    context,
                    icon: Icons.receipt_long_rounded,
                    title: 'সমস্ত লেনদেন',
                    subtitle: 'আয়/ব্যয় ইতিহাস',
                    hasArrow: true,
                    onTap: () => Get.to(() => AllTransactionsScreen()),
                  ),
                  _infoTile(
                    context,
                    icon: Icons.calculate_rounded,
                    title: 'ক্যালকুলেটর',
                    subtitle: 'সহজ হিসাব',
                    hasArrow: true,
                    onTap: () => Get.to(() => CalculatorScreen(),
                        fullscreenDialog: true),
                  ),
                  _infoTile(
                    context,
                    icon: Icons.support_agent_rounded,
                    title: 'কাস্টমার সার্ভিস',
                    subtitle: 'সাহায্য প্রয়োজন?',
                    hasArrow: true,
                    onTap: () => Get.to(() => const CustomerServiceScreen()),
                  ),

                  const SizedBox(height: 24),

                  // প্রোফাইল তথ্য Section
                  _sectionHeader(context, 'প্রোফাইল তথ্য'),
                  const SizedBox(height: 12),
                  _infoTile(
                    context,
                    icon: CupertinoIcons.home,
                    title: 'নাম',
                    subtitle: shop.name,
                  ),
                  _infoTile(
                    context,
                    icon: CupertinoIcons.location,
                    title: 'চেম্বারের ঠিকানা',
                    subtitle: shop.address,
                  ),
                  _infoTile(
                    context,
                    icon: CupertinoIcons.phone_fill,
                    title: 'ফোন নম্বর',
                    subtitle: shop.phone,
                  ),
                  _infoTile(
                    context,
                    icon: CupertinoIcons.chat_bubble_text_fill,
                    title: 'এসএমএস ব্যালেন্স',
                    subtitle: '${shop.smsBalance}',
                    hasArrow: true,
                    onTap: () {
                      Get.to(() => BuySmsView());
                    },
                  ),

                  const SizedBox(height: 36),

                  // সাবস্ক্রিপশন বিস্তারিত Section
                  _sectionHeader(context, 'সাবস্ক্রিপশন বিস্তারিত'),

                  const SizedBox(height: 8),
                  _infoTile(
                    context,
                    icon: Icons.brightness_6_rounded,
                    title: 'থিম পরিবর্তন',
                    subtitle: 'ডার্ক/লাইট মোড',
                    onTap: () => Get.find<ThemeController>().toggleTheme(),
                  ),
                  const SizedBox(height: 12),
                  _infoTile(
                    context,
                    icon: CupertinoIcons.calendar,
                    title: 'মেয়াদ',
                    subtitle: '${shop.subFor} দিন',
                  ),
                  _infoTile(
                    context,
                    icon: CupertinoIcons.clock_fill,
                    title: 'শুরু তারিখ',
                    subtitle:
                        DateFormat('dd MMM yyyy').format(shop.subStartsAt),
                  ),
                  _infoTile(
                    context,
                    icon: CupertinoIcons.timer,
                    title: 'শেষ তারিখ',
                    subtitle: DateFormat('dd MMM yyyy').format(subscriptionEnd),
                  ),
                  _infoTile(
                    context,
                    icon: CupertinoIcons.hourglass,
                    title: 'বাকি দিন',
                    subtitle: daysLeft > 0 ? '$daysLeft দিন বাকি' : 'মেয়াদ শেষ',
                    subtitleColor: daysLeft > 0
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                    isBold: true,
                  ),

                  const SizedBox(height: 36),

                  // Reset Section
                  _sectionHeader(context, 'রিসেট অপশন'),
                  const SizedBox(height: 12),
                  // Removed password reset from drawer as requested
                  _infoTile(
                    context,
                    icon: Icons.account_balance_wallet,
                    title: 'অ্যাকাউন্ট রিসেট',
                    subtitle: 'আপনার সম্পূর্ণ অ্যাকাউন্ট ডেটা রিসেট করুন',
                    onTap: () {},
                  ),

                  const SizedBox(height: 36),

                  // Logout (outlined, themed destructive style)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: Icon(
                        Icons.logout,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      label: Text(
                        'লগ আউট',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final confirm = await showCupertinoDialog<bool>(
                          context: context,
                          builder: (ctx) => CupertinoAlertDialog(
                            title: const Text('লগ আউট নিশ্চিত করুন'),
                            content:
                                const Text('আপনি কি সত্যিই লগ আউট করতে চান?'),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text('বাতিল'),
                                onPressed: () => Navigator.of(ctx).pop(false),
                              ),
                              CupertinoDialogAction(
                                isDestructiveAction: true,
                                child: const Text('লগ আউট'),
                                onPressed: () => Navigator.of(ctx).pop(true),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await authController.logout();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
    );
  }

  Widget _infoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Color? subtitleColor,
    bool isBold = false,
    bool hasArrow = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12), // Rounded rectangle bg
                border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: Icon(icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: subtitleColor,
                          fontWeight:
                              isBold ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                ],
              ),
            ),
            if (hasArrow)
              Icon(
                CupertinoIcons.chevron_forward,
                size: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          ],
        ),
      ),
    );
  }
}
