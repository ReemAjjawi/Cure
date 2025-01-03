import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

import '../../../../../../config/handle_model.dart';
import '../../pdf_model.dart';
import '../../service.dart';
import 'pdf_event.dart';
import 'pdf_state.dart';

class PdfBloc extends Bloc<PdfEvent, PdfState> {
  PdfBloc() : super(PdfLoading()) {
    on<GetPdf>((event, emit) async {
      try {
        print("my");
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult.contains(ConnectivityResult.none)) {
          // No internet, get the PDF from Hive
          print("hi");
          final pdfBox = await Hive.openBox('pdfBox');
          final pdfBytes = pdfBox.get('${event.index}_bytes');
          final fileName = pdfBox.get('${event.index}_fileName');

          if (pdfBytes != null && fileName != null) {
            // Write the file locally for immediate use
            final dir = await getApplicationDocumentsDirectory();
            final file = File('${dir.path}/$fileName');
            if (!file.existsSync()) {
              await file.writeAsBytes(pdfBytes, flush: true);
            }
            emit(showpdf(pfile: file));
          } else {
            emit(FailurePdfState(
                message: "No internet and PDF not found locally."));
          }
          return;
        }

        SuccessSituation response = await PdfServiceImp().getPdf(event.index);
        if (response is DataSuccessObject<PdfModel>) {
       //   emit(PdfFile(pdf: response.data));
          print(response.data);
          print("success");
          var box = Hive.box('projectBox');
          final responsee = await http.get(Uri.parse(response.data.file_url),
              headers: {"Authorization": "Bearer ${box.get('token')}"});

          final Uint8List bytes = responsee.bodyBytes;

          // Save the PDF data (bytes and file name) in Hive
          final pdfBox = await Hive.openBox('pdfBox');
          await pdfBox.put('${event.index}_bytes', bytes);
          await pdfBox.put('${event.index}_fileName', response.data.file_name);

          final dir = await getApplicationDocumentsDirectory();
          var file = File('${dir.path}/${response.data.file_name}');
          await file.writeAsBytes(bytes, flush: true);
          print('File saved at: ${file.path}');
          print(file);
          print('File exists: ${file.existsSync()}');

          emit(showpdf(pfile: file));
        }
      } on DioException catch (e) {
        print(e);
        emit(FailurePdfState(message: e.message!));
      }
    });
  }
}

Future<File> getPdfFromHive(String fileName) async {
  final pdfBox = await Hive.openBox('pdfBox');
  final Uint8List? bytes = pdfBox.get(fileName);

  if (bytes != null) {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    if (!file.existsSync()) {
      await file.writeAsBytes(bytes, flush: true);
    }
    return file;
  } else {
    throw Exception('PDF not found in Hive');
  }
}
