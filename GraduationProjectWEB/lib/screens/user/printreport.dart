import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:graduationprojectweb/widgets/AppBar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:archive/archive.dart'; // Import the archive.dart package

Map<String, Map<String, String>> translations = {
  'en': {
    'fetch_document': 'Fetch Document',
    'no_data': 'No data to display',
    'report_ready': 'Your Report is Ready, To download it press on the Download Button',
    'extract_report': 'Extract Report',
    'loading': 'Loading...',
    'application_report': 'Application Report',
    'error_fetching': 'Error fetching document: ',
    'error_creating_pdf': 'Error creating PDF: ',
    'download_error': 'Failed to load image',
    'download_document': 'Download Document'
  },
  'ar': {
    'fetch_document': 'جلب المستند',
    'no_data': 'لا توجد بيانات للعرض',
    'report_ready': 'تقريرك جاهز، لتنزيله اضغط على زر التنزيل',
    'extract_report': 'استخراج التقرير',
    'loading': 'جاري التحميل...',
    'application_report': 'تقرير التطبيق',
    'error_fetching': 'خطأ في جلب المستند: ',
    'error_creating_pdf': 'خطأ في إنشاء PDF: ',
    'download_error': 'فشل في تحميل الصورة',
    'download_document':'تنزيل المستند'
  },
};

class PrintReport extends StatefulWidget {
  PrintReport({
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.id,
  });

  final String userId;
  final String firstname;
  final String lastname;
  final String id;

  @override
  State<PrintReport> createState() => _PrintReportState();
}

