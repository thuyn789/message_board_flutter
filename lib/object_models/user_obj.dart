class UserObj {
  final String userID;
  final String first_name;
  final String last_name;
  final String email;
  final String role;

  //final String urlAvatar;

  const UserObj({
    required this.userID,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.role,
    //required this.urlAvatar,
  });

  static UserObj fromJson(Map<String, dynamic> json) => UserObj(
        userID: json['user_id'],
        first_name: json['first_name'],
        last_name: json['last_name'],
        email: json['email'],
        role: json['user_role'],
        //urlAvatar: json['urlAvatar'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userID,
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'user_role': role,
        //'urlAvatar': urlAvatar,
      };
}
