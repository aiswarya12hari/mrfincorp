// import 'package:flutter/material.dart';
// import 'package:mr_fincorp/FEATURES/Loans/data/models/customer_model.dart';


// class CustomerDetailsCard extends StatelessWidget {
//   final CustomerModel customer;

//   const CustomerDetailsCard({
//     super.key,
//     required this.customer,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Customer Details',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//             ),
//           ),

//           const SizedBox(height: 16),

//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 26,
//                 backgroundColor: const Color(
//                   0xFFD5F5F1,
//                 ),
//                 child: const Icon(
//                   Icons.person,
//                   color: Color(0xFF0D5C63),
//                   size: 28,
//                 ),
//               ),

//               const SizedBox(width: 12),

//               Expanded(
//                 child: Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       customer.name,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 16,
//                       ),
//                     ),

//                     const SizedBox(height: 2),

//                     Text(
//                       customer.customerId,
//                       style: TextStyle(
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),

//           Row(
//             children: [
//               const Icon(
//                 Icons.phone_outlined,
//                 size: 18,
//                 color: Colors.black54,
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(customer.phone),
//               ),
//             ],
//           ),

//           const SizedBox(height: 12),

//           Row(
//             children: [
//               const Icon(
//                 Icons.work_outline,
//                 size: 18,
//                 color: Colors.black54,
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(customer.occupation),
//               ),
//             ],
//           ),

//           const SizedBox(height: 12),

//           Row(
//             crossAxisAlignment:
//                 CrossAxisAlignment.start,
//             children: [
//               const Icon(
//                 Icons.location_on_outlined,
//                 size: 18,
//                 color: Colors.black54,
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   '${customer.fullAddress}, ${customer.district}, ${customer.state} - ${customer.pinCode}',
//                 ),
//               ),
//             ],
//           ),

          
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:mr_fincorp/FEATURES/Loans/data/models/customer_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDetailsCard extends StatelessWidget {
  final CustomerModel customer;

  const CustomerDetailsCard({
    super.key,
    required this.customer,
  });

  Future<void> openMap(String url) async {
    try {
      final uri = Uri.parse(url);

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('MAP OPEN ERROR => $e');
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final trimmed = phoneNumber.trim();
    if (trimmed.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: trimmed);
    try {
      await launchUrl(uri);
    } catch (e) {
      debugPrint('CALL ERROR => $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFFD5F5F1),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF0D5C63),
                  size: 28,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      customer.customerId,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 18,
                color: Colors.black54,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(customer.phone),
              ),
              if (customer.phone.trim().isNotEmpty)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => makePhoneCall(customer.phone),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF006A61),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.call,
                            size: 14,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Call',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.work_outline,
                size: 18,
                color: Colors.black54,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(customer.occupation),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.black54,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${customer.fullAddress}, ${customer.district}, ${customer.state} - ${customer.pinCode}',
                ),
              ),
            ],
          ),

          if (customer.googleMapLink.isNotEmpty) ...[
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.map_outlined,
                  size: 18,
                  color: Colors.black54,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected Location',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      InkWell(
                        onTap: () => openMap(
                          customer.googleMapLink,
                        ),
                        child: const Text(
                          'Open Location In Google Maps',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration:
                                TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        customer.googleMapLink,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}