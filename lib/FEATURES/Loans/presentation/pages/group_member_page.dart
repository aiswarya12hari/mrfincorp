import 'package:flutter/material.dart';

import '../../data/models/loan_detail_model.dart';
import '../../data/models/group_member_model.dart';
import 'group_member_verification_page.dart';

class GroupMembersPage extends StatefulWidget {
  final LoanDetailModel detail;

  const GroupMembersPage({super.key, required this.detail});

  @override
  State<GroupMembersPage> createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends State<GroupMembersPage> {
  late LoanDetailModel detail;

  @override
  void initState() {
    super.initState();
    detail = widget.detail;
  }

  Future<void> openVerification(GroupMemberModel member) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GroupMemberVerificationPage(
          loanId: detail.loanId,
          member: member,
        ),
      ),
    );

    // result is the updated LoanDetailModel-shaped member state after verify;
    // refresh local state so the list reflects who's now verified
    if (result is LoanDetailModel && mounted) {
      setState(() {
        detail = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final verifiedCount = detail.verifiedCount;
    final totalCount = detail.members.length;

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Group Members'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        detail.loanId,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _statusChip(detail.status),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$verifiedCount / $totalCount Members Verified',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Members (${detail.members.length})',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.separated(
                itemCount: detail.members.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final member = detail.members[index];
                  return _MemberCard(
                    member: member,
                    onTap: () => openVerification(member),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: Colors.blue.shade700,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final GroupMemberModel member;
  final VoidCallback onTap;

  const _MemberCard({required this.member, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final verified = member.isVerified;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: verified
                  ? const Color(0xFFE8F8F6)
                  : const Color(0xFFFFF1E0),
              child: Text(
                member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: verified
                      ? const Color(0xFF2A9D8F)
                      : const Color(0xFFE08A2B),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    member.customerCode,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: verified
                    ? const Color(0xFFE8F8F6)
                    : const Color(0xFFFFF1E0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                verified ? 'VERIFIED' : 'PENDING',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: verified
                      ? const Color(0xFF2A9D8F)
                      : const Color(0xFFE08A2B),
                ),
              ),
            ),

            if (!verified) ...[
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ],
        ),
      ),
    );
  }
}

