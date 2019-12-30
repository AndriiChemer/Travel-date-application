import 'dart:async';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_date_app/models/person_model.dart';
import 'package:travel_date_app/services/blocs/image_bloc.dart';
import 'package:travel_date_app/services/blocs/providers/progress_block_provider.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/utils/validatop.dart';

class EditImageScreen extends StatefulWidget {

  final UserModel user;

  EditImageScreen({@required this.user});

  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ImageBloc _imageBloc;
  List<String> images = [];

  @override
  void initState() {
    images.add(widget.user.imageUrl);
    widget.user.images.map((image) {
      images.add(image);
    });
    images.add('');

    super.initState();
  }

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
            ),
            child: ClipRRect(
              borderRadius: new BorderRadius.circular(10),
              child: Image.file(File(image), fit: BoxFit.cover,),
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
      _imageBloc.uploadImage(imageFile, widget.user);
      showLocalImage(imageFile);

    });
  }

  showLocalImage(File image) {
      setState(() {
        images.removeLast();
        images.add(image.path);
        images.add('');
      });
  }

  onSaveClick() {
    Navigator.pop(context);
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
          onPressed: onSaveClick,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}
