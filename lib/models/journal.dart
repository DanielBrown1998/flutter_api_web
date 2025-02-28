import 'package:uuid/uuid.dart';

class Journal {
  String id;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  String userId;
  

  Journal({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  Journal.empty({required String idFromUser})
      : id = const Uuid().v1(),
        content = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(), 
        userId = idFromUser;

  Journal.fromMap(Map<String, dynamic> item)
      : id = item['id'],
        content = item['content'],
        createdAt = DateTime.parse(item['created_at']),
        updatedAt = DateTime.parse(item['updated_at']),
        userId = item['userId'];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "content": content,
      "created_at": createdAt.toString(),
      "updated_at": updatedAt.toString(),
      "userId": userId,
    };
  }

  @override
  String toString() {
    return "$content \ncreated_at: $createdAt\nupdated_at:$updatedAt";
  }
}
