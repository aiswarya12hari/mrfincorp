

import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Collections/presentation/widgets%20success%20page/amount_collected_card.dart';
import 'package:mr_fincorp/FEATURES/Collections/presentation/widgets%20success%20page/collection_back_button.dart';
import 'package:mr_fincorp/FEATURES/Collections/presentation/widgets%20success%20page/success_badge.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';

class CollectionSuccessPage extends StatelessWidget {
  final double amountCollected;

  const CollectionSuccessPage({super.key, required this.amountCollected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const CollectionSuccessBadge(),
                      const SizedBox(height: 24),
                      Text(
                        'Collection Successful',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headline(context).copyWith(fontSize: 22),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'The payment has been recorded and\nupdated in the system.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.subheading(context),
                      ),
                      const SizedBox(height: 28),
                      AmountCollectedCard(amount: amountCollected),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CollectionBackButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }
}