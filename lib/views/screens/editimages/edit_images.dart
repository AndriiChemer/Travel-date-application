import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_date_app/services/blocs/image_bloc.dart';
import 'package:travel_date_app/services/blocs/providers/progress_block_provider.dart';
import 'package:travel_date_app/services/prefs/user_prefs.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:path/path.dart' as Path;
import 'package:travel_date_app/utils/validatop.dart';

class EditImageScreen extends StatefulWidget {
  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  UserPreferences _userPreferences = UserPreferences();

  ImageBloc _imageBloc;

  bool isLoading = false;
  List<File> localImageFiles = [];

  List<String> images = [
    'https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/11039096_131093853921083_6660331166421982710_n.jpg?_nc_cat=105&_nc_ohc=9jTzqURUehAAQlFEkgY43DnXphv7njdmTviZd_kXWJOPc5ObcvoCqOwSA&_nc_ht=scontent-waw1-1.xx&oh=2bda72df6d9d225e7874a37c2ea9a158&oe=5E86847C',
    'https://scontent-waw1-1.xx.fbcdn.net/v/t31.0-8/p960x960/22712153_813002642194857_7976803065891309368_o.jpg?_nc_cat=110&_nc_ohc=ObRDDb7hqhUAQmkFU99Yg7BW7hXCFXc9mhguWRGQanQdaE10rqQAsj4NA&_nc_ht=scontent-waw1-1.xx&oh=4c828c7399871db1b5018b8d95807343&oe=5E8BFE50',
    'https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/60457709_864772787189123_3743945282803466240_n.jpg?_nc_cat=110&_nc_ohc=gTZApKPcEbUAQna2UNk3Y74FrmCtU4BXI59vVWQL5heNWY6W8pwYqyetA&_nc_ht=scontent-waw1-1.xx&oh=5b7fbf84f77bdc0aa18fe91f2da610c0&oe=5E83FAD9',
    'https://scontent-waw1-1.xx.fbcdn.net/v/t1.0-9/71813070_910727249327783_222159086056112128_n.jpg?_nc_cat=102&_nc_ohc=tGhwApO27W8AQkF9rJH620wLDEERszzT1hw-EUiHuCjkoJ-QvA-1YfSPQ&_nc_ht=scontent-waw1-1.xx&oh=08296a0a54da03239131e4693e36c617&oe=5E7CD684',
    ''
  ];

