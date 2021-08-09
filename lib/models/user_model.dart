class UserModel {
  final String uid;
  final String name;

  UserModel({required this.uid, required this.name});

  factory UserModel.fromMap(Map data) {
    return UserModel(
      uid: data['uid'],
      name: data['name']
    );
  }


  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
  };

}