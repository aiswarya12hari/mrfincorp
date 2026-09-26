import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';
import '../../../Dashboard/presentation/widgets/dashboard_animations.dart';
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
                  primary: AppColors.primary,
                  onPrimary: AppColors.white,
                  surface: AppColors.cardColor,
                  onSurface: AppColors.gray800,
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
  // MODERN FINTECH INPUT DECORATION & CARD STYLING
  // ─────────────────────────────────────────────────────────────

  InputDecoration _inputDecoration({
    required BuildContext context,
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.hint(context).copyWith(
        fontSize: 13.5,
        color: const Color(0xFFA0AEC0),
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.borderColor.withOpacity(0.85),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: AppColors.borderColor.withOpacity(0.85),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9.5),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section Title Row with Small Teal Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      icon,
                      size: 13.5,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: AppColors.gray800,
                    ),
                  ),
                ],
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 7),
          child,
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dashboardBg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // ── Premium Header with Back Button, Title & Subtitle ──
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: Row(
                children: [
                  BouncyTap(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: AppColors.borderColor.withOpacity(0.85),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E293B).withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: AppColors.gray800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Filters',
                          style: AppTextStyles.headline(context).copyWith(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                            color: AppColors.gray800,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'Refine your loan search',
                          style: AppTextStyles.subheading(context).copyWith(
                            fontSize: 12,
                            color: AppColors.gray600,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable Filter Cards with reduced spacing & increased width ──
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(10, 2, 10, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── 1. STATUS CARD ──
                    _sectionCard(
                      icon: Icons.verified_outlined,
                      title: 'Status',
                      child: DropdownButtonFormField<String?>(
                        value: status,
                        dropdownColor: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(14),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF718096),
                        ),
                        style: AppTextStyles.inputText(context).copyWith(
                          fontSize: 13.5,
                          color: AppColors.gray800,
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

                    const SizedBox(height: 10),

                    // ── 2. LOAN TYPE CARD ──
                    _sectionCard(
                      icon: Icons.tune_rounded,
                      title: 'Loan Type',
                      child: DropdownButtonFormField<String?>(
                        value: loanType,
                        dropdownColor: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(14),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF718096),
                        ),
                        style: AppTextStyles.inputText(context).copyWith(
                          fontSize: 13.5,
                          color: AppColors.gray800,
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

                    const SizedBox(height: 10),

                    // ── 3. METHOD CARD ──
                    _sectionCard(
                      icon: Icons.groups_outlined,
                      title: 'Method',
                      child: DropdownButtonFormField<String?>(
                        value: loanMethod,
                        dropdownColor: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(14),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF718096),
                        ),
                        style: AppTextStyles.inputText(context).copyWith(
                          fontSize: 13.5,
                          color: AppColors.gray800,
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

                    const SizedBox(height: 10),

                    // ── 4. DATE RANGE CARD ──
                    _sectionCard(
                      icon: Icons.calendar_today_rounded,
                      title: 'Date Range',
                      trailing: (fromDate != null || toDate != null)
                          ? BouncyTap(
                              onTap: () {
                                setState(() {
                                  fromDate = null;
                                  toDate = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3.5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Clear dates',
                                  style: AppTextStyles.link(context).copyWith(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
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
                                  style:
                                      AppTextStyles.inputText(context).copyWith(
                                    fontSize: 13,
                                    fontWeight: fromDate != null
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: fromDate != null
                                        ? AppColors.primary
                                        : AppColors.gray800,
                                  ),
                                  decoration: _inputDecoration(
                                    context: context,
                                    hint: 'From',
                                    suffixIcon: const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 16,
                                      color: Color(0xFF718096),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _pickDate(isFrom: false),
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: TextEditingController(
                                    text: _formatDate(toDate),
                                  ),
                                  style:
                                      AppTextStyles.inputText(context).copyWith(
                                    fontSize: 13,
                                    fontWeight: toDate != null
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: toDate != null
                                        ? AppColors.primary
                                        : AppColors.gray800,
                                  ),
                                  decoration: _inputDecoration(
                                    context: context,
                                    hint: 'To',
                                    suffixIcon: const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 16,
                                      color: Color(0xFF718096),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ── 5. LOAN ID CARD ──
                    _sectionCard(
                      icon: Icons.tag_rounded,
                      title: 'Loan ID',
                      child: TextField(
                        controller: loanIdController,
                        style: AppTextStyles.inputText(context).copyWith(
                          fontSize: 13.5,
                        ),
                        decoration: _inputDecoration(
                          context: context,
                          hint: 'Enter Loan ID',
                          suffixIcon: const Icon(
                            Icons.tag_rounded,
                            size: 17,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ── 6. CUSTOMER NAME CARD ──
                    _sectionCard(
                      icon: Icons.person_outline_rounded,
                      title: 'Customer Name',
                      child: TextField(
                        controller: customerController,
                        style: AppTextStyles.inputText(context).copyWith(
                          fontSize: 13.5,
                        ),
                        decoration: _inputDecoration(
                          context: context,
                          hint: 'Enter Customer Name',
                          suffixIcon: const Icon(
                            Icons.person_outline_rounded,
                            size: 17,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Fixed Bottom Button Area (Equal width, 18px rounded corners, subtle shadows) ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: MediaQuery.of(context).padding.bottom + 10,
              ),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                border: Border(
                  top: BorderSide(
                    color: AppColors.borderColor.withOpacity(0.6),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E293B).withOpacity(0.05),
                    blurRadius: 14,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // ── RESET BUTTON ──
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1E293B).withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
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
                          fixedSize: const Size(double.infinity, 52),
                          backgroundColor: AppColors.cardColor,
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 1.3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Reset',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  // ── APPLY BUTTON ──
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.28),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
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
                          minimumSize: const Size(double.infinity, 52),
                          fixedSize: const Size(double.infinity, 52),
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
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
