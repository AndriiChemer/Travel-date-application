import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_date_app/models/interest_model.dart';
import 'package:travel_date_app/utils/strings.dart';
import 'package:travel_date_app/views/screens/registrationflow/setpasswordscreen/set_password.dart';
import 'package:travel_date_app/views/widgets/main_background.dart';

class InterestsScreen extends StatefulWidget {
  @override
  _InterestsScreenState createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {

  var searchTextFieldController = TextEditingController();

  List<InterestModel> searchList = [];
  List<InterestModel> interestList = [
    InterestModel(image: "assets/images/interests/pie_category.jpg", name: "Food"),
    InterestModel(image: "assets/images/interests/travel_category.jpg", name: "Travel"),
    InterestModel(image: "assets/images/interests/music_category.jpg", name: "Music"),
    InterestModel(image: "assets/images/interests/technology_category.jpg", name: "Technology"),
    InterestModel(image: "assets/images/interests/art_category.jpg", name: "Art"),
    InterestModel(image: "assets/images/interests/drinks_category.jpg", name: "Drinking"),
    InterestModel(image: "assets/images/interests/news_category.jpg", name: "News"),
    InterestModel(image: "assets/images/interests/beauty_category.jpg", name: "Beauty"),
  ];


  @override
  void initState() {
    super.initState();
    searchList.addAll(interestList);

    searchTextFieldController.addListener(() {
      String searchStr = searchTextFieldController.text;
      if(searchStr.length == 0) {
        searchList.addAll(interestList);
      } else {
        searchList.clear();
        for(InterestModel model in interestList) {
          if(model.name.toLowerCase().contains(searchStr.toLowerCase())) {
            searchList.add(model);
          }
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainBackground(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              arrowBack(),
              Flexible(
                child: SizedBox(height: 30,),
              ),
              Text(Strings.interests, style: TextStyle(color: Colors.white, fontSize: 35),),
              Flexible(
                child: SizedBox(height: 30,),
              ),
              _searchTextField(),
              Flexible(
                child: SizedBox(height: 30,),
              ),
              _gridInterestsList(context),
              _nextButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget arrowBack() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Icon(Icons.arrow_back, color: Colors.white, size: 40,),
    );
  }

  Widget _searchTextField() {
    return TextFormField(
      autofocus: false,
      controller: searchTextFieldController,
      style: TextStyle(fontSize: 18.0, color: Colors.grey[900]),
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: Strings.search,
          prefixIcon: Icon(Icons.search, color: Colors.grey[800],),
          contentPadding: const EdgeInsets.only(left: 14.0, bottom: 12.0, top: 12.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25.7),
          )
      ),
    );
  }

  Widget _gridInterestsList(BuildContext context) {

    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.width / 1.5);
    final double itemWidth = size.width / 2;

    return Expanded(
      flex: 9,
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: (itemWidth / itemHeight),
        padding: const EdgeInsets.all(10),
        children: searchList.map((InterestModel model) {
          return _interestItem(model, itemWidth, itemHeight);
        }).toList(),
      ),
    );
  }

  Widget _nextButton(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ButtonTheme(
          minWidth: MediaQuery.of(context).size.width,
          height: 50,
          child: RaisedButton(
            color: Colors.yellow[800],
            textColor: Colors.white,
            child: Text(Strings.next.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 20),),
            onPressed: () {
              _onButtonNextClick();
            },
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
          ),
        ),
      ),
    );
  }

  Container _interestItem(InterestModel model, double itemWidth, double itemHeight) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            model.isSelected = !model.isSelected;
          });
        },
        child: Stack(
          children: <Widget>[

            Column(
              children: <Widget>[
                _itemImage(model, itemWidth, itemHeight),
                Container(
                  child: Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(model.name, style: TextStyle( fontSize: 20),),
                    ),
                  ),
                )
              ],
            ),
            Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: model.isSelected ? Colors.yellow[800].withOpacity(0.9) : Colors.white.withOpacity(0.7),
                shape: BoxShape.circle
              ),
              child: Center(
                child: Icon(Icons.check, color: model.isSelected ? Colors.white : Colors.black,),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemImage(InterestModel model, double itemWidth, double itemHeight) {
    return Container(
      width: itemWidth,
      height: itemWidth - 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
        image: DecorationImage(
          image: AssetImage(model.image, ),
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
    );

  }

  _onButtonNextClick() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SetPasswordScreen()));
  }
}
