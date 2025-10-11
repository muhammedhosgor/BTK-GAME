class UserModel {
  int? id;
  String? name;
  String? surname;
  String? email;
  String? password;
  int? point;
  String? createdDate;
  String? platform;
  String? status;
  bool? isActive;

  UserModel(
      {this.id,
      this.name,
      this.surname,
      this.email,
      this.password,
      this.point,
      this.createdDate,
      this.platform,
      this.status,
      this.isActive});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    email = json['email'];
    password = json['password'];
    point = json['point'];
    createdDate = json['createdDate'];
    platform = json['platform'];
    status = json['status'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['email'] = this.email;
    data['password'] = this.password;
    data['point'] = this.point;
    data['createdDate'] = this.createdDate;
    data['platform'] = this.platform;
    data['status'] = this.status;
    data['isActive'] = this.isActive;
    return data;
  }
}

UserModel userModel = UserModel();
