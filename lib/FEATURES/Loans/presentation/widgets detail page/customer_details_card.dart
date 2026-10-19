import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../CORE/Theme/app_color.dart';
import '../../../../CORE/Theme/app_text_style.dart';
import '../../data/models/customer_model.dart';

class CustomerDetailsCard extends StatelessWidget {
  final CustomerModel customer;

  const CustomerDetailsCard({super.key, required this.customer});

  Future<void> openMap(String url) async {
    try {
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('MAP OPEN ERROR => $e');
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final trimmed = phoneNumber.trim();
    if (trimmed.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: trimmed);
    try {
      await launchUrl(uri);
    } catch (e) {
      debugPrint('CALL ERROR => $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressParts = [
      if (customer.fullAddress.trim().isNotEmpty) customer.fullAddress.trim(),
      if (customer.district.trim().isNotEmpty) customer.district.trim(),
      if (customer.state.trim().isNotEmpty) customer.state.trim(),
    ];
    var formattedAddress = addressParts.join(', ');
    if (customer.pinCode.trim().isNotEmpty) {
      formattedAddress = formattedAddress.isEmpty
          ? customer.pinCode.trim()
          : '$formattedAddress - ${customer.pinCode.trim()}';
    }
    if (formattedAddress.isEmpty) formattedAddress = '-';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            children: [
              Icon(
                Icons.assignment_ind_outlined,
                color: AppColors.secondaryDark,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Customer Details',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Accent underline
          Container(
            height: 2.5,
            width: 72,
            decoration: BoxDecoration(
              color: AppColors.secondaryDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 16),

          // Customer Profile Row
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.primaryLight,
                child: Icon(
                  Icons.person,
                  color: AppColors.secondaryDark,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name.isEmpty ? '-' : customer.name,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      customer.customerId.isEmpty ? '-' : customer.customerId,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        color: AppColors.textLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 0.8, color: AppColors.border),
          const SizedBox(height: 14),

          // Phone Number Row (with Call button on the right)
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone_outlined,
                  size: 17,
                  color: AppColors.secondaryDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phone Number',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 11,
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      customer.phone.isEmpty ? '-' : customer.phone,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (customer.phone.trim().isNotEmpty)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => makePhoneCall(customer.phone),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryDark,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondaryDark.withValues(
                              alpha: 0.28,
                            ),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.call, size: 13, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            'Call',
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 0.8, color: AppColors.border),
          const SizedBox(height: 14),

          // Occupation Row
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.work_outline_rounded,
                  size: 17,
                  color: AppColors.secondaryDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Occupation',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 11,
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      customer.occupation.isEmpty ? '-' : customer.occupation,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 0.8, color: AppColors.border),
          const SizedBox(height: 14),

          // Address Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  size: 17,
                  color: AppColors.secondaryDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Address',
                      style: TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 11,
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formattedAddress,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Selected Location Card
          if (customer.googleMapLink.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.map_outlined,
                      size: 16,
                      color: AppColors.secondaryDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Location',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        InkWell(
                          onTap: () => openMap(customer.googleMapLink),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  'Open in Google Maps',
                                  style: TextStyle(
                                    fontFamily: AppTextStyles.fontFamily,
                                    color: AppColors.secondaryDark,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 3),
                              Icon(
                                Icons.open_in_new,
                                size: 12,
                                color: AppColors.secondaryDark,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          customer.googleMapLink,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 9.5,
                            color: AppColors.textLight,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => openMap(customer.googleMapLink),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 66,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(66, 50),
                            painter: _MiniMapPainter(),
                          ),
                          const Icon(
                            Icons.location_on,
                            color: AppColors.error,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFE8F5E9);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final waterPaint = Paint()..color = const Color(0xFFC7E8F8);
    final waterPath = Path()
      ..moveTo(size.width * 0.72, 0)
      ..quadraticBezierTo(
        size.width * 0.55,
        size.height * 0.45,
        size.width,
        size.height * 0.6,
      )
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(waterPath, waterPaint);

    final parkPaint = Paint()..color = const Color(0xFFCEEBD0);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(4, 4, size.width * 0.38, size.height * 0.42),
        const Radius.circular(4),
      ),
      parkPaint,
    );

    final roadBorderPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.5
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(0, size.height * 0.35)
      ..lineTo(size.width, size.height * 0.75);
    canvas.drawPath(path1, roadBorderPaint);
    canvas.drawPath(path1, roadPaint);

    final path2 = Path()
      ..moveTo(size.width * 0.35, 0)
      ..lineTo(size.width * 0.65, size.height);
    canvas.drawPath(path2, roadBorderPaint);
    canvas.drawPath(path2, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
