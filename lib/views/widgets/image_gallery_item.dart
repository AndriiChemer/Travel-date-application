import 'package:flutter/material.dart';
import 'package:travel_date_app/services/blocs/image_bloc.dart';
import 'package:travel_date_app/services/blocs/providers/progress_block_provider.dart';

class ImageGalleryItem extends StatefulWidget {

  final String userId;
  final String imageUrl;
  final double itemWidth;
  final double itemHeight;

  const ImageGalleryItem({this.userId, this.imageUrl, this.itemWidth, this.itemHeight});

  @override
  _ImageGalleryItemState createState() => _ImageGalleryItemState();
}

class _ImageGalleryItemState extends State<ImageGalleryItem> {

  static const int SET_PROFILE = 1;
  static const int REMOVE = 2;

  ImageBloc _imageBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _imageBloc = ImageBlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),

      child: Stack(
        children: <Widget>[
          Container(
            width: widget.itemWidth - 40,
            height: widget.itemHeight - 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: NetworkImage(widget.imageUrl,),
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
            child: PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: SET_PROFILE,
                  child: Text("Set as profile", style: TextStyle(fontWeight: FontWeight.w700),),
                ),
                PopupMenuItem(
                  value: REMOVE,
                  child: Text("Remove", style: TextStyle(fontWeight: FontWeight.w700),),
                )
              ],
              padding: EdgeInsets.all(0),
              onSelected: (value) {
                switch(value) {
                  case SET_PROFILE:
                    _imageBloc.setAsProfileImage(widget.userId, widget.imageUrl);
                    break;
                  case REMOVE:
                    _imageBloc.removeImage(widget.userId, widget.imageUrl);
                    break;
                }
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
            ),
          )
        ],
      ),
    );
  }
}
