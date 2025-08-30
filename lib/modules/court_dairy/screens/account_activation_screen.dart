import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_footer.dart';
import '../controllers/account_activation_controller.dart';

class AccountActivationScreen extends StatelessWidget {
  AccountActivationScreen({super.key});

  final controller = Get.put(AccountActivationController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: cs.surface,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: cs.surface,
        body: SafeArea(
          child: Column(
            children: [
              // Close button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Icon(Icons.close, color: cs.onSurfaceVariant),
                    ),
                  ),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Court Diary একাউন্ট অ্যাক্টিভেশন',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),

              // Features List
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    child: ListView(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.all(12),
                      children: const [
                        FeatureRow(text: 'মোকদ্দমা তালিকা ও ব্যবস্থাপনা'),
                        FeatureRow(text: 'শুনানির তারিখ রিমাইন্ডার'),
                        FeatureRow(text: 'ক্লায়েন্ট ও প্রতিপক্ষ তথ্য সংরক্ষণ'),
                        FeatureRow(text: 'কোর্ট ফি ও খরচ হিসাব'),
                        FeatureRow(text: 'ডকুমেন্ট ও প্রমাণ সংযুক্তি'),
                        FeatureRow(text: 'দৈনিক অগ্রগতির রিপোর্ট'),
                        FeatureRow(text: 'ক্যালেন্ডার সিঙ্ক ও নোটিফিকেশন'),
                        FeatureRow(text: 'কেস সার্চ ও ফিল্টার অপশন'),
                        FeatureRow(text: 'অফলাইনে তথ্য ব্যবহারের সুবিধা'),
                        FeatureRow(text: 'নিরাপদ ক্লাউড ব্যাকআপ'),
                        FeatureRow(text: 'বহু-ব্যবহারকারী পারমিশন নিয়ন্ত্রণ'),
                        FeatureRow(text: 'টাস্ক ও রিমাইন্ডার ম্যানেজার'),
                        FeatureRow(text: 'কেস আপডেট শেয়ারিং'),
                        FeatureRow(text: 'ডেটা এক্সপোর্ট ও প্রিন্টিং'),
                        FeatureRow(text: 'ক্লায়েন্ট পেমেন্ট ট্র্যাকিং'),
                      ],
                    ),
                  ),
                ),
              ),

              // Info Text
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Court Diary একাউন্ট অ্যাক্টিভেশন চার্জ বছরে মাত্র ${controller.activationPrice.toInt()}৳। অ্যাকাউন্ট সক্রিয় করতে নিচের বাটনে ক্লিক করুন।',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    color: cs.onSurface,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Button & Footer
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppButton(
                      label: 'পেমেন্ট করুন',
                      onPressed: () => controller.activateAccount(context),
                    ),
                    const SizedBox(height: 12),
                    const AppFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureRow extends StatelessWidget {
  final String text;

  const FeatureRow({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: cs.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, size: 14, color: cs.onPrimary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    height: 1.4,
                    color: cs.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
