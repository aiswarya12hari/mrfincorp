// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../provider/loan_provider.dart';
// import 'loan_card.dart';

// class LoansList extends StatefulWidget {
//   const LoansList({super.key});

//   @override
//   State<LoansList> createState() => _LoansListState();
// }

// class _LoansListState extends State<LoansList> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();

//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels >=
//           _scrollController.position.maxScrollExtent - 200) {
//         context.read<LoanProvider>().loadMoreLoans();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _refreshLoans() async {
//     await context.read<LoanProvider>().fetchLoans();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<LoanProvider>(
//       builder: (context, provider, child) {
//         if (provider.isLoading && provider.loans.isEmpty) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return RefreshIndicator(
//           onRefresh: _refreshLoans,
//           child: provider.loans.isEmpty
//               ? ListView(
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   children: const [
//                     SizedBox(height: 250),
//                     Center(child: Text('No Loans Found')),
//                   ],
//                 )
//               : ListView.builder(
//                   controller: _scrollController,
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: provider.loans.length + (provider.hasMore ? 1 : 0),
//                   itemBuilder: (context, index) {
//                     if (index == provider.loans.length) {
//                       return const Padding(
//                         padding: EdgeInsets.all(20),
//                         child: Center(child: CircularProgressIndicator()),
//                       );
//                     }

//                     final loan = provider.loans[index];

//                     return LoanCard(
//                       loanId: loan.loanId,
//                       customer: loan.customerName,
//                       amount: '₹ ${loan.loanAmount}',
//                       date: loan.dateOfApplication,
//                       type: loan.loanType,
//                       status: loan.status,
//                       loanMethod: loan.loanMethod,
//                     );
//                   },
//                 ),
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../CORE/Widgets/app_pagination.dart';

import '../../provider/loan_provider.dart';
import 'loan_card.dart';

class LoansList extends StatefulWidget {
  const LoansList({
    super.key,
  });

  @override
  State<LoansList> createState() =>
      _LoansListState();
}

class _LoansListState extends State<LoansList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController =
        ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshLoans(
    BuildContext context,
  ) async {
    await context
        .read<LoanProvider>()
        .fetchLoans();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<LoanProvider>(
      builder: (
        context,
        provider,
        child,
      ) {
        /// Initial loading
        if (provider.isLoading &&
            provider.loans.isEmpty) {
          return const Center(
            child:
                CircularProgressIndicator(),
          );
        }

        return RefreshIndicator(
          onRefresh: () =>
              _refreshLoans(context),

          child: Scrollbar(
            controller:
                _scrollController,
            thumbVisibility: true,
            trackVisibility: true,
            thickness: 5,
            radius:
                const Radius.circular(10),

            child: ListView(
              controller:
                  _scrollController,

              physics:
                  const AlwaysScrollableScrollPhysics(),

              padding:
                  const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 2,
                bottom: 20,
              ),

              children: [
                /// Empty State
                if (provider.loans.isEmpty)
                  const SizedBox(
                    height: 250,
                    child: Center(
                      child: Text(
                        'No Loans Found',
                      ),
                    ),
                  ),

                /// Loan Cards
                if (provider.loans.isNotEmpty)
                  ...provider.loans.map(
                    (loan) {
                      return LoanCard(
                        loanId:
                            loan.loanId,
                        customer:
                            loan.customerName,
                        amount:
                            '₹ ${loan.loanAmount}',
                        date:
                            loan.dateOfApplication,
                        type:
                            loan.loanType,
                        status:
                            loan.status,
                        loanMethod:
                            loan.loanMethod,
                      );
                    },
                  ),

                /// Pagination
                /// This is now part of the scrollable
                /// content and will appear after
                /// the last loan card.
                if (provider.totalPages > 1)
                  Padding(
                    padding:
                        const EdgeInsets.only(
                      top: 4,
                      bottom: 8,
                    ),
                    child:
                        AppPagination(
                      currentPage:
                          provider.currentPage,
                      totalPages:
                          provider.totalPages,
                      isLoading:
                          provider.isLoading,
                      onPageChanged:
                          (page) {
                        provider
                            .goToPage(
                          page,
                        );

                        /// Move to top when
                        /// changing page
                        if (_scrollController
                            .hasClients) {
                          _scrollController
                              .animateTo(
                            0,
                            duration:
                                const Duration(
                              milliseconds:
                                  300,
                            ),
                            curve:
                                Curves.easeOut,
                          );
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}