import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_texts.dart';

class CustomerServiceScreen extends StatelessWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexts.customerService),
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            // Contact first
            _Header(text: 'Contact'),
            Column(
              spacing: 5,
              children: [
                _ContactTile(
                  icon: Icons.mail_outline,
                  title: 'ইমেইল',
                  subtitle: 'support@sebapos.app',
                ),
                _ContactTile(
                  icon: Icons.call_outlined,
                  title: 'হেল্পলাইন',
                  subtitle: '+880623131102',
                ),
                _ContactTile(
                  icon: Icons.forum_outlined,
                  title: 'মেসেঞ্জার',
                  subtitle: 'facebook.com/sebapos',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Features list
            _Header(text: 'অ্যাপের ফিচারসমূহ'),
            _FeatureList(items: const [
              'পার্টি ম্যানেজমেন্ট: কাস্টমার/সাপ্লায়ার যোগ, এডিট, প্রোফাইল',
              'লেজার: বিক্রি/ক্রয়, পরিশোধ/জমা ট্র্যাকিং',
              'স্টক ও প্রোডাক্ট: ব্যাচ, স্টক ইন/আউট, দামের হিসাব',
              'কর্মচারী: স্যালারি এন্ট্রি, এডিট, রিপোর্ট',
              'হিসাব/লেনদেন: খরচ/বিনিয়োগ/স্থানান্তর/উত্তোলন',
              'PDF/রিপোর্ট: ট্রানজ্যাকশন এক্সপোর্ট, শেয়ার',
              'এসএমএস: ব্যালেন্স, বাল্ক ক্রয়',
              'অ্যাকাউন্ট রিসেট: ডাটা ক্লিনআপ (আইডেন্টিটি সংরক্ষণ)',
              'ডার্ক/লাইট থিম',
              'কাস্টমার সাপোর্ট',
            ]),

            const SizedBox(height: 16),

            // FAQs
            _Header(text: 'FAQs'),
            _FaqItem(
              question: 'কিভাবে নতুন পার্টি যোগ করবো?',
              answer:
                  'পার্টি ট্যাব থেকে “নতুন গ্রাহক” বাটনে চাপুন এবং তথ্য পূরণ করে সেভ করুন।',
            ),
            _FaqItem(
              question: 'ডাটা ব্যাকআপ কীভাবে কাজ করে?',
              answer:
                  'আপনার ডাটা ক্লাউডে সেভ থাকে। ইন্টারনেট থাকলে স্বয়ংক্রিয়ভাবে সিঙ্ক হয়।',
            ),
            _FaqItem(
              question: 'অ্যাকাউন্ট রিসেট করলে কী হয়?',
              answer:
                  'লেনদেন, পার্টি লেজার, ইনভয়েস ইত্যাদি মুছে যায়। শপের পরিচয় তথ্য থাকে।',
            ),
            _FaqItem(
              question: 'স্টক ইন/আউট কোথা থেকে করবো?',
              answer:
                  'স্টক ট্যাব থেকে প্রোডাক্টে ঢুকে “চালান”/ব্যাচ ম্যানেজ করুন।',
            ),
            _FaqItem(
              question: 'কর্মচারীর স্যালারি এডিট/ডিলিট কিভাবে?',
              answer:
                  'কর্মচারী ট্যাব → ট্রানজ্যাকশন লিস্টে তিন-ডট মেনু থেকে Edit/Delete।',
            ),
            _FaqItem(
              question: 'হিসাবে ট্রানজ্যাকশন PDF কিভাবে ডাউনলোড/শেয়ার করবো?',
              answer:
                  'All Transactions স্ক্রিনে উপরের ডাউনলোড আইকনে চাপুন, PDF শেয়ার করুন।',
            ),
            _FaqItem(
              question: 'এসএমএস ব্যালেন্স কোথায় দেখবো/কীভাবে কিনবো?',
              answer:
                  'ড্রয়ার → “এসএমএস ব্যালেন্স” টাইল থেকে ব্যালেন্স ও ক্রয় অপশন।',
            ),
            _FaqItem(
              question: 'ডার্ক/লাইট থিম কিভাবে বদলাবো?',
              answer: 'ড্রয়ার → “থিম পরিবর্তন” টাইল থেকে পরিবর্তন করুন।',
            ),
            _FaqItem(
              question: 'গ্রাহক সেবার সাথে কীভাবে যোগাযোগ করবো?',
              answer:
                  'উপরে Contact সেকশনে দেওয়া ইমেইল/হটলাইন/মেসেঞ্জার ব্যবহার করুন।',
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String text;
  const _Header({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        border: Border.all(color: cs.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        title: Text(question),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _ContactTile(
      {required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant),
      ),
      leading: CircleAvatar(
        backgroundColor: cs.primary.withOpacity(0.12),
        child: Icon(icon, color: cs.primary),
      ),
      title: Text(title),
      subtitle: Text(subtitle,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: cs.onSurfaceVariant)),
    );
  }
}

class _FeatureList extends StatelessWidget {
  final List<String> items;
  const _FeatureList({required this.items});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: cs.outlineVariant),
        itemBuilder: (context, i) => ListTile(
          leading: Icon(Icons.check_circle_outline, color: cs.primary),
          title: Text(items[i]),
        ),
      ),
    );
  }
}
