import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweepspot/control/data_controller.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100);
}

// Function to delete notification for a specific user
Future<void> deleteNotification(String url, String eventTitle, String eventId,
    DataController dataController) async {
  try {
    if (await dataController.isUserParticipant(eventId)) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          title: '${Emojis.office_wastebasket} An event was deleted',
          body: 'The event ${eventTitle} has been deleted.',
          bigPicture: url,
          notificationLayout: NotificationLayout.BigPicture,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'noted',
            label: 'Noted',
          ),
        ],
      );
    }
  } catch (e) {
    print('Error creating delete notification: $e');
  }
}

// Function to add notification for a specific user
/*Future<void> addNotification(String url, String eventTitle) async {
  try {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: '${Emojis.plant_deciduous_tree} An event was created',
        body: 'The event ${eventTitle} has been created.',
        bigPicture: url,
        notificationLayout: NotificationLayout.BigPicture,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'noted',
          label: 'Noted',
        ),
      ],
    );
  } catch (e) {
    print('Error creating delete notification: $e');
  }
}*/

// Function to change notification for a specific user
Future<void> changeNotification(String url, String eventTitle, String eventId,
    DataController dataController) async {
  try {
    if (await dataController.isUserParticipant(eventId)) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          title: '${Emojis.symbols_recycling_symbol} An event was modified',
          body: 'Informations of the event ${eventTitle} have been modified.',
          bigPicture: url,
          notificationLayout: NotificationLayout.BigPicture,
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'noted',
            label: 'Noted',
          ),
        ],
      );
    }
  } catch (e) {
    print('Error creating delete notification: $e');
  }
}

Future<void> scheduleEventNotification(
    DocumentSnapshot<Map<String, dynamic>> event,
    String eventId,
    DataController dataController) async {
  DateTime eventTime = DateTime.parse(event['datetime']);
  DateTime now = DateTime.now();

  // Calcular a diferença em minutos
  int minutesDifference = eventTime.difference(now).inMinutes;

  // Se o evento ocorrer em menos de 80 minutos, verificar se o usuário é um participante
  if (minutesDifference > 0 && minutesDifference <= 60) {
    bool isParticipant = await dataController.isUserParticipant(eventId);
    if (isParticipant) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          title: '${Emojis.time_nine_o_clock} Event Reminder',
          body: 'The event "${event['name']}" starts in less than an hour!',
          bigPicture: event['image'],
          notificationLayout: NotificationLayout.BigPicture,
        ),
      );
    }
  }
}
