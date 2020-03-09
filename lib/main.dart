import 'package:flutter/material.dart';
import 'package:pray/features/presentation/bloc/bloc.dart';
import 'package:pray/features/presentation/widgets/azan_menu_tile.dart';
import 'package:pray/features/presentation/widgets/loading_Indicator.dart';
import 'package:pray/service_locator.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DayTimings>.value(
      value: sl<DayTimings>(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<DayTimings>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          Opacity(
            opacity: 0.4,
            child: Image.asset(
              "assets/images/mosque.jpg",
              fit: BoxFit.fill,
            ),
          ),
         model.isLoading == true?
         LoadingIndicator():
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AzanTileMenu(),
          ) ,
        ],
      ),
    );
  }
}

