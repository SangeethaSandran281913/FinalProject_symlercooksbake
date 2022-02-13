class User {
  String? id;
  String? name;
  String? email;
  String? address;
  String? regdate;
  String? phone;
  

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.regdate,
    required this.phone,
  
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
    regdate = json['regdate'];
    phone = json['phone'];
    
  }
}
