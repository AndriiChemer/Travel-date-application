import 'dart:async';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_date_app/models/user_model.dart';
import 'package:travel_date_app/services/blocs/image_bloc.dart';
import 'package:travel_date_app/services/blocs/providers/progress_block_provider.dart';
import 'package:travel_date_app/services/prefs/user_prefs.dart';
import 'package:travel_date_app/utils/colors.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/utils/validatop.dart';
import 'package:travel_date_app/views/widgets/app_bars.dart';

class EditImageScreen extends StatefulWidget {

  final UserModel user;

  EditImageScreen({@required this.user});

  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _userPreferences = UserPreferences();
  ImageBloc _imageBloc;
  List<String> images = [];

  @override
  void initState() {
    buildImageList();

    super.initState();
  }

  buildImageList() {
    _userPreferences.getGalleryImages().then((imageList) {

      if(imageList != null) {
        imageList.map((image) {
          images.add(image);
        }).toList();
      }

      widget.user.images.addAll(images);

      if(widget.user.imageUrl != '') {
        images.insert(0, widget.user.imageUrl);
      }
      setState(() {
        images.add('');
      });
    });
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
      appBar: CustomAppBar(title: Strings.add_images, backgroundColor: CustomColors.secondaryBackground, onTapCallback: _arrowBackClick,),
      backgroundColor: CustomColors.lightBackground,
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _gridImageList(context),
            _saveButton(context)
          ],
        ),
      ),
    );
  }

  _arrowBackClick() {
    Navigator.of(context).pop({'user' : widget.user});
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
                  end: FractionalOffset.bottomCenter,
                  colors: [Colors.white.withOpacity(0.15), Colors.black, ],
                  tileMode: TileMode.repeated,
                ),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10),  bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: _popupImageMenu(image),
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
              child: _popupImageMenu(image)
          )
        ],
      ),
    );
  }

  _editButtonClick(int value, String image) {
    // TODO task add functions
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
    Navigator.pop(context, {'user' : widget.user});
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

  Widget _popupImageMenu(String image) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("Menu 1", style: TextStyle(fontWeight: FontWeight.w700),),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Menu 2", style: TextStyle(fontWeight: FontWeight.w700),),
        ),
        PopupMenuItem(
          value: 3,
          child: Text("Menu 3", style: TextStyle(fontWeight: FontWeight.w700),),
        )
      ],
      padding: EdgeInsets.all(0),
      onSelected: (value) {
        _editButtonClick(value, image);
      },
      child: GestureDetector(
        child: Container(
          width: 25,
          height: 25,
          child: Icon(Icons.edit, size: 20,),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.yellow[800]
          ),
        ),
      ),
    );
  }
}