    @override
  void didChangeDependencies() {
      _imageBloc = ImageBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _imageBloc.image.listen((imageUrl) {
      print("CHEMER");
      print("ImageUrl: $imageUrl");
      setState(() {
        images.removeLast();
        images.add(imageUrl);
        images.add('');
      });
    });

    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(context),
      backgroundColor: CustomColors.lightBackground,
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _gridImageList(context),
            _saveButton(context),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColors.secondaryBackground,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.yellow[800], width: 1)
              )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _arrowBack(),
              Text(Strings.add_images, style: TextStyle(color: Colors.white, fontSize: 20),),
              Container(width: 30, height: 30,)
            ],
          ),
        )
      ],
    );
  }

  Widget _arrowBack() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Icon(Icons.arrow_back, color: Colors.white, size: 30,),
    );
  }

  Widget _gridImageList(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 3;
    final double itemHeight = (size.width / 2);

    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        childAspectRatio: (itemWidth / itemHeight),
        padding: const EdgeInsets.all(10),
        children: images.map((String image) {
          return ValidateFields.isStringUrl(image) ? _imageItem(image, itemWidth, itemHeight) : image != '' ? _localImage(image, itemWidth, itemHeight) : _addImage(itemWidth, itemHeight);
        }).toList(),
      ),
    );
  }

  Widget _addImage(double itemWidth, double itemHeight) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Stack(
        children: <Widget>[
          DottedBorder(
            color: Colors.white,
            borderType: BorderType.RRect,
            radius: Radius.circular(10),
            dashPattern: [8, 4],
            padding: EdgeInsets.all(0),
            child: Container(
              width: itemWidth - 40,
              height: itemHeight - 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: StreamBuilder(
                stream: _imageBloc.showProgress,
                builder: (context, snapshot){
                  return !snapshot.hasData ? Container() : snapshot.data ? _loadingProgress() : Container();
                }
              ),
            ),
          ),

          Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: _addImageButtonClick,
                child: Container(
                  width: 25,
                  height: 25,
                  child: Icon(Icons.add, size: 20,),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellow[800]
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

  Widget _imageItem(String image, double itemWidth, double itemHeight) {
    return Container(
      margin: EdgeInsets.all(5),

      child: Stack(
        children: <Widget>[
          Container(
            width: itemWidth - 40,
            height: itemHeight - 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: NetworkImage(image, ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter, // 10% of the width, so there are ten blinds.
                  colors: [Colors.white.withOpacity(0.15), Colors.black, ], // whitish to gray
                  tileMode: TileMode.repeated, // repeats the gradient over the canvas
                ),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10),  bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: _editButtonClick,
              child: Container(
                width: 25,
                height: 25,
                child: Icon(Icons.edit, size: 20,),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow[800]
                ),
              ),
            )
          )
        ],
      ),
    );
  }

  Widget _localImage(String image, double itemWidth, double itemHeight) {
    return Container(
      margin: EdgeInsets.all(5),

      child: Stack(
        children: <Widget>[
          Container(
            width: itemWidth - 40,
            height: itemHeight - 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: AssetImage(image,),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter, // 10% of the width, so there are ten blinds.
                  colors: [Colors.white.withOpacity(0.15), Colors.black, ], // whitish to gray
                  tileMode: TileMode.repeated, // repeats the gradient over the canvas
                ),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10),  bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
              ),
            ),
          ),

          Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: _editButtonClick,
                child: Container(
                  width: 25,
                  height: 25,
                  child: Icon(Icons.edit, size: 20,),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellow[800]
                  ),
                ),
              )
          )
        ],
      ),
    );
  }

  _editButtonClick() {

  }

  Future _addImageButtonClick() async {

    await ImagePicker.pickImage(source: ImageSource.gallery).then((imageFile){
      _userPreferences.getUserId().then((userId) async {
        _imageBloc.uploadImage(imageFile, userId);
      });
    });
  }

//  Future saveAndUploadFiles() async {
//    _userPreferences.getUserId().then((userId) async {
//
//      var fileName = Path.basename(localImageFiles[0].path);
//      StorageReference storageReference = FirebaseStorage.instance.ref().child('profiles/').child(userId).child(fileName);
//
//      Uint8List bytes = localImageFiles[0].readAsBytesSync();
//      StorageUploadTask uploadTask = storageReference.putData(bytes);
//
//      final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask.events.listen((event) {
//        print('EVENT ${event.type}');
//      });
//
//      await uploadTask.onComplete;
//      streamSubscription.cancel();
//
//      storageReference.getDownloadURL().then((imageUrl) {
//        print("imageUrl = $imageUrl");
//      });
//
//    });
//
//  }

  Future saveAndUploadFiles() async {
    _userPreferences.getUserId().then((userId) async {
      for(File file in localImageFiles) {
        var fileName = Path.basename(file.path);
        Uint8List fileBytes = localImageFiles[0].readAsBytesSync();

        StorageReference storageReference = FirebaseStorage.instance.ref().child('profiles/').child(userId).child(fileName);
        StorageUploadTask uploadTask = storageReference.putData(fileBytes);

        final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask.events.listen((event) {
          print('EVENT ${event.type}');
        });

        await uploadTask.onComplete;
        streamSubscription.cancel();

        storageReference.getDownloadURL().then((imageUrl) {
          print("imageUrl = $imageUrl");
        });
      }
    });

  }

  Widget _loadingProgress() {
    return Center(
      child: SpinKitFadingCube(
        color: Colors.yellow[800],
        size: 50,
      ),
    );
  }

  Widget _saveButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: ButtonTheme(
        minWidth: MediaQuery.of(context).size.width,
        height: 50,
        child: RaisedButton(
          color: Colors.yellow[800],
          textColor: Colors.white,
          child: Text(Strings.save_button.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 20),),
          onPressed: saveAndUploadFiles,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}
