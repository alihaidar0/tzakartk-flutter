import 'delivery_note.dart';
import 'free_delivery_note.dart';

import '../helpers/custom_trace.dart';

class Note {
  DeliveryNote deliveryNote;
  FreeDeliveryNote freeDeliveryNote;

  Note();

  Note.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      deliveryNote = jsonMap['delivery'] != null
          ? DeliveryNote.fromJSON(jsonMap['delivery'])
          : DeliveryNote.fromJSON({});
      freeDeliveryNote = jsonMap['free_delivery'] != null
          ? FreeDeliveryNote.fromJSON(jsonMap['free_delivery'])
          : FreeDeliveryNote.fromJSON({});
    } catch (e) {
      deliveryNote = DeliveryNote.fromJSON({});
      freeDeliveryNote = FreeDeliveryNote.fromJSON({});
      print(CustomTrace(StackTrace.current, message: e));
    }
  }
}
