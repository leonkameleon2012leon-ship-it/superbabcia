import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../babcia_state.dart';
import 'dodaj_danie.dart';
import 'szczegoly_dania.dart';

class TablicaGlowna extends StatelessWidget {
  const TablicaGlowna({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Soft white background
      appBar: AppBar(
        backgroundColor: Colors.pink.shade600, // Pink instead of orange
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Moje Posiłki',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ),
      body: Consumer<StanAplikacji>(
        builder: (kontekst, stan, _) {
          final dzisiejszeDania = stan.pobierzNaDzis();

          if (dzisiejszeDania.isEmpty) {
            return _budujPustyWidok();
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            itemCount: dzisiejszeDania.length,
            separatorBuilder: (_, __) => const SizedBox(height: 18),
            itemBuilder: (kontekst, indeks) {
              // Add staggered animations to meal cards
              return KartaDania(danie: dzisiejszeDania[indeks])
                  .animate()
                  .fadeIn(duration: 400.ms, delay: (100 * indeks).ms)
                  .slideX(begin: 0.2, end: 0, duration: 400.ms, delay: (100 * indeks).ms);
            },
          );
        },
      ),
      floatingActionButton: _budujPrzyciskDodawania(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _budujPustyWidok() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu_rounded,
            size: 110,
            color: Colors.pink.shade300, // Pink instead of orange
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(duration: 2000.ms, begin: const Offset(1.0, 1.0), end: const Offset(1.1, 1.1))
              .then()
              .scale(duration: 2000.ms, begin: const Offset(1.1, 1.1), end: const Offset(1.0, 1.0)),
          const SizedBox(height: 26),
          Text(
            'Brak zaplanowanych posiłków',
            style: TextStyle(
              fontSize: 26,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms),
          const SizedBox(height: 12),
          Text(
            'Dodaj swój pierwszy posiłek!',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade500,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 400.ms),
        ],
      ),
    );
  }

  Widget _budujPrzyciskDodawania(BuildContext kontekst) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(kontekst).push(
          MaterialPageRoute(builder: (_) => const EkranDodawaniaDania()),
        );
      },
      backgroundColor: Colors.pink.shade600, // Pink instead of orange
      elevation: 6,
      icon: const Icon(Icons.add_circle_outline, size: 34),
      label: const Text(
        'Dodaj posiłek',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    )
        .animate()
        .scale(duration: 300.ms, delay: 600.ms)
        .shimmer(duration: 1500.ms, delay: 900.ms);
  }
}

class KartaDania extends StatelessWidget {
  final Danie danie;

  const KartaDania({super.key, required this.danie});

  @override
  Widget build(BuildContext kontekst) {
    final formatCzasu = DateFormat('HH:mm');
    final czyMinelo = danie.kiedy.isBefore(DateTime.now());

    return Card(
      elevation: czyMinelo ? 2 : 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(kontekst).push(
            MaterialPageRoute(
              builder: (_) => EkranSzczegolow(danie: danie),
            ),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: czyMinelo
                  ? [Colors.grey.shade300, Colors.grey.shade200]
                  : [Colors.pink.shade50, Colors.white], // Pink gradient instead of orange
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _budujNaglowek(formatCzasu, czyMinelo),
              const SizedBox(height: 18),
              _budujNazwe(czyMinelo),
              const SizedBox(height: 14),
              _budujInformacje(czyMinelo),
              if (czyMinelo) ...[
                const SizedBox(height: 14),
                _budujStatusRealizacji(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _budujNaglowek(DateFormat formatCzasu, bool czyMinelo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              danie.typ.emoji(),
              style: const TextStyle(fontSize: 44),
            ),
            const SizedBox(width: 14),
            Text(
              danie.typ.nazwaPoPolsku(),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: czyMinelo ? Colors.grey.shade600 : Colors.pink.shade700, // Pink instead of orange
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: czyMinelo ? Colors.grey.shade500 : Colors.pink.shade600, // Pink instead of orange
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.schedule, color: Colors.white, size: 26),
              const SizedBox(width: 10),
              Text(
                formatCzasu.format(danie.kiedy),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _budujNazwe(bool czyMinelo) {
    return Text(
      danie.nazwa,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: czyMinelo ? Colors.grey.shade700 : Colors.black87,
      ),
    );
  }

  Widget _budujInformacje(bool czyMinelo) {
    return Wrap(
      spacing: 24,
      runSpacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.restaurant, size: 22, color: Colors.grey.shade600),
            const SizedBox(width: 10),
            Text(
              '${danie.skladniki.length} składników',
              style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              danie.przypominaj ? Icons.notifications_active : Icons.notifications_off,
              size: 22,
              color: danie.przypominaj ? Colors.pink.shade600 : Colors.grey.shade400, // Pink instead of orange
            ),
            const SizedBox(width: 10),
            Text(
              danie.przypominaj ? 'Powiadomienie' : 'Brak powiadomienia',
              style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }

  Widget _budujStatusRealizacji() {
    return Row(
      children: [
        Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 22),
        const SizedBox(width: 10),
        Text(
          'Zrealizowany',
          style: TextStyle(
            fontSize: 20,
            color: Colors.green.shade600,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
