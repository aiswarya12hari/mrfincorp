// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../../data/model/collection_model.dart';
// import '../../provider/collection_list_provider.dart';
// import '../../provider/collected_list_provider.dart';

// class CollectionFilterPage extends StatefulWidget {
//   final CollectionStatus activeTab;

//   const CollectionFilterPage({super.key, required this.activeTab});

//   @override
//   State<CollectionFilterPage> createState() => _CollectionFilterPageState();
// }

// class _CollectionFilterPageState extends State<CollectionFilterPage> {
//   String? status;
//   String? loanType;
//   String? loanMethod;

//   DateTime? fromDate;
//   DateTime? toDate;

//   final loanIdController = TextEditingController();
//   final customerController = TextEditingController();

//   static const Color _accent = Color(0xFF2A9D8F);
//   static const Color _fieldFill = Color(0xFFF7FAFC);
//   static const Color _border = Color(0xFFE2E8F0);

//   Future<void> _pickDate({required bool isFrom}) async {
//     final now = DateTime.now();

//     final picked = await showDatePicker(
//       context: context,
//       initialDate: (isFrom ? fromDate : toDate) ?? now,
//       firstDate: DateTime(now.year - 5),
//       lastDate: now,
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: Theme.of(context).colorScheme.copyWith(primary: _accent),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked == null) return;

//     setState(() {
//       if (isFrom) {
//         fromDate = picked;
//         if (toDate != null && toDate!.isBefore(fromDate!)) {
//           toDate = null;
//         }
//       } else {
//         toDate = picked;
//       }
//     });
//   }

//   String _formatDate(DateTime? date) {
//     if (date == null) return '';
//     return DateFormat('dd MMM yyyy').format(date);
//   }

//   String? _apiDate(DateTime? date) {
//     if (date == null) return null;
//     return DateFormat('yyyy-MM-dd').format(date);
//   }

//   InputDecoration _decoration({required String hint, Widget? suffixIcon}) {
//     return InputDecoration(
//       hintText: hint,
//       hintStyle: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 14),
//       filled: true,
//       fillColor: _fieldFill,
//       suffixIcon: suffixIcon,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: _border),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: _border),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: _accent, width: 1.4),
//       ),
//     );
//   }

//   Widget _sectionLabel(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Text(
//         text,
//         style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF2D3748)),
//       ),
//     );
//   }

//   Future<void> _apply() async {
//     if (widget.activeTab == CollectionStatus.outstanding) {
//       await context.read<CollectionListProvider>().applyFilter(
//             status: status,
//             loanType: loanType,
//             loanMethod: loanMethod,
//             loanId: loanIdController.text,
//             customerName: customerController.text,
//             dateFrom: _apiDate(fromDate),
//             dateTo: _apiDate(toDate),
//           );
//     } else {
//       await context.read<CollectedListProvider>().applyFilter(
//             status: status,
//             loanType: loanType,
//             loanMethod: loanMethod,
//             loanId: loanIdController.text,
//             customerName: customerController.text,
//             dateFrom: _apiDate(fromDate),
//             dateTo: _apiDate(toDate),
//           );
//     }
//   }

