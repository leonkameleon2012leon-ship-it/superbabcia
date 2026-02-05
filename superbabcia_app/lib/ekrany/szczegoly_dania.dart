import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../babcia_state.dart';

class EkranSzczegolow extends StatelessWidget {
  final Danie danie;

  const EkranSzczegolow({super.key, required this.danie});

  @override
  Widget build(BuildContext kontekst) {
    final formatCzasu = DateFormat('HH:mm');

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E6),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Szczegóły posiłku',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_rounded, size: 30),
            onPressed: () => _potwierdzUsuniecie(kontekst),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _budujKarteGlowna(formatCzasu),
            const SizedBox(height: 26),
            _budujNaglowekSekcji('Składniki:'),
            const SizedBox(height: 14),
            _budujListeSkladnikow(),
            const SizedBox(height: 26),
            _budujPrzelacznikPowiadomien(kontekst),
          ],
        ),
      ),
    );
  }

  Widget _budujKarteGlowna(DateFormat formatCzasu) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [Colors.orange.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  danie.typ.emoji(),
                  style: const TextStyle(fontSize: 54),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        danie.typ.nazwaPoPolsku(),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.deepOrange.shade700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        formatCzasu.format(danie.kiedy),
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade300,
                    Colors.orange.shade100,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              danie.nazwa,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _budujNaglowekSekcji(String tekst) {
    return Text(
      tekst,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: Colors.deepOrange.shade700,
      ),
    );
  }

  Widget _budujListeSkladnikow() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: danie.skladniki.map((skladnik) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green.shade600,
                    size: 26,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      skladnik.opis,
                      style: const TextStyle(
                        fontSize: 22,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _budujPrzelacznikPowiadomien(BuildContext kontekst) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        title: const Text(
          'Powiadomienia',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text(
            'Przypomnij 15 minut przed posiłkiem',
            style: TextStyle(fontSize: 20),
          ),
        ),
        secondary: Icon(
          danie.przypominaj ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
          size: 40,
          color: Colors.deepOrange.shade600,
        ),
        value: danie.przypominaj,
        activeColor: Colors.deepOrange.shade600,
        onChanged: (_) {
          final stan = kontekst.read<StanAplikacji>();
          stan.przelaczPrzypomnienie(danie.id);
        },
      ),
    );
  }

  void _potwierdzUsuniecie(BuildContext kontekst) {
    showDialog(
      context: kontekst,
      builder: (dialogKontekst) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Usunąć posiłek?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Czy na pewno chcesz usunąć "${danie.nazwa}"?',
            style: const TextStyle(fontSize: 22),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogKontekst).pop(),
              child: Text(
                'Anuluj',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final stan = kontekst.read<StanAplikacji>();
                stan.usunDanie(danie.id);
                Navigator.of(dialogKontekst).pop();
                Navigator.of(kontekst).pop();
              },
              child: const Text(
                'Usuń',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
