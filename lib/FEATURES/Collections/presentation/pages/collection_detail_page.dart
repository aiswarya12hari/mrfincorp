import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_model.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_submit_model.dart';
import 'package:mr_fincorp/FEATURES/Collections/provider/collection_submit_provider.dart';
import 'package:mr_fincorp/FEATURES/Collections/provider/collection_list_provider.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';
import '../widgets collection detail page/header_card.dart';
import '../widgets collection detail page/payment_collection_card.dart';
import '../widgets collection detail page/submit_collection_button.dart';
import 'collection_success_page.dart';

class CollectionDetailsPage extends StatefulWidget {
  final CollectionModel data;

  const CollectionDetailsPage({super.key, required this.data});

  @override
  State<CollectionDetailsPage> createState() => _CollectionDetailsPageState();
}

class _CollectionDetailsPageState extends State<CollectionDetailsPage> {
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;
  String _selectedPaymentMethod = 'CASH';

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final double amount = double.tryParse(_amountController.text.trim()) ?? 0;

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final provider = context.read<CollectionSubmitProvider>();

    final result = await provider.submitCollection(
      assignmentId: widget.data.assignmentId,
      data: CollectionSubmitRequestModel(
        amountCollected: amount,
        paymentMethod: _selectedPaymentMethod,
        feedback: _notesController.text.trim(),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      // Refresh the list so this item moves from Outstanding -> Collected.
      context.read<CollectionListProvider>().fetchCollections();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              CollectionSuccessPage(amountCollected: result.amountCollected),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? 'Submission failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        backgroundColor: AppColors.gray100,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.gray800),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Collection Details',
          style: AppTextStyles.pageTitle(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.gray800),
            onPressed: () {
              // TODO: show details menu (edit / delete / share, etc.)
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    CollectionDetailHeaderCard(data: widget.data),
                    const SizedBox(height: 16),
                    PaymentCollectionCard(
                      amountController: _amountController,
                      notesController: _notesController,
                      selectedPaymentMethod: _selectedPaymentMethod,
                      onPaymentMethodChanged: (method) {
                        setState(() => _selectedPaymentMethod = method);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: AppColors.gray100,
                border: Border(top: BorderSide(color: AppColors.borderColor)),
              ),
              child: Consumer<CollectionSubmitProvider>(
                builder: (context, provider, _) {
                  return SubmitCollectionButton(
                    onPressed: provider.isLoading ? null : _onSubmit,
                    isLoading: provider.isLoading,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