//   Future<void> _reset() async {
//     if (widget.activeTab == CollectionStatus.outstanding) {
//       await context.read<CollectionListProvider>().resetFilter();
//     } else {
//       await context.read<CollectedListProvider>().resetFilter();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: const Color(0xFFF7FAFC),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text('Filters', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: _border),
//                 boxShadow: [
//                   BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _sectionLabel('Status'),
//                   DropdownButtonFormField<String>(
//                     value: status,
//                     decoration: _decoration(hint: 'All'),
//                     icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF718096)),
//                     items: const [
//                       DropdownMenuItem(value: 'VERIFICATION_PENDING', child: Text('Pending')),
//                       DropdownMenuItem(value: 'FIELDSTAFF_VERIFIED', child: Text('Verified')),
//                       DropdownMenuItem(value: 'ADMIN_APPROVED', child: Text('Approved')),
//                     ],
//                     onChanged: (v) => setState(() => status = v),
//                   ),
//                   const SizedBox(height: 20),
//                   _sectionLabel('Loan Type'),
//                   DropdownButtonFormField<String>(
//                     value: loanType,
//                     decoration: _decoration(hint: 'All'),
//                     icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF718096)),
//                     items: const [
//                       DropdownMenuItem(value: 'WEEKLY', child: Text('Weekly')),
//                       DropdownMenuItem(value: 'MONTHLY', child: Text('Monthly')),
//                     ],
//                     onChanged: (v) => setState(() => loanType = v),
//                   ),
//                   const SizedBox(height: 20),
//                   _sectionLabel('Method'),
//                   DropdownButtonFormField<String>(
//                     value: loanMethod,
//                     decoration: _decoration(hint: 'All'),
//                     icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF718096)),
//                     items: const [
//                       DropdownMenuItem(value: 'group', child: Text('Group')),
//                       DropdownMenuItem(value: 'individual', child: Text('Individual')),
//                     ],
//                     onChanged: (v) => setState(() => loanMethod = v),
//                   ),
//                   const SizedBox(height: 20),
//                   _sectionLabel('Date Range'),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () => _pickDate(isFrom: true),
//                           child: AbsorbPointer(
//                             child: TextField(
//                               controller: TextEditingController(text: _formatDate(fromDate)),
//                               decoration: _decoration(
//                                 hint: 'From',
//                                 suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF718096)),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () => _pickDate(isFrom: false),
//                           child: AbsorbPointer(
//                             child: TextField(
//                               controller: TextEditingController(text: _formatDate(toDate)),
//                               decoration: _decoration(
//                                 hint: 'To',
//                                 suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF718096)),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (fromDate != null || toDate != null) ...[
//                     const SizedBox(height: 8),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: () => setState(() {
//                           fromDate = null;
//                           toDate = null;
//                         }),
//                         style: TextButton.styleFrom(
//                           padding: EdgeInsets.zero,
//                           minimumSize: const Size(0, 0),
//                           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         ),
//                         child: const Text('Clear dates',
//                             style: TextStyle(color: _accent, fontSize: 12, fontWeight: FontWeight.w600)),
//                       ),
//                     ),
//                   ],
//                   const SizedBox(height: 20),
//                   _sectionLabel('Loan ID'),
//                   TextField(
//                     controller: loanIdController,
//                     decoration: _decoration(
//                       hint: 'Enter Loan ID',
//                       suffixIcon: const Icon(Icons.tag_rounded, size: 18, color: Color(0xFF718096)),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   _sectionLabel('Customer Name'),
//                   TextField(
//                     controller: customerController,
//                     decoration: _decoration(
//                       hint: 'Enter Customer Name',
//                       suffixIcon: const Icon(Icons.person_outline_rounded, size: 18, color: Color(0xFF718096)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 52),
//                       side: const BorderSide(color: _border),
//                       foregroundColor: const Color(0xFF2D3748),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     ),
//                     onPressed: () async {
//                       setState(() {
//                         status = null;
//                         loanType = null;
//                         loanMethod = null;
//                         fromDate = null;
//                         toDate = null;
//                         loanIdController.clear();
//                         customerController.clear();
//                       });
//                       await _reset();
//                       if (mounted) Navigator.pop(context);
//                     },
//                     child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.w600)),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 52),
//                       backgroundColor: _accent,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     ),
//                     onPressed: () async {
//                       await _apply();
//                       if (mounted) Navigator.pop(context);
//                     },
//                     child: const Text('Apply', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/model/collection_model.dart';
import '../../provider/collection_list_provider.dart';
import '../../provider/collected_list_provider.dart';

class CollectionFilterPage extends StatefulWidget {
  final CollectionStatus activeTab;

  const CollectionFilterPage({
    super.key,
    required this.activeTab,
  });

  @override
  State<CollectionFilterPage> createState() => _CollectionFilterPageState();
}

class _CollectionFilterPageState extends State<CollectionFilterPage> {
  String? loanType;
  String? loanMethod;

  DateTime? fromDate;
  DateTime? toDate;

  final loanIdController = TextEditingController();
  final customerController = TextEditingController();

  static const Color _accent = Color(0xFF2A9D8F);
  static const Color _fieldFill = Color(0xFFF7FAFC);
  static const Color _border = Color(0xFFE2E8F0);

  @override
  void dispose() {
    loanIdController.dispose();
    customerController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: (isFrom ? fromDate : toDate) ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: _accent,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      if (isFrom) {
        fromDate = picked;

        if (toDate != null && toDate!.isBefore(fromDate!)) {
          toDate = null;
        }
      } else {
        toDate = picked;
      }
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd MMM yyyy').format(date);
  }

  String? _apiDate(DateTime? date) {
    if (date == null) return null;
    return DateFormat('yyyy-MM-dd').format(date);
  }

