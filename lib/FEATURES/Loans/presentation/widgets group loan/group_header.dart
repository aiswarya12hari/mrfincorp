// import 'package:flutter/material.dart';

// class GroupHeaderCard
//     extends StatelessWidget {
//   final String loanId;
//   final String status;

//   const GroupHeaderCard({
//     super.key,
//     required this.loanId,
//     required this.status,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius:
//             BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: [
//           const CircleAvatar(
//             radius: 24,
//             child: Icon(Icons.groups),
//           ),

//           const SizedBox(width: 12),

//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   loanId,
//                   style: const TextStyle(
//                     fontWeight:
//                         FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 const Text("Group Loan"),
//               ],
//             ),
//           ),

//           Container(
//             padding:
//                 const EdgeInsets.symmetric(
//               horizontal: 10,
//               vertical: 5,
//             ),
//             decoration: BoxDecoration(
//               color:
//                   Colors.blue.shade50,
//               borderRadius:
//                   BorderRadius.circular(
//                 20,
//               ),
//             ),
//             child: Text(status),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class GroupHeaderCard extends StatelessWidget {
  final String loanId;
  final String status;
  final String groupName;
  final String createdDate;

  const GroupHeaderCard({
    super.key,
    required this.loanId,
    required this.status,
    this.groupName = "",
    this.createdDate = "",
  });

  String get _displayStatus => status.replaceAll('_', ' ');

  Color get _statusBg {
    switch (status.toUpperCase()) {
      case 'VERIFIED':
      case 'FULLY_VERIFIED':
        return const Color(0xFFE3F8EF);
      case 'UNVERIFIED':
        return const Color(0xFFFCEAEA);
      default:
        return const Color(0xFFE3EEFB);
    }
  }

  Color get _statusText {
    switch (status.toUpperCase()) {
      case 'VERIFIED':
      case 'FULLY_VERIFIED':
        return const Color(0xFF1E9E6B);
      case 'UNVERIFIED':
        return const Color(0xFFD64545);
      default:
        return const Color(0xFF2E6FE0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFF4FD1C5),
                child: Icon(Icons.groups, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loanId,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      groupName.isEmpty ? "Group Loan" : groupName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _displayStatus,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    color: _statusText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (createdDate.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 56),
              child: Text(
                "Created on $createdDate",
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }
}