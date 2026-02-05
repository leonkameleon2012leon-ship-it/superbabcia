import 'package:flutter/material.dart';
import 'dart:math' show pi, sin, cos;

class EkranPowitania extends StatefulWidget {
  final VoidCallback przejdzDalej;

  const EkranPowitania({super.key, required this.przejdzDalej});

  @override
  State<EkranPowitania> createState() => _StanEkranuPowitania();
}

class _StanEkranuPowitania extends State<EkranPowitania> with TickerProviderStateMixin {
  late AnimationController _kontrolerTalerza;
  late AnimationController _kontrolerPary;
  late AnimationController _kontrolerTekstu;

  @override
  void initState() {
    super.initState();

    _kontrolerTalerza = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    _kontrolerPary = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    )..repeat();

    _kontrolerTekstu = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _uruchomAnimacje();
  }

  void _uruchomAnimacje() async {
    await _kontrolerTalerza.forward();
    await _kontrolerTekstu.forward();
    await Future.delayed(const Duration(milliseconds: 2200));
    widget.przejdzDalej();
  }

  @override
  void dispose() {
    _kontrolerTalerza.dispose();
    _kontrolerPary.dispose();
    _kontrolerTekstu.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([_kontrolerTalerza, _kontrolerPary]),
              builder: (ctx, dziecko) {
                final skalaTalerza = Curves.elasticOut.transform(_kontrolerTalerza.value);
                final obrotTalerza = (1 - _kontrolerTalerza.value) * 0.3;

                return Transform(
                  transform: Matrix4.identity()
                    ..scale(skalaTalerza)
                    ..rotateZ(obrotTalerza),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 220,
                    height: 220,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: MalowanieTalerza(),
                          ),
                        ),
                        ...List.generate(4, (i) {
                          final postep = _kontrolerPary.value;
                          final przesuniecie = postep * 90;
                          final przezroczystosc = (1.0 - postep).clamp(0.0, 1.0);
                          final pozycjaX = 95 + (i * 8.0);
                          final pozycjaY = 30 - przesuniecie + (i * 12);

                          return Positioned(
                            left: pozycjaX,
                            top: pozycjaY,
                            child: Opacity(
                              opacity: przezroczystosc,
                              child: Text(
                                '~',
                                style: TextStyle(
                                  fontSize: 34 - (i * 6.0),
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 50),
            FadeTransition(
              opacity: CurvedAnimation(
                parent: _kontrolerTekstu,
                curve: Curves.easeIn,
              ),
              child: Column(
                children: [
                  Text(
                    'Smacznego!',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Colors.deepOrange.shade700,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Miłego dnia w pracy!',
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.orange.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MalowanieTalerza extends CustomPainter {
  @override
  void paint(Canvas kanwa, Size rozmiar) {
    final srodek = Offset(rozmiar.width * 0.5, rozmiar.height * 0.5);
    final promienZewnetrzny = rozmiar.width * 0.38;

    // Cień
    final farba_ciena = Paint()
      ..color = Colors.black.withOpacity(0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    kanwa.drawCircle(
      srodek.translate(0, 6),
      promienZewnetrzny,
      farba_ciena,
    );

    // Podstawa talerza
    final farbaPodstawy = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white,
          Colors.grey.shade50,
        ],
      ).createShader(Rect.fromCircle(center: srodek, radius: promienZewnetrzny));

    kanwa.drawCircle(srodek, promienZewnetrzny, farbaPodstawy);

    // Brzeg talerza
    final farbaBrzegu = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..shader = LinearGradient(
        colors: [
          Colors.grey.shade200,
          Colors.grey.shade400,
          Colors.grey.shade200,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: srodek, radius: promienZewnetrzny - 5));

    kanwa.drawCircle(srodek, promienZewnetrzny - 5, farbaBrzegu);

    // Środek talerza (delikatny gradient)
    final farbaWglebienia = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.grey.shade100,
          Colors.white,
        ],
        stops: const [0.3, 1.0],
      ).createShader(Rect.fromCircle(center: srodek, radius: promienZewnetrzny * 0.7));

    kanwa.drawCircle(srodek, promienZewnetrzny * 0.7, farbaWglebienia);

    // Jedzenie na talerzu
    final farbaJedzenia = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.orange.shade500,
          Colors.orange.shade400,
          Colors.orange.shade300,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: srodek, radius: promienZewnetrzny * 0.5));

    kanwa.drawCircle(srodek, promienZewnetrzny * 0.48, farbaJedzenia);

    // Dekoracyjne elementy (liście pietruszki)
    _rysujDekoracje(kanwa, srodek, promienZewnetrzny * 0.4);
  }

  void _rysujDekoracje(Canvas kanwa, Offset srodek, double promien) {
    final farbaDekoracji = Paint()
      ..color = Colors.green.shade700
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 3; i++) {
      final kat = (i * 2 * pi / 3) + pi / 6;
      final x = srodek.dx + promien * 0.6 * cos(kat);
      final y = srodek.dy + promien * 0.6 * sin(kat);

      final sciezka = Path();
      sciezka.moveTo(x, y);
      sciezka.lineTo(x - 3, y - 6);
      sciezka.lineTo(x + 3, y - 6);
      sciezka.close();

      kanwa.drawPath(sciezka, farbaDekoracji);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
