import 'package:flutter/material.dart';
import '../../../../CORE/Theme/app_color.dart';
import 'package:mr_fincorp/FEATURES/Loans/presentation/pages/group_member_refresh_page.dart';

import '../../data/models/group_member_model.dart';
import '../../data/models/group_verify_response_model.dart';
import 'group_all_verified_success_page.dart';
import 'group_member_verification_page.dart';

class GroupMemberVerifySuccessPage extends StatelessWidget {
  final String loanId;
  final String verifiedMemberName;
  final GroupVerifyResponseModel response;

  const GroupMemberVerifySuccessPage({
    super.key,
    required this.loanId,
    required this.verifiedMemberName,
    required this.response,
  });

  void _goToMembers(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GroupMembersRefreshPage(loanId: loanId),
      ),
    );
  }

  void _verifyNextMember(BuildContext context) {
    if (response.unverifiedMembers.isEmpty) return;

    final next = response.unverifiedMembers.first;

    final nextMember = GroupMemberModel(
      customerId: next.customerId,
      name: next.name,
      customerCode: '',
      installmentAmount: '',
      isVerified: false,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            GroupMemberVerificationPage(loanId: loanId, member: nextMember),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allVerified = response.isFullyVerified;

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 60),

              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: AppColors.successBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 56,
                  color: AppColors.success,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Member Verified Successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 12),

              Text(
                '$verifiedMemberName has been verified successfully.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, height: 1.5),
              ),

              const SizedBox(height: 32),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _row(
                      'Verified Members',
                      '${response.verifiedCount} / ${response.totalMembers}',
                    ),
                    const Divider(height: 1),
                    _row('Loan Status', response.status),
                  ],
                ),
              ),

              const Spacer(),

              if (!allVerified) ...[
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => _verifyNextMember(context),
                    child: const Text(
                      'Verify Next Member',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextButton(
                  onPressed: () => _goToMembers(context),
                  child: const Text(
                    'Back to Members',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ] else
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              GroupAllVerifiedSuccessPage(response: response),
                        ),
                      );
                    },
                    child: const Text('Continue'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
