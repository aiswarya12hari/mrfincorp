
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_model.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_detail_model.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_submit_model.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/services/collection_service.dart';
import 'package:mr_fincorp/FEATURES/Collections/provider/collection_submit_provider.dart';
import 'package:mr_fincorp/FEATURES/Collections/provider/collection_list_provider.dart';
import 'package:mr_fincorp/FEATURES/Collections/provider/collected_list_provider.dart';

import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';
import '../widgets collection detail page/header_card.dart';
import '../widgets collection detail page/customer_verification_images_section.dart';
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

  final CollectionService _collectionService = CollectionService();
  CollectionDetailModel? _detail;
  bool _isLoadingDetail = true;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      final detail = await _collectionService.getCollectionDetail(
        widget.data.assignmentId,
      );
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _isLoadingDetail = false;
      });
    } catch (e) {
      debugPrint('COLLECTION DETAIL FETCH ERROR => $e');
      if (!mounted) return;
      setState(() {
        _isLoadingDetail = false;
      });
    }
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
      // Invalidate and sync lists immediately:
      context.read<CollectionListProvider>().onCollectionSubmitted(
        widget.data.assignmentId,
      );
      context.read<CollectedListProvider>().fetchCollected();

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
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    if (_isLoadingDetail)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (_detail != null) ...[
                      CollectionDetailHeaderCard(data: _detail!),
                      if (_detail!.customerImages.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        CustomerVerificationImagesSection(
                          images: _detail!.customerImages,
                        ),
                      ],
                    ] else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Unable to load full loan details.',
                          style: AppTextStyles.fieldValue(context),
                        ),
                      ),
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