import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ZakatCalculator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ZakatCalculatorState();
}

class _ZakatCalculatorState extends State<ZakatCalculator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     appBar: AppBar(title: Text('Zakat Calculator')),
      body: onBordingBody(),
    );
  }

  Widget onBordingBody() => Container(
        child: SliderLayoutView(),
      );
}

class SliderLayoutView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SliderLayoutViewState();
}

class _SliderLayoutViewState extends State<SliderLayoutView> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) => topSliderLayout();

  Widget topSliderLayout() => Container(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: 4,
                  itemBuilder: (context, index) => SlideItem(index),
                ),
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                          padding: EdgeInsets.only(right: 15.0, bottom: 15.0),
                          child: RawMaterialButton(
                            constraints: BoxConstraints(),
                            padding: EdgeInsets.all(
                                5.0), // optional, in order to add additional space around text if needed
                            child: Text(
                              "Next",
                              style: TextStyle(
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                              ),
                            ),

                            onPressed: () {},
                          )),
                    ),
                  ],
                )
              ],
            )),
      );
}

class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    print(index);

    switch (index) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Icon(Icons.stars),
                ),
                Expanded(
                  flex: 8,
                  child: Text(
                    'Expensive Jewelry: Gold, Silver etc.(price)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),

            Divider(),
            //
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.credit_card),
                ),
                Expanded(
                  flex: 8,
                  child: Text(
                    'Bank Deposits: Fixed, Saving, Current, DPS etc.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),

            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.reorder),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Shares, savings certificate, bond, insurance, provident fund etc.',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.monetization_on),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Foreighn currency, FC account, bond, TC, cash (converted to LKR)',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(FontAwesomeIcons.rupeeSign),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Submitted Goods',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.verified_user),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Security deposit (that can be received), advance',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.timelapse),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Receivable, lent, money, advance',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.timelapse),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Others',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.timelapse),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Less: Liability',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
          ],
        );
        break;
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Icon(Icons.stars),
                ),
                Expanded(
                  flex: 8,
                  child: Text(
                    'Finished goods and goods for sell',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),

            Divider(),
            //
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.credit_card),
                ),
                Expanded(
                  flex: 8,
                  child: Text(
                    'Work in progress, raw materials and package',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),

            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.reorder),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Receivables',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.monetization_on),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Security and advance',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(FontAwesomeIcons.rupeeSign),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'All Bank deposits',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.verified_user),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Cash in hands',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.timelapse),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Others',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),          
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.timelapse),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Less: Liability',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
          ],
        );
        break;
       case 2:
         return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Icon(Icons.stars),
                ),
                Expanded(
                  flex: 8,
                  child: Text(
                    'Finished goods and goods for sell',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.credit_card),
                ),
                Expanded(
                  flex: 8,
                  child: Text(
                    'work in progress, raw materials and package',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.reorder),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Receivables',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.monetization_on),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Security and advance',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(FontAwesomeIcons.rupeeSign),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'All bank deposits',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.verified_user),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Cash in hands',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),          
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.timelapse),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Others',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
            Divider(),
            Row(
              children: <Widget>[
                  Expanded(
                  flex: 1,
                  child: Icon(Icons.timelapse),
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      'Less: Liability',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    )),
                Expanded(
                  flex: 3,
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hintText: "0",
                    ),
                    style: TextStyle(fontSize: 18, fontFamily: "Exo2"),
                    onChanged: (value) {},
                  ),
                )
              ],
            ),
          ],
        );
        break;

      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.width * 0.6,
              width: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/slider_3.png'))),
            ),
            SizedBox(
              height: 60.0,
            ),
            Text("Contribute with your zakat for appeals.",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  fontSize: 20.5,
                ),
                textAlign: TextAlign.center),
            SizedBox(
              height: 15.0,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.teal,
                  child: Text(
                    "Find Appeals",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        );
    }
  }
}
