import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mr_fincorp/FEATURES/Collections/data/model/collection_detail_model.dart';
import 'package:mr_fincorp/FEATURES/Collections/presentation/widgets collection detail page/header_card.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockUrlLauncherPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  String? launchedUrl;
  LaunchOptions? launchOptions;
  bool shouldSucceed = true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrl = url;
    launchOptions = options;
    return shouldSucceed;
  }
}

void main() {
  late MockUrlLauncherPlatform mockUrlLauncher;

  setUp(() {
    mockUrlLauncher = MockUrlLauncherPlatform();
    UrlLauncherPlatform.instance = mockUrlLauncher;
  });

  final sampleJson = {
    "id": 1,
    "loan_id": "IND01-LAT-00085",
    "customer_name": "Ramesh Kumar",
    "customer_phone": "9876543210",
    "customer_address": "45 Market Road, Kochi, Kerala",
    "customer_location": "https://maps.google.com/?q=9.931233,76.267303",
    "area": "Palarivattom",
    "branch_name": "Ernakulam",
    "loan_type": "WEEKLY",
    "loan_status": "OPEN",
    "loan_amount": "50000.00",
    "due_pending": 3,
    "principal_pending": "6000.00",
    "fine_pending": "200.00",
    "principal_paid": "44000.00",
    "fine_paid": "100.00",
    "balance_pending": "6200.00",
    "due_date": "2026-09-15",
    "installment_amount": "1000.00"
  };

  group('WhatsApp Reminder helper methods', () {
    test('cleanPhoneNumber formats 10-digit, 91 prefix, and handles edge cases', () {
      expect(CollectionDetailHeaderCard.cleanPhoneNumber('9876543210'), '919876543210');
      expect(CollectionDetailHeaderCard.cleanPhoneNumber('+91 98765 43210'), '919876543210');
      expect(CollectionDetailHeaderCard.cleanPhoneNumber('09876543210'), '919876543210');
      expect(CollectionDetailHeaderCard.cleanPhoneNumber('919876543210'), '919876543210');
      expect(CollectionDetailHeaderCard.cleanPhoneNumber('invalid'), '');
      expect(CollectionDetailHeaderCard.cleanPhoneNumber(''), '');
    });

    test('buildWhatsAppReminderMessage creates the required template with API values', () {
      final model = CollectionDetailModel.fromJson(sampleJson);
      final message = CollectionDetailHeaderCard.buildWhatsAppReminderMessage(model);

      expect(message, contains('Hello *Ramesh Kumar*,'));
      expect(
        message,
        contains(
          'This is a reminder from **Friends Fincorp** regarding your loan collection.',
        ),
      );
      expect(message, contains('* Loan ID: IND01-LAT-00085'));
      expect(message, contains('* Collection Date: 2026-09-15'));
      expect(message, contains('* Due Count: 3'));
      expect(message, contains('* Principal Balance: ₹6,000'));
      expect(message, contains('* Fine Balance: ₹200'));
      expect(message, contains('* Total Balance: ₹6,200'));
      expect(
        message,
        contains(
          'Please make your payment at the earliest. For any assistance, kindly contact our field staff.',
        ),
      );
      expect(message, contains('Thank you,\n**Friends Fincorp**'));

      // Check blank line separation and Malayalam translation
      expect(
        message,
        contains(
          '**Friends Fincorp**\n\nനമസ്കാരം *Ramesh Kumar*,',
        ),
      );
      expect(
        message,
        contains(
          'നിങ്ങളുടെ ലോൺ തിരിച്ചടവുമായി ബന്ധപ്പെട്ട് **Friends Fincorp**-ൽ നിന്നുള്ള ഒരു ഓർമ്മപ്പെടുത്തലാണിത്.',
        ),
      );
      expect(message, contains('* ലോൺ ഐഡി: IND01-LAT-00085'));
      expect(message, contains('* കളക്ഷൻ തീയതി: 2026-09-15'));
      expect(message, contains('* അടയ്ക്കാനുള്ള തവണകൾ: 3'));
      expect(message, contains('* പ്രിൻസിപ്പൽ ബാക്കി: ₹6,000'));
      expect(message, contains('* ഫൈൻ ബാക്കി: ₹200'));
      expect(message, contains('* ആകെ അടയ്ക്കാനുള്ള തുക: ₹6,200'));
      expect(
        message,
        contains(
          'ദയവായി നിങ്ങളുടെ തിരിച്ചടവ് എത്രയും വേഗം നടത്തുക. എന്തെങ്കിലും സഹായത്തിന് ഞങ്ങളുടെ ഫീൽഡ് സ്റ്റാഫുമായി ബന്ധപ്പെടുക.',
        ),
      );
      expect(message, contains('നന്ദി,\n**Friends Fincorp**'));
    });

    test('buildWhatsAppUri builds valid wa.me deep link with URL-encoded text', () {
      final model = CollectionDetailModel.fromJson(sampleJson);
      final message = CollectionDetailHeaderCard.buildWhatsAppReminderMessage(model);
      final uri = CollectionDetailHeaderCard.buildWhatsAppUri(model.customerPhone, message);

      expect(uri.scheme, 'https');
      expect(uri.host, 'wa.me');
      expect(uri.path, '/919876543210');
      expect(uri.queryParameters['text'], message);
    });
  });

  group('CollectionDetailHeaderCard WhatsApp UI tests', () {
    testWidgets('renders WhatsApp button beside phone number and Call button',
        (WidgetTester tester) async {
      final model = CollectionDetailModel.fromJson(sampleJson);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CollectionDetailHeaderCard(data: model),
            ),
          ),
        ),
      );

      final whatsappButton = find.byKey(const Key('whatsapp_button'));
      expect(whatsappButton, findsOneWidget);
      expect(find.text('Call'), findsOneWidget);

      // Verify WhatsApp green color (0xFF25D366)
      final container = tester.widget<Container>(
        find.descendant(
          of: whatsappButton,
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFF25D366));
    });

    testWidgets('tapping WhatsApp button launches WhatsApp deep link with externalApplication mode',
        (WidgetTester tester) async {
      final model = CollectionDetailModel.fromJson(sampleJson);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CollectionDetailHeaderCard(data: model),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('whatsapp_button')));
      await tester.pumpAndSettle();

      expect(mockUrlLauncher.launchedUrl, isNotNull);
      final launchedUri = Uri.parse(mockUrlLauncher.launchedUrl!);
      expect(launchedUri.scheme, 'https');
      expect(launchedUri.host, 'wa.me');
      expect(launchedUri.path, '/919876543210');
      expect(launchedUri.queryParameters['text'], contains('Hello *Ramesh Kumar*,'));
      expect(launchedUri.queryParameters['text'], contains('IND01-LAT-00085'));
      expect(launchedUri.queryParameters['text'], contains('₹6,000'));
      expect(mockUrlLauncher.launchOptions?.mode, PreferredLaunchMode.externalApplication);
    });

    testWidgets('shows fallback SnackBar when WhatsApp is not installed / launch fails',
        (WidgetTester tester) async {
      mockUrlLauncher.shouldSucceed = false;
      final model = CollectionDetailModel.fromJson(sampleJson);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CollectionDetailHeaderCard(data: model),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('whatsapp_button')));
      await tester.pump();

      expect(
        find.text('Could not open WhatsApp. Please check if WhatsApp is installed.'),
        findsOneWidget,
      );
    });

    testWidgets('hides WhatsApp and Call button when customer_phone is empty',
        (WidgetTester tester) async {
      final jsonNoPhone = Map<String, dynamic>.from(sampleJson);
      jsonNoPhone['customer_phone'] = '';
      final model = CollectionDetailModel.fromJson(jsonNoPhone);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CollectionDetailHeaderCard(data: model),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('whatsapp_button')), findsNothing);
      expect(find.text('Call'), findsNothing);
      expect(find.text('No phone number'), findsOneWidget);
    });
  });
}
