import 'package:flutter/material.dart';
import '../Theme/app_color.dart';
import '../Theme/app_text_style.dart';

/// Shared page wrapper used across the app so every page gets a
/// consistent back button + pull-to-refresh without repeating the
/// same Scaffold/AppBar/RefreshIndicator boilerplate everywhere.
///
/// USAGE — pushed pages (loan detail, group member page, etc.):
///
/// return AppScaffoldWrapper(
///   title: 'Loan Details',
///   onRefresh: () => context.read<LoanDetailProvider>().fetchLoanDetail(loanId),
///   body: ...your existing scrollable content...,
/// );
///
/// USAGE — bottom-nav root pages (Dashboard, Loans, Collections, Profile):
/// pass showBackButton: false (or leave default — see note below).
///
/// IMPORTANT: `body` MUST be scrollable (ListView / SingleChildScrollView)
/// for RefreshIndicator's pull gesture to register. If your page's content
/// might be shorter than the screen, wrap it with
/// AlwaysScrollableScrollPhysics (already applied internally when you use
/// AppScaffoldWrapper.listBody / .scrollBody helpers below).
class AppScaffoldWrapper extends StatelessWidget {
  /// Title shown in the AppBar. Pass null if you're using [customHeader]
  /// instead (e.g. DashboardHeader, ProfileHeader — full-width custom
  /// headers instead of a standard AppBar).
  final String? title;

  /// Set false for bottom-nav ROOT pages (Dashboard/Loans/Collections/
  /// Profile tabs) where there's nothing to go "back" to. Defaults to
  /// true because most pages in the app ARE pushed pages.
  final bool showBackButton;

  /// Called when the user pulls to refresh. Pass your provider's fetch
  /// method, e.g. `() => context.read<LoanProvider>().fetchLoans()`.
  /// If null, no RefreshIndicator is applied (rare — e.g. a static form
  /// page with no data to reload).
  final Future<void> Function()? onRefresh;

  /// The scrollable page content.
  final Widget body;

  /// Optional custom header widget (e.g. DashboardHeader) shown INSTEAD
  /// of the standard AppBar. When provided, [title]/[showBackButton]/
  /// [actions] are ignored for the AppBar itself — the custom header is
  /// responsible for its own back button if it needs one.
  final PreferredSizeWidget? customHeader;

  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  /// Called when the back button is tapped. Defaults to Navigator.pop.
  /// Override for pages that need custom back behavior (e.g. confirm
  /// dialog before leaving an unsaved form).
  final VoidCallback? onBackPressed;

  const AppScaffoldWrapper({
    super.key,
    this.title,
    this.showBackButton = true,
    this.onRefresh,
    required this.body,
    this.customHeader,
    this.actions,
    this.bottomNavigationBar,
    this.backgroundColor,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content = onRefresh != null
        ? RefreshIndicator(
            onRefresh: onRefresh!,
            color: AppColors.primary,
            child: body,
          )
        : body;

    return Scaffold(
      backgroundColor: backgroundColor ?? AppColors.gray100,
      appBar: customHeader == null
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0.5,
              centerTitle: false,
              automaticallyImplyLeading: false,
              leading: showBackButton
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: AppColors.gray800,
                      ),
                      onPressed:
                          onBackPressed ?? () => Navigator.of(context).pop(),
                    )
                  : null,
              title: title != null
                  ? Text(
                      title!,
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray800,
                      ),
                    )
                  : null,
              actions: actions,
            )
          : customHeader,
      body: SafeArea(top: customHeader == null, child: content),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  // ── Helpers to guarantee pull-to-refresh works even when content
  // is short. Use these to build `body` instead of a raw ListView. ──

  /// Wraps a single scrollable column of widgets (most detail pages).
  static Widget scrollBody({
    required List<Widget> children,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        );
      },
    );
  }

  /// Wraps a list-style page (loans list, collections list).
  static Widget listBody({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: padding,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
