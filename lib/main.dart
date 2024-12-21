import 'package:flutter/material.dart';
import 'package:pokechainhelper/screens/waller_form_screen.dart';
import 'providers/pokemon_provider.dart';
import 'providers/guide_provider.dart';
import 'screens/home_screen.dart';
import 'screens/pokemon_cards_screen.dart';
import 'screens/guide_screen.dart';
import 'screens/stats_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(PokeChainHelperApp());
}

class PokeChainHelperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PokemonProvider()),
        ChangeNotifierProvider(create: (_) => GuideProvider()),
      ],
      child: MaterialApp(
        title: 'PokeChain Helper',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/pokemon_cards': (context) => PokemonCardsScreen(),
          '/guide': (context) => GuideScreen(),
          '/stats': (context) => StatsScreen(),
          '/wallet': (context) => WalletFormScreen(),
        },
      ),
    );
  }
}
