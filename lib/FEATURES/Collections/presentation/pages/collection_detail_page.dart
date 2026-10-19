
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
import '../Widgets/collection_shimmer.dart';
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

    if (amount < 0) {
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Center(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF0F172A),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Collection Details',
          style: AppTextStyles.pageTitle(context).copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                child: Column(
                  children: [
                    if (_isLoadingDetail)
                      const CollectionDetailShimmer()
                    else ...[
                      if (_detail != null) ...[
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
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
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
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                border: const Border(
                  top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F2A38).withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
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