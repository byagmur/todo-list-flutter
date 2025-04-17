//uygulamanın kendi toDo listesi için kullanılan model sınıfı

class ToDo {
  int? id;
  String? title;
  bool? completed;
  int? userId;

  ToDo({
    required this.id,
    required this.title,
    this.completed = false,
    this.userId,
  });

  // toJson: ToDo nesnesini Map'e dönüştürme, apiye veri gönderirken kullanılır.
  Map<String, dynamic> toJson() {
    return {'id': id, 'todo': title, 'completed': completed, 'userId': userId};
  }

  // fromJson: Map'ten ToDo nesnesi oluşturma, apiden veri çektikten sonra json veriyi ToDo nesnesine dönüştürmek için kullanılır.
  factory ToDo.fromJson(Map<String, dynamic> json) { //factory contructor kullanmamızın sebebi mevcut olan bir nesneyi kullanarak 
  //yeni bir nesne oluşturmak için kullanılır. contructorda ise yeni bir nesne oluşturulur.
    return ToDo(
      id: json['id'],
      title: json['todo'] ?? "boş",
      completed: json['completed'] ?? false, 
      userId: json['userId'],
    );
  }

}
