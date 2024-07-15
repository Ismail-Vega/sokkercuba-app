class PlayerName {
  final String name;
  final String surname;
  final String full;

  PlayerName({required this.name, required this.surname, required this.full});

  factory PlayerName.fromJson(Map<String, dynamic> json) {
    return PlayerName(
      name: json['name'],
      surname: json['surname'],
      full: json['full'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'full': full,
    };
  }
}
