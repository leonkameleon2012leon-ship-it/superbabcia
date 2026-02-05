import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../babcia_state.dart';

class EkranDodawaniaDania extends StatefulWidget {
  const EkranDodawaniaDania({super.key});

  @override
  State<EkranDodawaniaDania> createState() => _StanEkranuDodawania();
}

class _StanEkranuDodawania extends State<EkranDodawaniaDania> {
  final _kluczFormularza = GlobalKey<FormState>();
  final _kontrolerNazwy = TextEditingController();
  final _kontrolerSkladnika = TextEditingController();

  TypDania _wybranyTyp = TypDania.rano;
  TimeOfDay _wybranyCzas = const TimeOfDay(hour: 8, minute: 0);
  final List<Skladnik> _listaSkladnikow = [];

  @override
  void dispose() {
    _kontrolerNazwy.dispose();
    _kontrolerSkladnika.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext kontekst) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E6),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Dodaj posiłek',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Form(
        key: _kluczFormularza,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _budujSekcje('Nazwa posiłku', _budujPoleNazwy()),
              const SizedBox(height: 26),
              _budujSekcje('Typ posiłku', _budujWyborTypu()),
              const SizedBox(height: 26),
              _budujSekcje('Godzina posiłku', _budujWyborCzasu(kontekst)),
              const SizedBox(height: 26),
              _budujSekcje('Składniki', _budujZarzadzanieSkladnikami()),
              const SizedBox(height: 36),
              _budujPrzyciskZapisu(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _budujSekcje(String tytul, Widget zawartosc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tytul,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.deepOrange.shade700,
          ),
        ),
        const SizedBox(height: 14),
        zawartosc,
      ],
    );
  }

  Widget _budujPoleNazwy() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: TextFormField(
          controller: _kontrolerNazwy,
          style: const TextStyle(fontSize: 22),
          decoration: const InputDecoration(
            hintText: 'np. Zupa pomidorowa',
            border: InputBorder.none,
            hintStyle: TextStyle(fontSize: 22),
          ),
          validator: (wartosc) {
            if (wartosc == null || wartosc.trim().isEmpty) {
              return 'Proszę podać nazwę posiłku';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _budujWyborTypu() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: TypDania.values.map((typ) {
          return RadioListTile<TypDania>(
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            title: Row(
              children: [
                Text(
                  typ.emoji(),
                  style: const TextStyle(fontSize: 36),
                ),
                const SizedBox(width: 14),
                Text(
                  typ.nazwaPoPolsku(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            value: typ,
            groupValue: _wybranyTyp,
            activeColor: Colors.deepOrange.shade600,
            onChanged: (TypDania? nowyTyp) {
              if (nowyTyp != null) {
                setState(() {
                  _wybranyTyp = nowyTyp;
                  _wybranyCzas = _domyslnyCzasDlaTypu(nowyTyp);
                });
              }
            },
          );
        }).toList(),
      ),
    );
  }

  TimeOfDay _domyslnyCzasDlaTypu(TypDania typ) {
    switch (typ) {
      case TypDania.rano:
        return const TimeOfDay(hour: 8, minute: 0);
      case TypDania.poludnie:
        return const TimeOfDay(hour: 13, minute: 0);
      case TypDania.wieczor:
        return const TimeOfDay(hour: 19, minute: 0);
      case TypDania.przekaski:
        return const TimeOfDay(hour: 16, minute: 0);
    }
  }

  Widget _budujWyborCzasu(BuildContext kontekst) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(18),
        leading: Icon(
          Icons.access_time_rounded,
          size: 40,
          color: Colors.deepOrange.shade600,
        ),
        title: Text(
          _wybranyCzas.format(kontekst),
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange.shade600,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => _pokazWyborCzasu(kontekst),
          child: const Text(
            'Zmień',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pokazWyborCzasu(BuildContext kontekst) async {
    final TimeOfDay? wybrany = await showTimePicker(
      context: kontekst,
      initialTime: _wybranyCzas,
      builder: (BuildContext ctx, Widget? dziecko) {
        return MediaQuery(
          data: MediaQuery.of(ctx).copyWith(textScaler: const TextScaler.linear(1.3)),
          child: dziecko!,
        );
      },
    );

    if (wybrany != null) {
      setState(() => _wybranyCzas = wybrany);
    }
  }

  Widget _budujZarzadzanieSkladnikami() {
    return Column(
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _kontrolerSkladnika,
                    style: const TextStyle(fontSize: 22),
                    decoration: const InputDecoration(
                      hintText: 'np. Pomidor - 2 sztuki',
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 20),
                    ),
                    onSubmitted: (_) => _dodajSkladnik(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange.shade600,
                    padding: const EdgeInsets.all(18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _dodajSkladnik,
                  child: const Icon(Icons.add_rounded, size: 26),
                ),
              ],
            ),
          ),
        ),
        if (_listaSkladnikow.isNotEmpty) ...[
          const SizedBox(height: 14),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: List.generate(_listaSkladnikow.length, (indeks) {
                  final skladnik = _listaSkladnikow[indeks];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    leading: Icon(
                      Icons.restaurant_rounded,
                      color: Colors.deepOrange.shade600,
                      size: 26,
                    ),
                    title: Text(
                      skladnik.opis,
                      style: const TextStyle(fontSize: 22),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_rounded, size: 26),
                      color: Colors.red.shade700,
                      onPressed: () {
                        setState(() => _listaSkladnikow.removeAt(indeks));
                      },
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _dodajSkladnik() {
    final tekst = _kontrolerSkladnika.text.trim();
    if (tekst.isNotEmpty) {
      setState(() {
        _listaSkladnikow.add(Skladnik(tekst));
        _kontrolerSkladnika.clear();
      });
    }
  }

  Widget _budujPrzyciskZapisu() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange.shade600,
        padding: const EdgeInsets.symmetric(vertical: 22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onPressed: _zapiszDanie,
      child: const Text(
        'Zapisz posiłek',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  void _zapiszDanie() {
    if (!_kluczFormularza.currentState!.validate()) return;

    if (_listaSkladnikow.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Dodaj przynajmniej jeden składnik',
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final teraz = DateTime.now();
    final zaplanowanyCzas = DateTime(
      teraz.year,
      teraz.month,
      teraz.day,
      _wybranyCzas.hour,
      _wybranyCzas.minute,
    );

    final noweDanie = Danie(
      id: 'dn_${DateTime.now().millisecondsSinceEpoch}',
      nazwa: _kontrolerNazwy.text.trim(),
      typ: _wybranyTyp,
      skladniki: List.from(_listaSkladnikow),
      kiedy: zaplanowanyCzas,
      przypominaj: true,
    );

    final stan = context.read<StanAplikacji>();
    stan.dodajDanie(noweDanie);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Posiłek został dodany!',
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.green.shade700,
      ),
    );

    Navigator.of(context).pop();
  }
}