  InputDecoration _decoration({
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFFA0AEC0),
        fontSize: 14,
      ),
      filled: true,
      fillColor: _fieldFill,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: _border,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: _border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: _accent,
          width: 1.4,
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xFF2D3748),
        ),
      ),
    );
  }

  Future<void> _apply() async {
    if (widget.activeTab == CollectionStatus.outstanding) {
      await context.read<CollectionListProvider>().applyFilter(
            loanType: loanType,
            loanMethod: loanMethod,
            loanId: loanIdController.text.trim(),
            customerName: customerController.text.trim(),
            dateFrom: _apiDate(fromDate),
            dateTo: _apiDate(toDate),
          );
    } else {
      await context.read<CollectedListProvider>().applyFilter(
            loanType: loanType,
            loanMethod: loanMethod,
            loanId: loanIdController.text.trim(),
            customerName: customerController.text.trim(),
            dateFrom: _apiDate(fromDate),
            dateTo: _apiDate(toDate),
          );
    }
  }

  Future<void> _reset() async {
    if (widget.activeTab == CollectionStatus.outstanding) {
      await context.read<CollectionListProvider>().resetFilter();
    } else {
      await context.read<CollectedListProvider>().resetFilter();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filters',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _border,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─────────────────────────────
                  // Loan Type
                  // ─────────────────────────────
                  _sectionLabel('Loan Type'),

                  DropdownButtonFormField<String>(
                    value: loanType,
                    decoration: _decoration(
                      hint: 'All',
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF718096),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'WEEKLY',
                        child: Text('Weekly'),
                      ),
                      DropdownMenuItem(
                        value: 'MONTHLY',
                        child: Text('Monthly'),
                      ),
                    ],
                    onChanged: (v) {
                      setState(() {
                        loanType = v;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // ─────────────────────────────
                  // Loan Method
                  // ─────────────────────────────
                  _sectionLabel('Method'),

                  DropdownButtonFormField<String>(
                    value: loanMethod,
                    decoration: _decoration(
                      hint: 'All',
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF718096),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'group',
                        child: Text('Group'),
                      ),
                      DropdownMenuItem(
                        value: 'individual',
                        child: Text('Individual'),
                      ),
                    ],
                    onChanged: (v) {
                      setState(() {
                        loanMethod = v;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // ─────────────────────────────
                  // Date Range
                  // ─────────────────────────────
                  _sectionLabel('Date Range'),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(
                            isFrom: true,
                          ),
                          child: AbsorbPointer(
                            child: TextField(
                              controller: TextEditingController(
                                text: _formatDate(fromDate),
                              ),
                              decoration: _decoration(
                                hint: 'From',
                                suffixIcon: const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 18,
                                  color: Color(0xFF718096),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(
                            isFrom: false,
                          ),
                          child: AbsorbPointer(
                            child: TextField(
                              controller: TextEditingController(
                                text: _formatDate(toDate),
                              ),
                              decoration: _decoration(
                                hint: 'To',
                                suffixIcon: const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 18,
                                  color: Color(0xFF718096),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (fromDate != null || toDate != null) ...[
                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            fromDate = null;
                            toDate = null;
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(
                            0,
                            0,
                          ),
                          tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Clear dates',
                          style: TextStyle(
                            color: _accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // ─────────────────────────────
                  // Loan ID
                  // ─────────────────────────────
                  _sectionLabel('Loan ID'),

                  TextField(
                    controller: loanIdController,
                    decoration: _decoration(
                      hint: 'Enter Loan ID',
                      suffixIcon: const Icon(
                        Icons.tag_rounded,
                        size: 18,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ─────────────────────────────
                  // Customer Name
                  // ─────────────────────────────
                  _sectionLabel('Customer Name'),

                  TextField(
                    controller: customerController,
                    decoration: _decoration(
                      hint: 'Enter Customer Name',
                      suffixIcon: const Icon(
                        Icons.person_outline_rounded,
                        size: 18,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ─────────────────────────────
            // Buttons
            // ─────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(
                        double.infinity,
                        52,
                      ),
                      side: const BorderSide(
                        color: _border,
                      ),
                      foregroundColor:
                          const Color(0xFF2D3748),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        loanType = null;
                        loanMethod = null;
                        fromDate = null;
                        toDate = null;

                        loanIdController.clear();
                        customerController.clear();
                      });

                      await _reset();

                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                        double.infinity,
                        52,
                      ),
                      backgroundColor: _accent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await _apply();

                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
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