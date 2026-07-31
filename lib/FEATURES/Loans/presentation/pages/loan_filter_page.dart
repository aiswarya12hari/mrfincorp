// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../../provider/loan_provider.dart';

// class LoanFilterPage extends StatefulWidget {
//   const LoanFilterPage({super.key});

//   @override
//   State<LoanFilterPage> createState() => _LoanFilterPageState();
// }

// class _LoanFilterPageState extends State<LoanFilterPage> {
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
//             colorScheme: Theme.of(context).colorScheme.copyWith(
//                   primary: _accent,
//                 ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked == null) return;

//     setState(() {
//       if (isFrom) {
//         fromDate = picked;
//         // keep range valid
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
//       contentPadding:
//           const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
//         style: const TextStyle(
//           fontWeight: FontWeight.w600,
//           fontSize: 14,
//           color: Color(0xFF2D3748),
//         ),
//       ),
//     );
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
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           'Filters',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             /// CARD CONTAINER
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: _border),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.03),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// STATUS
//                   _sectionLabel('Status'),
//                   DropdownButtonFormField<String>(
//                     value: status,
//                     decoration: _decoration(hint: 'All'),
//                     icon: const Icon(Icons.keyboard_arrow_down_rounded,
//                         color: Color(0xFF718096)),
//                     items: const [
//                       DropdownMenuItem(
//                         value: 'VERIFICATION_PENDING',
//                         child: Text('Pending'),
//                       ),
//                       DropdownMenuItem(
//                         value: 'FIELDSTAFF_VERIFIED',
//                         child: Text('Verified'),
//                       ),
//                       DropdownMenuItem(
//                         value: 'ADMIN_APPROVED',
//                         child: Text('Approved'),
//                       ),
//                     ],
//                     onChanged: (v) {
//                       setState(() {
//                         status = v;
//                       });
//                     },
//                   ),

//                   const SizedBox(height: 20),

//                   /// LOAN TYPE
//                   _sectionLabel('Loan Type'),
//                   DropdownButtonFormField<String>(
//                     value: loanType,
//                     decoration: _decoration(hint: 'All'),
//                     icon: const Icon(Icons.keyboard_arrow_down_rounded,
//                         color: Color(0xFF718096)),
//                     items: const [
//                       DropdownMenuItem(value: 'WEEKLY', child: Text('Weekly')),
//                       DropdownMenuItem(
//                           value: 'MONTHLY', child: Text('Monthly')),
//                     ],
//                     onChanged: (v) {
//                       setState(() {
//                         loanType = v;
//                       });
//                     },
//                   ),

//                   const SizedBox(height: 20),

//                   /// LOAN METHOD
//                   _sectionLabel('Method'),
//                   DropdownButtonFormField<String>(
//                     value: loanMethod,
//                     decoration: _decoration(hint: 'All'),
//                     icon: const Icon(Icons.keyboard_arrow_down_rounded,
//                         color: Color(0xFF718096)),
//                     items: const [
//                       DropdownMenuItem(value: 'group', child: Text('Group')),
//                       DropdownMenuItem(
//                         value: 'individual',
//                         child: Text('Individual'),
//                       ),
//                     ],
//                     onChanged: (v) {
//                       setState(() {
//                         loanMethod = v;
//                       });
//                     },
//                   ),

//                   const SizedBox(height: 20),

//                   /// DATE RANGE
//                   _sectionLabel('Date Range'),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () => _pickDate(isFrom: true),
//                           child: AbsorbPointer(
//                             child: TextField(
//                               controller: TextEditingController(
//                                 text: _formatDate(fromDate),
//                               ),
//                               decoration: _decoration(
//                                 hint: 'From',
//                                 suffixIcon: const Icon(
//                                   Icons.calendar_today_outlined,
//                                   size: 18,
//                                   color: Color(0xFF718096),
//                                 ),
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
//                               controller: TextEditingController(
//                                 text: _formatDate(toDate),
//                               ),
//                               decoration: _decoration(
//                                 hint: 'To',
//                                 suffixIcon: const Icon(
//                                   Icons.calendar_today_outlined,
//                                   size: 18,
//                                   color: Color(0xFF718096),
//                                 ),
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
//                         onPressed: () {
//                           setState(() {
//                             fromDate = null;
//                             toDate = null;
//                           });
//                         },
//                         style: TextButton.styleFrom(
//                           padding: EdgeInsets.zero,
//                           minimumSize: const Size(0, 0),
//                           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         ),
//                         child: const Text(
//                           'Clear dates',
//                           style: TextStyle(
//                             color: _accent,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],

