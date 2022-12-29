import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

enum MajorDimension { COLUMNS, ROWS }

enum ValueInputOption { USER_ENTERED, RAW }

enum InsertDataOption { OVERWRITE, INSERT_ROWS }

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

class HomeController extends GetxController {
  static const pageSize = 15;
  int currentPage = 0;
  var clase = "".obs;
  var detalle = "".obs;
  var tamano = "".obs;
  var detalles = [
    "",
    "VISO",
    "SECO",
    "SECO B",
    "SECO PEQ B",
    "LIGERO",
    "SECO PEQUEÑO",
    "REZAGO DE CAPA"
  ].obs;
  var variedad = "".obs;
  var clases = ["TRIPA", "BANDA", ""].obs;
  var variedades = ["HABANO", "COROJO", "PINAREÑO", "2000", ""].obs;
  void setCurrentPage(int value) {
    currentPage = value;
    update();
  }

  final almacenCtrl = PagingController<int, List>(firstPageKey: 15);
  String? username;
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
    "https://www.googleapis.com/auth/spreadsheets",
    "https://www.googleapis.com/auth/drive"
  ]);
  GoogleSignInAccount? account;
  String sheetsBaseUrl =
      "https://sheets.googleapis.com/v4/spreadsheets/1JclMAI-mNBW_eYIzurnStq-1b0r1aPZbU7nQPtnQTnE";
  String spreadsheetId = "1JclMAI-mNBW_eYIzurnStq-1b0r1aPZbU7nQPtnQTnE";

  @override
  void onInit() {
    googleSignIn.onCurrentUserChanged.listen((account_) {
      if (account_ != null) {
        account = account_;
        final idx = account!.email.indexOf("@");
        username = account!.displayName ?? account!.email.substring(0, idx);
        update();
      }
    });
    googleSignIn.signInSilently();
    almacenCtrl.addPageRequestListener((pageKey) {
      fetchPage(sheet: "almacen", pageKey: pageKey, left: "A", right: "Z");
    });
    super.onInit();
  }

  @override
  void onClose() {
    almacenCtrl.dispose();
    super.onClose();
  }

  Future<void> signIn() async {
    try {
      googleSignIn.signIn();
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() => googleSignIn.disconnect();

  Future<void> fetchPage(
      {required String sheet,
      required String left,
      required String right,
      required int pageKey}) async {
    try {
      final start =
          almacenCtrl.itemList != null ? almacenCtrl.itemList!.length : 0;

      final range = "$sheet!$left${start + 1}:$right${pageKey + 1}";
      print("range: $range");
      final newItems = await getSheet(range: range, removeFirst: false);
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        almacenCtrl.appendLastPage(newItems);
        return;
      }
      final nextPageKey = pageKey + newItems.length;
      almacenCtrl.appendPage(newItems, nextPageKey);
    } catch (e) {
      print(e);
      almacenCtrl.error = e;
    }
  }

  Future<String> sendSheet({
    required String range,
    required List data,
    ValueInputOption valueInputOption = ValueInputOption.USER_ENTERED,
    InsertDataOption insertdataOption = InsertDataOption.OVERWRITE,
  }) async {
    try {
      if (account == null) {
        throw "Aun no has iniciado session";
      }
      final res = await http.post(
        Uri.parse(
            "$sheetsBaseUrl/values/$range:append?valueInputOption=${valueInputOption.name}&insertDataOption=${insertdataOption.name}"),
        headers: await account!.authHeaders,
        body: jsonEncode(
          {
            "values": [data]
          },
        ),
      );
      if (res.statusCode != 200) {
        print(res.body);
        throw "Ups ha ocurrido un error ${res.statusCode}";
      }
      return "Datos enviados con exito";
    } catch (e) {
      rethrow;
    }
  }

  Future<List<List>> getSheet({
    required String range,
    MajorDimension majorDimension = MajorDimension.ROWS,
    reversed = true,
    removeFirst = true,
  }) async {
    try {
      if (account == null) {
        throw "Aun no has iniciado session";
      }
      final res = await http.get(
          Uri.parse(
              "$sheetsBaseUrl/values/$range?majorDimension=${majorDimension.name}"),
          headers: await account!.authHeaders);
      if (res.statusCode != 200) {
        print(res.body);
        throw "Ups ha ocurrido un error ${res.statusCode}";
      }
      final data = jsonDecode(res.body);
      final values = List.from(data["values"]);
      print("${values.length} items loaded");
      if (removeFirst) {
        values.removeAt(0);
      }
      if (reversed) {
        return values.reversed.toList().cast();
      }
      return values.cast();
    } catch (e) {
      rethrow;
    }
  }
}
