class LoggedUser {
  LoggedUser(
    this.name,
    this.mobile,
  );

  final String? name;
  final String mobile;

  LoggedUser copyWith({
    String? name,
    String? mobile,
  }) {
    return LoggedUser(
      name ?? this.name,
      mobile ?? this.mobile,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'mobile': mobile,
    };
  }

  factory LoggedUser.fromJson(Map<String, dynamic> map) {
    return LoggedUser(
      map['name'] != null ? map['name'] as String : null,
      map['mobile'] as String,
    );
  }

  @override
  String toString() => 'LoggedUser(name: $name, mobile: $mobile)';

  @override
  bool operator ==(covariant LoggedUser other) {
    if (identical(this, other)) return true;

    return other.name == name && other.mobile == mobile;
  }

  @override
  int get hashCode => name.hashCode ^ mobile.hashCode;
}