//                   const SizedBox(height: 20),

//                   /// LOAN ID
//                   _sectionLabel('Loan ID'),
//                   TextField(
//                     controller: loanIdController,
//                     decoration: _decoration(
//                       hint: 'Enter Loan ID',
//                       suffixIcon: const Icon(
//                         Icons.tag_rounded,
//                         size: 18,
//                         color: Color(0xFF718096),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   /// CUSTOMER NAME
//                   _sectionLabel('Customer Name'),
//                   TextField(
//                     controller: customerController,
//                     decoration: _decoration(
//                       hint: 'Enter Customer Name',
//                       suffixIcon: const Icon(
//                         Icons.person_outline_rounded,
//                         size: 18,
//                         color: Color(0xFF718096),
//                       ),
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
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
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

//                       await context.read<LoanProvider>().resetFilter();

//                       if (mounted) {
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: const Text(
//                       'Reset',
//                       style: TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(width: 12),

//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 52),
//                       backgroundColor: _accent,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     onPressed: () async {
//                       await context.read<LoanProvider>().applyFilter(
//                             status: status,
//                             loanType: loanType,
//                             loanMethod: loanMethod,
//                             loanId: loanIdController.text,
//                             customerName: customerController.text,
//                             dateFrom: _apiDate(fromDate),
//                             dateTo: _apiDate(toDate),
//                           );

//                       if (mounted) {
//                         Navigator.pop(context);
//                       }
//                     },
//                     child: const Text(
//                       'Apply',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
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

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';
import '../../provider/loan_provider.dart';

class LoanFilterPage extends StatefulWidget {
  const LoanFilterPage({super.key});

  @override
  State<LoanFilterPage> createState() => _LoanFilterPageState();
}

class _LoanFilterPageState extends State<LoanFilterPage> {
  String? status;
  String? loanType;
  String? loanMethod;

  DateTime? fromDate;
  DateTime? toDate;

  final loanIdController = TextEditingController();
  final customerController = TextEditingController();

  @override
  void dispose() {
    loanIdController.dispose();
    customerController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────
  // DATE PICKER
  // ─────────────────────────────────────────────────────────────

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
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      if (isFrom) {
        fromDate = picked;

        // Keep date range valid
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

  // ─────────────────────────────────────────────────────────────
  // INPUT DECORATION
  // ─────────────────────────────────────────────────────────────

  InputDecoration _decoration({required String hint, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.hint(context),
      filled: true,
      fillColor: AppColors.gray100,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SECTION LABEL
  // ─────────────────────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTextStyles.fieldValue(
          context,
        ).copyWith(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,

      // Important:
      // The bottom button area will stay fixed.
      // The scrollable area will resize when keyboard appears.
      resizeToAvoidBottomInset: true,

      // ─────────────────────────────────────────────────────────
      // APP BAR
      // ─────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: AppColors.gray100,
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.gray800),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Filters',
          style: AppTextStyles.pageTitle(
            context,
          ).copyWith(color: AppColors.gray800),
        ),
      ),

      // ─────────────────────────────────────────────────────────
      // BODY
      // ─────────────────────────────────────────────────────────
      body: Column(
        children: [
          // =====================================================
          // SCROLLABLE FILTER CONTENT
          // =====================================================
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),

              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderColor),
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
                    // =================================================
                    // STATUS
                    // =================================================
                    _sectionLabel('Status'),

                    DropdownButtonFormField<String>(
                      value: status,

                      decoration: _decoration(hint: 'All'),

                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.gray600,
                      ),

                      items: const [
                        DropdownMenuItem(
                          value: 'VERIFICATION_PENDING',
                          child: Text('Pending'),
                        ),
                        DropdownMenuItem(
                          value: 'FIELDSTAFF_VERIFIED',
                          child: Text('Verified'),
                        ),
                        DropdownMenuItem(
                          value: 'ADMIN_APPROVED',
                          child: Text('Approved'),
                        ),
                      ],

                      onChanged: (value) {
                        setState(() {
                          status = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // =================================================
                    // LOAN TYPE
                    // =================================================
                    _sectionLabel('Loan Type'),

                    DropdownButtonFormField<String>(
                      value: loanType,

                      decoration: _decoration(hint: 'All'),

                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.gray600,
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

                      onChanged: (value) {
                        setState(() {
                          loanType = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // =================================================
                    // METHOD
                    // =================================================
                    _sectionLabel('Method'),

                    DropdownButtonFormField<String>(
                      value: loanMethod,

                      decoration: _decoration(hint: 'All'),

                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.gray600,
                      ),

                      items: const [
                        DropdownMenuItem(value: 'group', child: Text('Group')),
                        DropdownMenuItem(
                          value: 'individual',
                          child: Text('Individual'),
                        ),
                      ],

                      onChanged: (value) {
                        setState(() {
                          loanMethod = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // =================================================
                    // DATE RANGE
                    // =================================================
                    _sectionLabel('Date Range'),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickDate(isFrom: true),
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
                                    color: AppColors.gray600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pickDate(isFrom: false),
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
                                    color: AppColors.gray600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // CLEAR DATES
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
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),

                          child: Text(
                            'Clear dates',
                            style: AppTextStyles.link(
                              context,
                            ).copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),

                    // =================================================
                    // LOAN ID
                    // =================================================
                    _sectionLabel('Loan ID'),

                    TextField(
                      controller: loanIdController,

                      style: AppTextStyles.inputText(context),

                      decoration: _decoration(
                        hint: 'Enter Loan ID',

                        suffixIcon: const Icon(
                          Icons.tag_rounded,
                          size: 18,
                          color: AppColors.gray600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =================================================
                    // CUSTOMER NAME
                    // =================================================
                    _sectionLabel('Customer Name'),

                    TextField(
                      controller: customerController,

                      style: AppTextStyles.inputText(context),

                      decoration: _decoration(
                        hint: 'Enter Customer Name',

                        suffixIcon: const Icon(
                          Icons.person_outline_rounded,
                          size: 18,
                          color: AppColors.gray600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // =====================================================
          // FIXED BOTTOM BUTTON AREA
          // =====================================================
          Container(
            width: double.infinity,

            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,

              // Automatically handles Android navigation bar
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),

            decoration: BoxDecoration(
              color: AppColors.white,

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),

            child: Row(
              children: [
                // =================================================
                // RESET BUTTON
                // =================================================

                // Expanded(
                //   child: OutlinedButton(
                //     onPressed: () async {
                //       setState(() {
                //         status = null;
                //         loanType = null;
                //         loanMethod = null;
                //         fromDate = null;
                //         toDate = null;

                //         loanIdController.clear();
                //         customerController.clear();
                //       });

                //       await context
                //           .read<LoanProvider>()
                //           .resetFilter();

                //       if (mounted) {
                //         Navigator.pop(context);
                //       }
                //     },

                //     style: OutlinedButton.styleFrom(
                //       minimumSize: const Size(
                //         double.infinity,
                //         52,
                //       ),

                //       backgroundColor: AppColors.white,

                //       foregroundColor: AppColors.primary,

                //       side: const BorderSide(
                //         color: AppColors.primary,
                //         width: 1.2,
                //       ),

                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),

                //       elevation: 0,
                //     ),

                //     child: Text(
                //       'Reset',
                //       style: AppTextStyles.button(context).copyWith(
                //         color: AppColors.primary,
                //       ),
                //     ),
                //   ),
                // ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        status = null;
                        loanType = null;
                        loanMethod = null;
                        fromDate = null;
                        toDate = null;

                        loanIdController.clear();
                        customerController.clear();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 1.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Reset',
                      style: AppTextStyles.button(
                        context,
                      ).copyWith(color: AppColors.primary),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // =================================================
                // APPLY BUTTON
                // =================================================
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await context.read<LoanProvider>().applyFilter(
                        status: status,
                        loanType: loanType,
                        loanMethod: loanMethod,
                        loanId: loanIdController.text.trim(),
                        customerName: customerController.text.trim(),
                        dateFrom: _apiDate(fromDate),
                        dateTo: _apiDate(toDate),
                      );

                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),

                      backgroundColor: AppColors.primary,

                      foregroundColor: AppColors.white,

                      disabledBackgroundColor: AppColors.gray400,

                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: Text('Apply', style: AppTextStyles.button(context)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
