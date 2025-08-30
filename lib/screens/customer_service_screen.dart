import 'package:flutter/material.dart';
import 'package:courtdiary/widgets/company_info.dart';

class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        title: const Text('Customer Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Section
            Text(
              'Contact',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text('Email: support@appseba.com'),
            const Text('Phone: +8801XXXXXXXXX'),
            const SizedBox(height: 24),
            // How to Use Section
            Text(
              'How to Use',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text('1. Open the app and navigate to your desired section.'),
            const Text('2. Fill in required details and press submit.'),
            const Text('3. Review results and save if necessary.'),
            const SizedBox(height: 24),
            // FAQs Section
            Text(
              'FAQs',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            _buildFaq(
              question: 'How do I reset my password?',
              answer: 'Use the "Forgot Password" option on the login screen.',
            ),
            _buildFaq(
              question: 'Can I export my data?',
              answer: 'Yes, navigate to settings and choose export data.',
            ),
            const SizedBox(height: 24),
            const Center(child: CompanyInfo()),
          ],
        ),
      ),
    );
  }

  Widget _buildFaq({required String question, required String answer}) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(question),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(answer),
          ),
        ),
      ],
    );
  }
}
