import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/auth/controllers/auth_controller.dart';
import '../widgets/app_text_from_field.dart';

class AccountResetScreen extends StatelessWidget {
  const AccountResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    bool isValidGmail(String email) {
      return RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(email.trim());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Reset'),
        iconTheme: IconThemeData(color: cs.onPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'পাসওয়ার্ড রিসেট',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: const Text(
                'আপনার Gmail ঠিকানা দিন। আমরা একটি পাসওয়ার্ড রিসেট লিংক পাঠাবো। '
                'ইমেইল পাঠানোর পর Gmail অ্যাপ খুলে লিংকটি অনুসরণ করুন।',
              ),
            ),
            const SizedBox(height: 16),

            // Email field
            AppTextFromField(
              controller: controller.email,
              label: 'Email',
              hintText: 'yourname@gmail.com',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Email প্রয়োজন';
                if (!isValidGmail(v)) return 'শুধুমাত্র Gmail ঠিকানা দিন';
                return null;
              },
              onChanged: (_) {
                controller.error.value = '';
              },
            ),
            const SizedBox(height: 8),

            // Error message (if any)
            Obx(() {
              final err = controller.error.value;
              if (err.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  err,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              );
            }),

            // Actions
            Obx(() {
              final loading = controller.isLoading.value;
              final valid = isValidGmail(controller.email.text);
              return Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: (loading || !valid)
                          ? null
                          : () async {
                              await controller.forgotPassword();
                            },
                      icon: loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.lock_reset),
                      label: Text(loading
                          ? 'Sending...'
                          : (valid ? 'Send Reset Link' : 'Enter Gmail')),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: loading ? null : controller.openGmailApp,
                    icon: const Icon(Icons.email),
                    label: const Text('Open Gmail'),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
