import '../helpers/custom_trace.dart';

class Note {
  String english_note;
  String arabic_note;

  Note();

  Note.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      english_note = jsonMap['english_note'];
      arabic_note = jsonMap['arabic_note'];
    } catch (e) {
      english_note = '';
      arabic_note = '';
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  @override
  String toString() => "$english_note $arabic_note";
}
