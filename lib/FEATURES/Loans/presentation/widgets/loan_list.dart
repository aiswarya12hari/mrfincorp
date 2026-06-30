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
//   Widget build(BuildContext context) {
//     return Consumer<LoanProvider>(
//       builder: (context, provider, child) {
//         if (provider.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (provider.loans.isEmpty) {
//           return const Center(child: Text('No Loans Found'));
//         }

//         return ListView.builder(
//           controller: _scrollController,
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           itemCount: provider.loans.length + (provider.hasMore ? 1 : 0),
//           itemBuilder: (context, index) {
//             if (index == provider.loans.length) {
//               return const Padding(
//                 padding: EdgeInsets.all(20),
//                 child: Center(child: CircularProgressIndicator()),
//               );
//             }

//             final loan = provider.loans[index];

//             return LoanCard(
//               loanId: loan.loanId,
//               customer: loan.customerName,
//               amount: '₹ ${loan.loanAmount}',
//               date: loan.dateOfApplication,
//               type: loan.loanType,
//               status: loan.status,
//               loanMethod: loan.loanMethod,
//             );
//           },
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/loan_provider.dart';
import 'loan_card.dart';

class LoansList extends StatefulWidget {
  const LoansList({super.key});

  @override
  State<LoansList> createState() => _LoansListState();
}

class _LoansListState extends State<LoansList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<LoanProvider>().loadMoreLoans();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshLoans() async {
    await context.read<LoanProvider>().fetchLoans();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoanProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.loans.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshLoans,
          child: provider.loans.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 250),
                    Center(
                      child: Text(
                        'No Loans Found',
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount:
                      provider.loans.length + (provider.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == provider.loans.length) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final loan = provider.loans[index];

                    return LoanCard(
                      loanId: loan.loanId,
                      customer: loan.customerName,
                      amount: '₹ ${loan.loanAmount}',
                      date: loan.dateOfApplication,
                      type: loan.loanType,
                      status: loan.status,
                      loanMethod: loan.loanMethod,
                    );
                  },
                ),
        );
      },
    );
  }
}