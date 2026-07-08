// import 'package:flutter/material.dart';

// import '../../data/models/loan_detail_model.dart';
// import '../../data/models/group_member_model.dart';
// import 'group_member_verification_page.dart';

// class GroupMembersPage extends StatefulWidget {
//   final LoanDetailModel detail;

//   const GroupMembersPage({super.key, required this.detail});

//   @override
//   State<GroupMembersPage> createState() => _GroupMembersPageState();
// }

// class _GroupMembersPageState extends State<GroupMembersPage> {
//   late LoanDetailModel detail;

//   @override
//   void initState() {
//     super.initState();
//     detail = widget.detail;
//   }

//   Future<void> openVerification(GroupMemberModel member) async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => GroupMemberVerificationPage(
//           loanId: detail.loanId,
//           member: member,
//         ),
//       ),
//     );

//     // result is the updated LoanDetailModel-shaped member state after verify;
//     // refresh local state so the list reflects who's now verified
//     if (result is LoanDetailModel && mounted) {
//       setState(() {
//         detail = result;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final verifiedCount = detail.verifiedCount;
//     final totalCount = detail.members.length;

//     return Scaffold(
//       backgroundColor: const Color(0xffF7F8FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text('Group Members'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         detail.loanId,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       _statusChip(detail.status),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     '$verifiedCount / $totalCount Members Verified',
//                     style: TextStyle(color: Colors.grey.shade600),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),

//             Text(
//               'Members (${detail.members.length})',
//               style: const TextStyle(
//                 fontWeight: FontWeight.w700,
//                 fontSize: 15,
//               ),
//             ),

//             const SizedBox(height: 10),

//             Expanded(
//               child: ListView.separated(
//                 itemCount: detail.members.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 12),
//                 itemBuilder: (context, index) {
//                   final member = detail.members[index];
//                   return _MemberCard(
//                     member: member,
//                     onTap: () => openVerification(member),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _statusChip(String status) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade50,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           color: Colors.blue.shade700,
//           fontSize: 11,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }

// class _MemberCard extends StatelessWidget {
//   final GroupMemberModel member;
//   final VoidCallback onTap;

//   const _MemberCard({required this.member, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     final verified = member.isVerified;

//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 22,
//               backgroundColor: verified
//                   ? const Color(0xFFE8F8F6)
//                   : const Color(0xFFFFF1E0),
//               child: Text(
//                 member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   color: verified
//                       ? const Color(0xFF2A9D8F)
//                       : const Color(0xFFE08A2B),
//                 ),
//               ),
//             ),

//             const SizedBox(width: 12),

//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     member.name,
//                     style: const TextStyle(fontWeight: FontWeight.w700),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     member.customerCode,
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               decoration: BoxDecoration(
//                 color: verified
//                     ? const Color(0xFFE8F8F6)
//                     : const Color(0xFFFFF1E0),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 verified ? 'VERIFIED' : 'PENDING',
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w700,
//                   color: verified
//                       ? const Color(0xFF2A9D8F)
//                       : const Color(0xFFE08A2B),
//                 ),
//               ),
//             ),

//             if (!verified) ...[
//               const SizedBox(width: 4),
//               const Icon(Icons.chevron_right, color: Colors.grey),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

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

  // ── Loan-level gate ───────────────────────────────────
  // Verification is only allowed when the loan is in a pending state.
  // FIELDSTAFF_VERIFIED, ADMIN_APPROVAL_PENDING, APPROVED etc. are all locked.
  bool get _isVerificationAllowed {
    final s = detail.status.toUpperCase();
    return s == 'VERIFICATION_PENDING' ||
        s == 'PARTIAL_VERIFIED' ||
        s == 'PARTIALLY_VERIFIED';
  }

  Future<void> openVerification(GroupMemberModel member) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            GroupMemberVerificationPage(loanId: detail.loanId, member: member),
      ),
    );

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

    // Show button only when loan status allows AND there are pending members
    final showVerifyButton =
        _isVerificationAllowed && detail.unverifiedCount > 0;

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
            // ── Header card ───────────────────────────────
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
                      Expanded(
                        child: Text(
                          detail.loanId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
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
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),

            const SizedBox(height: 10),

            // ── Member list ───────────────────────────────
            Expanded(
              child: ListView.separated(
                itemCount: detail.members.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final member = detail.members[index];

                  // Tap allowed only when:
                  // 1. Loan status is in a verifiable state
                  // 2. This specific member is not already verified
                  final canTap = _isVerificationAllowed && !member.isVerified;

                  return _MemberCard(
                    member: member,
                    onTap: canTap ? () => openVerification(member) : null,
                  );
                },
              ),
            ),

            // ── Bottom action button ─────────────────────
            if (showVerifyButton) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final pending = detail.members.firstWhere(
                      (m) => !m.isVerified,
                    );
                    openVerification(pending);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF38B2AC),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    verifiedCount == 0
                        ? 'Verify Members'
                        : 'Verify Remaining Members',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    final display = status.replaceAll('_', ' ');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE3EEFB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        display,
        maxLines: 1,
        softWrap: false,
        style: const TextStyle(
          color: Color(0xFF2E6FE0),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final GroupMemberModel member;
  final VoidCallback? onTap; // nullable — null means non-tappable

  const _MemberCard({required this.member, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final verified = member.isVerified;
    final tappable = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: verified
                      ? const Color(0xFFE3F8EF)
                      : const Color(0xFFFCEDE3),
                  child: Text(
                    member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: verified
                          ? const Color(0xFF1E9E6B)
                          : const Color(0xFFE08A3C),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: verified
                        ? const Color(0xFFE3F8EF)
                        : const Color(0xFFFCEDE3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    verified ? 'VERIFIED' : 'PENDING',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: verified
                          ? const Color(0xFF1E9E6B)
                          : const Color(0xFFE08A3C),
                    ),
                  ),
                ),
                // Chevron only when this card is actually tappable
                if (tappable) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ],
            ),

            const Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                Text(
                  verified ? 'Verified' : 'Pending Verification',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
