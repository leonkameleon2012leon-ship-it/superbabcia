import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'babcia_state.dart';
import 'ekrany/powitanie.dart';
import 'ekrany/tablica_glowna.dart';

void main() => runApp(const ApkaBabci());

class ApkaBabci extends StatelessWidget {
  const ApkaBabci({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StanAplikacji(),
      child: MaterialApp(
        title: 'Superbabcia',
        debugShowCheckedModeBanner: false,
        theme: _tworzMotyw(),
        home: const KontrolerWitamy(),
      ),
    );
  }

  ThemeData _tworzMotyw() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF8C00),
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 38, fontWeight: FontWeight.w700, letterSpacing: 0.5),
        headlineMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 22, height: 1.6),
        bodyMedium: TextStyle(fontSize: 20, height: 1.5),
        labelLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class KontrolerWitamy extends StatefulWidget {
  const KontrolerWitamy({super.key});

  @override
  State<KontrolerWitamy> createState() => _StanKontrolera();
}

class _StanKontrolera extends State<KontrolerWitamy> {
  bool _pokazujPowitanie = true;

  @override
  Widget build(BuildContext context) {
    return _pokazujPowitanie
        ? EkranPowitania(
            przejdzDalej: () => setState(() => _pokazujPowitanie = false),
          )
        : const TablicaGlowna();
  }
}
