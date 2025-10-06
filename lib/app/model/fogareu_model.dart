import 'dart:convert';

class Fogareu {
  bool isEnable;
  int temperatura;
  Fogareu({
    required this.isEnable,
    required this.temperatura,
  });

  Fogareu copyWith({
    bool? isEnable,
    int? temperatura,
  }) {
    return Fogareu(
      isEnable: isEnable ?? this.isEnable,
      temperatura: temperatura ?? this.temperatura,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isEnable': isEnable,
      'temperatura': temperatura,
    };
  }

  factory Fogareu.fromMap(Map<String, dynamic> map) {
    return Fogareu(
      isEnable: map['isEnable'] as bool,
      temperatura: map['temperatura'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Fogareu.fromJson(String source) => Fogareu.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Fogareu(isEnable: $isEnable, temperatura: $temperatura)';

  @override
  bool operator ==(covariant Fogareu other) {
    if (identical(this, other)) return true;
  
    return 
      other.isEnable == isEnable &&
      other.temperatura == temperatura;
  }

  @override
  int get hashCode => isEnable.hashCode ^ temperatura.hashCode;
}
