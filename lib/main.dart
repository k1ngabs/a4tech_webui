import 'package:a4tech_webui/providers/chat_provider.dart';
import 'package:a4tech_webui/providers/model_provider.dart';
import 'package:a4tech_webui/providers/notes_provider.dart';
import 'package:a4tech_webui/providers/system_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:a4tech_webui/providers/theme_provider.dart';
import 'package:a4tech_webui/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);



  TextTheme _getFontTextTheme(AppFont font, Brightness brightness) {

    switch (font) {

      case AppFont.poppins:

        return GoogleFonts.poppinsTextTheme(ThemeData(brightness: brightness).textTheme);

      case AppFont.sora:

        return GoogleFonts.soraTextTheme(ThemeData(brightness: brightness).textTheme);

      case AppFont.roboto:

        return GoogleFonts.robotoTextTheme(ThemeData(brightness: brightness).textTheme);

      case AppFont.lato:

        return GoogleFonts.latoTextTheme(ThemeData(brightness: brightness).textTheme);

    }

  }



  @override

  Widget build(BuildContext context) {

    return MultiProvider(

      providers: [

        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        ChangeNotifierProvider(create: (_) => ModelProvider()),

        ChangeNotifierProvider(create: (_) => ChatProvider()),

        ChangeNotifierProvider(create: (_) => NotesProvider()),

        ChangeNotifierProvider(create: (_) => SystemProvider()),

      ],

      child: Consumer<ThemeProvider>(

        builder: (context, themeProvider, child) {

          return MaterialApp(

            title: '4Tech WebUI',

            theme: ThemeData(

              brightness: Brightness.light,

              primarySwatch: Colors.blue,

              textTheme: _getFontTextTheme(themeProvider.font, Brightness.light),

            ),

            darkTheme: ThemeData(

              brightness: Brightness.dark,

              primarySwatch: Colors.blue,

              textTheme: _getFontTextTheme(themeProvider.font, Brightness.dark),

            ),

            themeMode: themeProvider.themeMode,

            home: const HomeScreen(),

          );

        },

      ),

    );

  }

}