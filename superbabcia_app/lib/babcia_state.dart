import 'package:flutter/foundation.dart';
import 'dart:async';
import 'alerty.dart';

// Typy dań
enum TypDania { rano, poludnie, wieczor, przekaski }

// Rozszerzenie dla typu dania
extension TypDaniaRozszerzenie on TypDania {
  String nazwaPoPolsku() {
    const mapa = {
      TypDania.rano: 'Śniadanie',
      TypDania.poludnie: 'Obiad',
      TypDania.wieczor: 'Kolacja',
      TypDania.przekaski: 'Przekąska',
    };
    return mapa[this]!;
  }

  String emoji() {
    const mapa = {
      TypDania.rano: '🥐',
      TypDania.poludnie: '🍲',
      TypDania.wieczor: '🍽️',
      TypDania.przekaski: '🍎',
    };
    return mapa[this]!;
  }
}

// Skladnik dania
class Skladnik {
  String opis;
  Skladnik(this.opis);
  
  Map<String, dynamic> doMapy() => {'o': opis};
  factory Skladnik.zMapy(Map<String, dynamic> m) => Skladnik(m['o']);
}

// Danie
class Danie {
  String id;
  String nazwa;
  TypDania typ;
  List<Skladnik> skladniki;
  DateTime kiedy;
  bool przypominaj;

  Danie({
    required this.id,
    required this.nazwa,
    required this.typ,
    required this.skladniki,
    required this.kiedy,
    this.przypominaj = true,
  });

  Danie kopiuj({
    String? id,
    String? nazwa,
    TypDania? typ,
    List<Skladnik>? skladniki,
    DateTime? kiedy,
    bool? przypominaj,
  }) {
    return Danie(
      id: id ?? this.id,
      nazwa: nazwa ?? this.nazwa,
      typ: typ ?? this.typ,
      skladniki: skladniki ?? this.skladniki,
      kiedy: kiedy ?? this.kiedy,
      przypominaj: przypominaj ?? this.przypominaj,
    );
  }

  Map<String, dynamic> doMapy() => {
        'i': id,
        'n': nazwa,
        't': typ.index,
        's': skladniki.map((e) => e.doMapy()).toList(),
        'k': kiedy.toIso8601String(),
        'p': przypominaj,
      };

  factory Danie.zMapy(Map<String, dynamic> m) => Danie(
        id: m['i'],
        nazwa: m['n'],
        typ: TypDania.values[m['t']],
        skladniki: (m['s'] as List).map((e) => Skladnik.zMapy(e)).toList(),
        kiedy: DateTime.parse(m['k']),
        przypominaj: m['p'],
      );
}

// Stan aplikacji
class StanAplikacji with ChangeNotifier {
  final List<Danie> _dania = [];
  final SystemAlertow _alerty = SystemAlertow();

  StanAplikacji() {
    _zaladujPrzykladoweDane();
  }

  List<Danie> pobierzWszystkie() => List.unmodifiable(_dania);

  List<Danie> pobierzNaDzis() {
    final teraz = DateTime.now();
    final dzisStart = DateTime(teraz.year, teraz.month, teraz.day);
    final jutroStart = dzisStart.add(const Duration(days: 1));

    return _dania
        .where((d) {
          final daniaData = DateTime(d.kiedy.year, d.kiedy.month, d.kiedy.day);
          return daniaData == dzisStart || (daniaData.isAfter(dzisStart) && daniaData.isBefore(jutroStart));
        })
        .toList()
      ..sort((a, b) => a.kiedy.compareTo(b.kiedy));
  }

  Future<void> dodajDanie(Danie d) async {
    _dania.add(d);
    await _alerty.zaplanuj(d);
    notifyListeners();
  }

  Future<void> usunDanie(String id) async {
    final d = _dania.firstWhere((x) => x.id == id);
    await _alerty.anuluj(d);
    _dania.removeWhere((x) => x.id == id);
    notifyListeners();
  }

  Future<void> aktualizujDanie(Danie nowe) async {
    final idx = _dania.indexWhere((x) => x.id == nowe.id);
    if (idx >= 0) {
      await _alerty.anuluj(_dania[idx]);
      _dania[idx] = nowe;
      await _alerty.zaplanuj(nowe);
      notifyListeners();
    }
  }

  Future<void> przelaczPrzypomnienie(String id) async {
    final idx = _dania.indexWhere((x) => x.id == id);
    if (idx >= 0) {
      final stare = _dania[idx];
      final nowe = stare.kopiuj(przypominaj: !stare.przypominaj);
      
      if (nowe.przypominaj) {
        await _alerty.zaplanuj(nowe);
      } else {
        await _alerty.anuluj(stare);
      }
      
      _dania[idx] = nowe;
      notifyListeners();
    }
  }

  void _zaladujPrzykladoweDane() {
    final teraz = DateTime.now();
    final dzis = DateTime(teraz.year, teraz.month, teraz.day);

    _dania.addAll([
      Danie(
        id: 'dn1',
        nazwa: 'Kanapki z serem i pomidorem',
        typ: TypDania.rano,
        skladniki: [
          Skladnik('Chleb razowy - 2 kromki'),
          Skladnik('Ser żółty - 50g'),
          Skladnik('Pomidor - 1 sztuka'),
          Skladnik('Masło - 10g'),
        ],
        kiedy: dzis.add(const Duration(hours: 8)),
      ),
      Danie(
        id: 'dn2',
        nazwa: 'Zupa pomidorowa z makaronem',
        typ: TypDania.poludnie,
        skladniki: [
          Skladnik('Pomidory - 500g'),
          Skladnik('Makaron świderki - 100g'),
          Skladnik('Śmietana 18% - 50ml'),
          Skladnik('Bulion warzywny - 1l'),
          Skladnik('Pietruszka - pęczek'),
        ],
        kiedy: dzis.add(const Duration(hours: 13)),
      ),
      Danie(
        id: 'dn3',
        nazwa: 'Herbata z ciastkiem',
        typ: TypDania.przekaski,
        skladniki: [
          Skladnik('Herbata czarna - 1 torebka'),
          Skladnik('Ciastka maślane - 2 sztuki'),
          Skladnik('Miód - 1 łyżeczka'),
        ],
        kiedy: dzis.add(const Duration(hours: 16)),
      ),
      Danie(
        id: 'dn4',
        nazwa: 'Jajecznica ze szczypiorkiem',
        typ: TypDania.wieczor,
        skladniki: [
          Skladnik('Jajka - 2 sztuki'),
          Skladnik('Szczypiorek - 1 pęczek'),
          Skladnik('Masło - 10g'),
          Skladnik('Chleb - 1 kromka'),
        ],
        kiedy: dzis.add(const Duration(hours: 19)),
      ),
    ]);

    _alerty.inicjalizuj().then((_) {
      for (final d in _dania) {
        _alerty.zaplanuj(d);
      }
    });
  }
}
