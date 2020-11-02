import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/utils/colors.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {

  final String title;
  final Color backgroundColor;
  final GestureTapCallback onTapCallback;

  CustomAppBar({
    Key key,
    this.title = '',
    this.backgroundColor,
    this.onTapCallback
  }) :
        preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>{

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.backgroundColor == null ? CustomColors.mainBackground != null ? CustomColors.mainBackground : widget.backgroundColor : CustomColors.mainBackground,
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
              Text(widget.title, style: TextStyle(color: Colors.white, fontSize: 22),),
              Container(width: 30, height: 30,)
            ],
          ),
        )
      ],
    );
  }

  Widget _arrowBack() {
    return GestureDetector(
      onTap: widget.onTapCallback == null  ? _onTapClick : widget.onTapCallback,
      child: Icon(Icons.arrow_back, color: Colors.white, size: 30,),
    );
  }

  _onTapClick() {
    Navigator.of(context).pop({'isUpdate' : true});
  }
}