class _PrintReportState extends State<PrintReport> {
  Map<String, dynamic>? _documentData;
  bool _isLoading = false;
  String _currentLanguage = 'en';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchDocumentById(String documentId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await _firestore.collection("IDApplications").where('id', isEqualTo: documentId).get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _documentData = querySnapshot.docs.first.data();
        });
      } else {
        throw Exception('Document not found');
      }
    } catch (e) {
      print('Error fetching document: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${translations[_currentLanguage]!['error_fetching']}$e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Uint8List> _fetchImage(String imageUrl) async {
    const int maxRetries = 3;
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final response = await html.HttpRequest.request(
          imageUrl,
          responseType: 'arraybuffer',
        );

        // Convert NativeByteBuffer to Uint8List
        final buffer = response.response as ByteBuffer;
        return buffer.asUint8List();

      } catch (e) {
        if (attempt == maxRetries) {
          print('Failed to load image after $attempt attempts: $e');
          throw Exception('${translations[_currentLanguage]!['download_error']}: $e');
        }
        print('Retry $attempt failed for $imageUrl: $e');
      }
    }
    throw Exception('${translations[_currentLanguage]!['download_error']}');
  }


  List<pw.TableRow> _buildRows(int applicationId, Map<String, dynamic> data) {
    List<Map<String, dynamic>> arrangement = [];

    if (applicationId == 1 || applicationId == 3 || applicationId == 4) {
      arrangement = [
        {'FirstName': data['FirstName'], 'FatherName': data['FatherName']},
        {'GrandFatherName': data['GrandFatherName'], 'LastName': data['LastName']},
        {'MotherName': data['MotherName'], 'DateOfBirth': data['DateOfBirth']},
        {'PhoneNumber': data['PhoneNumber'], 'LandLine': data['LandLine']},
        {'user_id': data['user_id'], 'ApplicantID': data['ApplicantID']},
        {'Religion': data['Religion'], 'Gender': data['Gender']},
        {'PlaceOfBirth': data['PlaceOfBirth'], 'Governate': data['Governate']},
        {'StreetOrVillage': data['StreetOrVillage'], 'Address': data['Address']},
        {'MaritalStatus': data['MaritalStatus'], 'PreviousFamilyName': data['PreviousFamilyName']},
        {'PartnerName': data['PartnerName'], 'PartnerPreviousFamilyName': data['PartnerPreviousFamilyName']},
        {'partnerPassportType': data['partnerPassportType'], 'PartnerPAssportNumber': data['PartnerPAssportNumber']},
        {'PartnerID': data['PartnerID'], '': ''},
      ];
    } else if (applicationId == 2 || applicationId == 7 || applicationId == 8) {
      arrangement = [
        {'FirstName': data['FirstName'], 'FatherName': data['FatherName']},
        {'GrandFatherName': data['GrandFatherName'], 'LastName': data['LastName']},
        {'MotherName': data['MotherName'], 'DateOfBirth': data['DateOfBirth']},
        {'user_id': data['user_id'], 'ApplicantID': data['ApplicantID']},
        {'Career': data['Career'], 'Address': data['Address']},
        {'PhoneNumber': data['PhoneNumber'], 'Gender': data['Gender']},
        {'PlaceOfBirth': data['PlaceOfBirth'], '': ''},
      ];
    } else if (applicationId == 9) {
      arrangement = [
        {'FirstName': data['FirstName'], 'FatherName': data['FatherName']},
        {'GrandFatherName': data['GrandFatherName'], 'LastName': data['LastName']},
        {'Gender': data['Gender'], 'PhoneNumber': data['PhoneNumber']},
        {'user_id': data['user_id'], 'ApplicantID': data['ApplicantID']},
        {'License Type': data['License Type'], 'DateOfBirth': data['DateOfBirth']},
        {'Address': data['Address'], '': ''},
      ];
    } else {
      for (var entry in data.entries) {
        if (entry.key != 'applicationID') {
          arrangement.add({entry.key: entry.value});
        }
      }
    }

    return arrangement.map((entry) {
      final keys = entry.keys.toList();
      return pw.TableRow(
        children: [
          pw.Container(
            color: PdfColors.purple,
            padding: pw.EdgeInsets.all(4),
            child: pw.Text(
              keys[0],
              style: pw.TextStyle(color: PdfColors.white),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.all(4),
            child: pw.Text(entry[keys[0]]?.toString() ?? ''),
          ),
          pw.Container(
            color: PdfColors.purple,
            padding: pw.EdgeInsets.all(4),
            child: pw.Text(
              keys.length > 1 ? keys[1] : '',
              style: pw.TextStyle(color: PdfColors.white),
            ),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.all(4),
            child: pw.Text(keys.length > 1 ? entry[keys[1]]?.toString() ?? '' : ''),
          ),
        ],
      );
    }).toList();
  }

  Future<void> createAndDownloadPdfAndZip() async {
    if (_documentData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(translations[_currentLanguage]!['no_data']!)),
      );
      return;
    }

    try {
      final pdf = pw.Document();

      // Load logo from assets
      final ByteData data = await rootBundle.load('assets/Logo.png');
      final Uint8List logoBytes = data.buffer.asUint8List();

      pw.Widget header(pw.Context context) {
        return pw.Header(
          level: 0,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(pw.MemoryImage(logoBytes), height: 40),
              pw.Text(translations[_currentLanguage]!['application_report']!, style: pw.TextStyle(fontSize: 20)),
            ],
          ),
        );
      }

      // Get application ID
      final applicationId = int.tryParse(_documentData?['applicationID']?.toString() ?? '0') ?? 0;

      // Add the first page with the table
      pdf.addPage(
        pw.MultiPage(
          header: header,
          build: (pw.Context context) => [
            pw.Table(
              border: pw.TableBorder.all(),
              children: _buildRows(applicationId, _documentData!),
            ),
          ],
        ),
      );

      // Save the PDF
      final pdfBytes = await pdf.save();

      // Create ZIP file
      final archive = Archive();

      // Add PDF to the archive
      archive.addFile(ArchiveFile('document.pdf', pdfBytes.length, pdfBytes));

      // Add images to the archive
      for (var entry in _documentData!.entries) {
        if (Uri.tryParse(entry.value.toString())?.hasAbsolutePath == true) {
          try {
            final imageBytes = await _fetchImage(entry.value.toString());
            archive.addFile(ArchiveFile('${entry.key}.jpg', imageBytes.length, imageBytes));
          } catch (e) {
            print('Error downloading image: $e');
          }
        }
      }

      // Encode the archive to ZIP
      final zipBytes = ZipEncoder().encode(archive)!;

      // Create and download the ZIP file
      final blob = html.Blob([zipBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      downloadFile('document_and_images.zip', url);
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print('Error creating ZIP: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${translations[_currentLanguage]!['error_creating_pdf']}$e')),
      );
    }
  }

  void downloadFile(String fileName, String url) {
    final anchorElement = html.AnchorElement(href: url);
    anchorElement.setAttribute("download", fileName);
    anchorElement.click();
  }

  String getText(String key) {
    return translations[_currentLanguage]![key]!;
  }

  bool isEnglish = true;

  void _toggleLanguage() {
    setState(() {
      isEnglish = !isEnglish;
      _currentLanguage = _currentLanguage == 'en' ? 'ar' : 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildabbbar.buildAbbbar(
        context,
        isEnglish ? 'Print Report' : 'طباعة الطلب',
        widget.userId,
        widget.firstname,
        widget.lastname,
        isEnglish,
        _toggleLanguage,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Information Card on the left side
            Expanded(
              flex: 2,
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/upload.png',
                        height: 200,
                      ),
                      SizedBox(height: 50),
                      Text(
                        isEnglish?'PalEase Provide you with the option of Downloading and accessing the application you have submitted, press on fetch document, then when it says that you document is ready, press on the Download button.':'باليز يوفر لك امكانية مراجعة الطلبات اللتي قمت بتقديمها، حتى تستطيع تنزيل الطلب الخاص بك قم بالضغط على زر احضار المستند، ثم على زر التنزيل.',
                        style: TextStyle(color: Colors.purple, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            // Buttons on the right side
            Expanded(
              flex:2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        fetchDocumentById(widget.id);
                      },
                      child: Text(getText('fetch_document'), style: TextStyle(color: Colors.purple)),
                    ),
                  ),
                  SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator() // Show loading indicator while fetching data
                      : _documentData != null
                      ? Center(child: Text(getText('report_ready')))
                      : Center(child: Text(getText('no_data'))),
                  SizedBox(height: 30),
                  Container(
                    height: 100,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        createAndDownloadPdfAndZip();
                      },
                      child: Text(getText('download_document'), style: TextStyle(color: Colors.purple)),
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
