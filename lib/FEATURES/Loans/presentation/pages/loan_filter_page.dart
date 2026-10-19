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
  void initState() {
    super.initState();
    final provider = context.read<LoanProvider>();
    status = provider.selectedStatus;
    loanType = provider.selectedLoanType;
    loanMethod = provider.selectedLoanMethod;
    if (provider.selectedDateFrom != null &&
        provider.selectedDateFrom!.isNotEmpty) {
      try {
        fromDate = DateTime.parse(provider.selectedDateFrom!);
      } catch (_) {}
    }
    if (provider.selectedDateTo != null &&
        provider.selectedDateTo!.isNotEmpty) {
      try {
        toDate = DateTime.parse(provider.selectedDateTo!);
      } catch (_) {}
    }
    if (provider.searchLoanId.isNotEmpty) {
      loanIdController.text = provider.searchLoanId;
    }
    if (provider.searchCustomer.isNotEmpty) {
      customerController.text = provider.searchCustomer;
    }
  }

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
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.secondary,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: const Color(0xFF1E293B),
                ),
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
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

  // ─────────────────────────────────────────────────────────────
  // MODERN FLAT INPUT DECORATION
  // ─────────────────────────────────────────────────────────────

  InputDecoration _inputDecoration({
    required BuildContext context,
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: AppTextStyles.fontFamily,
        fontSize: 13.5,
        color: Color(0xFF94A3B8),
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: const Color(0xFFF1F4F9),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.secondary,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _fieldSection({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                letterSpacing: -0.2,
              ),
            ),
            ?trailing,
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF111827),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filters',
          style: TextStyle(
            fontFamily: AppTextStyles.fontFamily,
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Scrollable Card containing all fields ──
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── 1. STATUS ──
                      _fieldSection(
                        title: 'Status',
                        child: DropdownButtonFormField<String?>(
                          key: ValueKey('status_$status'),
                          initialValue: status,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF64748B),
                          ),
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E293B),
                          ),
                          decoration: _inputDecoration(
                            context: context,
                            hint: 'All',
                          ),
                          items: const [
                            DropdownMenuItem<String?>(
                              value: null,
                              child: Text('All'),
                            ),
                            DropdownMenuItem<String?>(
                              value: 'VERIFICATION_PENDING',
                              child: Text('Pending'),
                            ),
                            DropdownMenuItem<String?>(
                              value: 'FIELDSTAFF_VERIFIED',
                              child: Text('Verified'),
                            ),
                            DropdownMenuItem<String?>(
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
                      ),

                      const SizedBox(height: 18),

                      // ── 2. LOAN TYPE ──
                      _fieldSection(
                        title: 'Loan Type',
                        child: DropdownButtonFormField<String?>(
                          key: ValueKey('loanType_$loanType'),
                          initialValue: loanType,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF64748B),
                          ),
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E293B),
                          ),
                          decoration: _inputDecoration(
                            context: context,
                            hint: 'All',
                          ),
                          items: const [
                            DropdownMenuItem<String?>(
                              value: null,
                              child: Text('All'),
                            ),
                            DropdownMenuItem<String?>(
                              value: 'WEEKLY',
                              child: Text('Weekly'),
                            ),
                            DropdownMenuItem<String?>(
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
                      ),

                      const SizedBox(height: 18),

                      // ── 3. METHOD ──
                      _fieldSection(
                        title: 'Method',
                        child: DropdownButtonFormField<String?>(
                          key: ValueKey('loanMethod_$loanMethod'),
                          initialValue: loanMethod,
                          dropdownColor: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF64748B),
                          ),
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E293B),
                          ),
                          decoration: _inputDecoration(
                            context: context,
                            hint: 'All',
                          ),
                          items: const [
                            DropdownMenuItem<String?>(
                              value: null,
                              child: Text('All'),
                            ),
                            DropdownMenuItem<String?>(
                              value: 'group',
                              child: Text('Group'),
                            ),
                            DropdownMenuItem<String?>(
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
                      ),

                      const SizedBox(height: 18),

                      // ── 4. DATE RANGE ──
                      _fieldSection(
                        title: 'Date Range',
                        trailing: (fromDate != null || toDate != null)
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    fromDate = null;
                                    toDate = null;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    'Clear dates',
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ),
                              )
                            : null,
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _pickDate(isFrom: true),
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: TextEditingController(
                                      text: _formatDate(fromDate),
                                    ),
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 13.5,
                                      fontWeight: fromDate != null
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: const Color(0xFF1E293B),
                                    ),
                                    decoration: _inputDecoration(
                                      context: context,
                                      hint: 'From',
                                      suffixIcon: const Icon(
                                        Icons.calendar_today_outlined,
                                        size: 18,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _pickDate(isFrom: false),
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: TextEditingController(
                                      text: _formatDate(toDate),
                                    ),
                                    style: TextStyle(
                                      fontFamily: AppTextStyles.fontFamily,
                                      fontSize: 13.5,
                                      fontWeight: toDate != null
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: const Color(0xFF1E293B),
                                    ),
                                    decoration: _inputDecoration(
                                      context: context,
                                      hint: 'To',
                                      suffixIcon: const Icon(
                                        Icons.calendar_today_outlined,
                                        size: 18,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ── 5. LOAN ID ──
                      _fieldSection(
                        title: 'Loan ID',
                        child: TextField(
                          controller: loanIdController,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E293B),
                          ),
                          decoration: _inputDecoration(
                            context: context,
                            hint: 'Enter Loan ID',
                            suffixIcon: const Icon(
                              Icons.tag_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ── 6. CUSTOMER NAME ──
                      _fieldSection(
                        title: 'Customer Name',
                        child: TextField(
                          controller: customerController,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E293B),
                          ),
                          decoration: _inputDecoration(
                            context: context,
                            hint: 'Enter Customer Name',
                            suffixIcon: const Icon(
                              Icons.person_outline_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom Buttons (Reset + Apply) ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Reset Button
                  Expanded(
                    child: SizedBox(
                      height: 50,
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
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            color: Color(0xFFE2E8F0),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Apply Button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          final nav = Navigator.of(context);
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
                            nav.pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
