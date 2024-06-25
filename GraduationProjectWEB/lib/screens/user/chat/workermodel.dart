class Worker {
  final String id;
  final String name;
  final String lastname;
  Worker( {required this.lastname,required this.id, required this.name});

  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      id: json['worker_id'].toString(),
      name: json['worker_name'].toString(),
      lastname: json['worker_lastname'].toString()
    );
  }
}

class Role {
  final String name;
  final List<Worker> workers;

  Role({required this.name, required this.workers});

  factory Role.fromJson(String name, List<dynamic> json) {
    return Role(
      name: name,
      workers: json.map((workerJson) => Worker.fromJson(workerJson)).toList(),

    );
  }
}
