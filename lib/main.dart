import'package:flutter/material.dart';
import 'package:browser_app/screen/home/provider/home_provider.dart';
import 'package:browser_app/utils/app_route.dart';
import 'package:provider/provider.dart';
void main()
{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: HomeProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes:app_route,
        ),
      )
  );
}