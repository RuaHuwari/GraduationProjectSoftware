import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
        SnackBar(content: Text('Error fetching document: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Uint8List> _fetchImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
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

  Future<Uint8List> _createPdf() async {
    if (_documentData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No document data to generate PDF')),
      );
      throw Exception('No document data to generate PDF');
    }

    final pdf = pw.Document();

    // Fetch images and generate widgets in advance
    final List<pw.Widget> imageWidgets = [];
    final Map<String, dynamic> textData = {};
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
            pw.Text('Application Report', style: pw.TextStyle(fontSize: 20)),
          ],
        ),
      );
    }
    _documentData!.forEach((key, value) {
      if (Uri.tryParse(value.toString())?.hasAbsolutePath == true) {
        imageWidgets.add(pw.Text('$key: Loading image...'));
        _fetchImage(value.toString()).then((imageData) {
          final image = pw.MemoryImage(imageData);
          setState(() {
            imageWidgets.removeLast();
            imageWidgets.add(pw.Image(image));
          });
        }).catchError((e) {
          setState(() {
            imageWidgets.removeLast();
            imageWidgets.add(pw.Text('$key: Failed to load image'));
          });
        });
      } else {
        textData[key] = value;
      }
    });

    // Get application ID
    final applicationId = int.tryParse(_documentData?['applicationID']?.toString() ?? '0') ?? 0;

    // Add the first page with the table
    pdf.addPage(
      pw.MultiPage(
        header: header,
        build: (pw.Context context) {
          return [pw.Table(
            border: pw.TableBorder.all(),
            children: _buildRows(applicationId, textData),
          )
          ];
        },
      ),
    );

    // Add the pages with images
    for (int i = 0; i < imageWidgets.length; i += 2) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: [
                imageWidgets[i],
                if (i + 1 < imageWidgets.length) ...[
                  pw.SizedBox(height: 20),
                  imageWidgets[i + 1],
                ],
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  Future<void> _downloadPdf() async {
    try {
      final pdfData = await _createPdf();

      Directory? downloadsDirectory;
      if (Platform.isAndroid) {
        downloadsDirectory = await getExternalStorageDirectory();
        // Use a specific directory path if needed, for example: '/storage/emulated/0/Download'
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        downloadsDirectory = await getDownloadsDirectory();
      }

      if (downloadsDirectory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to get the downloads directory')),
        );
        return;
      }

      final file = File('${downloadsDirectory.path}/report.pdf');
      await file.writeAsBytes(pdfData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved to ${file.path}')),
      );
    } catch (e) {
      print('Error generating PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                fetchDocumentById(widget.id);
              },
              child: Text('Fetch Document'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator() // Show loading indicator while fetching data
                : _documentData != null
                ? Center(child: Text('Your Report is Ready, To download it press on the button at the bottom right corner of the page'))
                : Center(child: Text('No data to display')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _downloadPdf,
        child: Icon(Icons.download),
      ),
    );
  }
}
