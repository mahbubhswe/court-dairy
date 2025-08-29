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
                  'Seba POS একাউন্ট অ্যাক্টিভেশন',
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
                        FeatureRow(text: 'ক্রেতা ও বিক্রেতা ব্যবস্থাপনা'),
                        FeatureRow(text: 'পণ্য ও স্টক ম্যানেজমেন্ট'),
                        FeatureRow(text: 'স্টাফ ও কর্মচারী হিসাব'),
                        FeatureRow(text: 'দৈনিক খরচ ও আয়ের হিসাব'),
                        FeatureRow(text: 'বিক্রয় ও ইনভয়েসিং সিস্টেম'),
                        FeatureRow(text: 'রিপোর্ট ডাউনলোড ও বিশ্লেষণ'),
                        FeatureRow(text: 'কিস্তি এবং বাকি হিসাব রাখুন'),
                        FeatureRow(text: 'অ্যাডভান্স কাস্টমার সাপোর্ট'),
                        FeatureRow(text: 'যেকোনো সময় বাতিলের সুবিধা'),
                        FeatureRow(text: 'মাল্টি-ব্যাংক পেমেন্ট ইন্টিগ্রেশন'),
                        FeatureRow(text: 'বাহির থেকে রিমোট এক্সেস সুবিধা'),
                        FeatureRow(text: 'রিয়েল-টাইম স্টক আপডেট'),
                        FeatureRow(text: 'বিল প্রিন্ট ও কাস্টমাইজেশন'),
                        FeatureRow(text: 'মাল্টি-ইউজার লগইন এবং পারমিশন'),
                        FeatureRow(text: 'ডেটা ব্যাকআপ ও রিস্টোর অপশন'),
                        FeatureRow(text: 'বিক্রয় প্রবণতা বিশ্লেষণ এবং চার্ট'),
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
                  'Seba POS একাউন্ট অ্যাক্টিভেশন চার্জ বছরে মাত্র ${controller.activationPrice.toInt()}৳। একাউন্ট একটিভ করতে নিচের বাটনে ক্লিক করুন।',
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
