import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'babcia_state.dart';

class SystemAlertow {
  static final SystemAlertow _instancja = SystemAlertow._prywatny();
  factory SystemAlertow() => _instancja;
  SystemAlertow._prywatny();

  final FlutterLocalNotificationsPlugin _wtyczka = FlutterLocalNotificationsPlugin();
  bool _gotowy = false;

  Future<void> inicjalizuj() async {
    if (_gotowy) return;

    tz.initializeTimeZones();

    const konfAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const konfIos = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const konf = InitializationSettings(android: konfAndroid, iOS: konfIos);

    await _wtyczka.initialize(konf, onDidReceiveNotificationResponse: _obsluzKlikniecie);
    await _poprosOUprawnienia();
    _gotowy = true;
  }

  Future<void> _poprosOUprawnienia() async {
    await _wtyczka
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _wtyczka
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  void _obsluzKlikniecie(NotificationResponse odp) {
    // Obsługa kliknięcia w powiadomienie
  }

  Future<void> zaplanuj(Danie d) async {
    if (!d.przypominaj) return;

    final momentPrzypomnienia = d.kiedy.subtract(const Duration(minutes: 15));
    if (momentPrzypomnienia.isBefore(DateTime.now())) return;

    const detaleAndroid = AndroidNotificationDetails(
      'kanaldania',
      'Przypomnienia o daniach',
      channelDescription: 'Powiadomienia o zbliżającej się porze dania',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const detaleIos = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const detale = NotificationDetails(android: detaleAndroid, iOS: detaleIos);

    await _wtyczka.zonedSchedule(
      d.id.hashCode,
      'Za 15 minut: ${d.typ.nazwaPoPolsku()}',
      'Przygotuj ${d.nazwa} 🍽️',
      tz.TZDateTime.from(momentPrzypomnienia, tz.local),
      detale,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: d.id,
    );
  }

  Future<void> anuluj(Danie d) async {
    await _wtyczka.cancel(d.id.hashCode);
  }

  Future<void> anulujWszystkie() async {
    await _wtyczka.cancelAll();
  }
}
