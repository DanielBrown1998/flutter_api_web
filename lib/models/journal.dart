import 'package:uuid/uuid.dart';

class Journal {
  String id;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  Journal({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Journal.empty()
      : id = const Uuid().v1(),
        content = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  Journal.fromMap(Map<String, dynamic> item)
      : id = item['id'],
        content = item['content'],
        createdAt = DateTime.parse(item['created_at']),
        updatedAt = DateTime.parse(item['updated_at']);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "content": content,
      "created_at": createdAt.toString(),
      "updated_at": updatedAt.toString()
    };
  }

  @override
  String toString() {
    return "$content \ncreated_at: $createdAt\nupdated_at:$updatedAt";
  }
}
