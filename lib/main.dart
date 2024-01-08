import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'importer.dart';

void main() async{
  final isar = await initIsar();  // Isarの初期化
  
  runApp(MyApp(isar: isar));
}

// Isarの初期化の処理
Future<Isar> initIsar() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory(); // ディレクトリの取得
  final isar = await Isar.open(   // Isarの初期化(開く/作成)
    [ItemModelSchema],
    directory: dir.path,
  );
  return isar;  // Isarのインスタンスを返す
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.isar,
  });
  
  final Isar isar;  // Isarのインスタンス

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(primary: Colors.blue),
        useMaterial3: true,
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      //themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}
