class UserModel {
  // DateFormat("dd/MM/yyyy HH:mm:ss").parse("10/02/2000 15:13:09")
  final int id;
  final String name;
  final String city;
  final String imageUrl;
  final int state;
  final String status;
  final String dateCreated;
  final String lastTimeOnline;
  final double lat;
  final double lng;
  final String person;

  UserModel({this.id, this.name, this.city, this.imageUrl, this.state,
    this.status, this.dateCreated, this.lastTimeOnline, this.lat, this.lng,
  this.person});
}