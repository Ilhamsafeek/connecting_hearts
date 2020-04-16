import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StaggeredGridExample extends StatefulWidget {
  @override
  _StaggeredGridExampleState createState() => _StaggeredGridExampleState();
}

class _StaggeredGridExampleState extends State<StaggeredGridExample> {
  final List<String> images = [
    "https://uae.microless.com/cdn/no_image.jpg",
    "https://images-na.ssl-images-amazon.com/images/I/81aF3Ob-2KL._UX679_.jpg",
    "https://www.boostmobile.com/content/dam/boostmobile/en/products/phones/apple/iphone-7/silver/device-front.png.transform/pdpCarousel/image.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgUgs8_kmuhScsx-J01d8fA1mhlCR5-1jyvMYxqCB8h3LCqcgl9Q",
    "https://ae01.alicdn.com/kf/HTB11tA5aiAKL1JjSZFoq6ygCFXaw/Unlocked-Samsung-GALAXY-S2-I9100-Mobile-Phone-Android-Wi-Fi-GPS-8-0MP-camera-Core-4.jpg_640x640.jpg",
    "https://media.ed.edmunds-media.com/gmc/sierra-3500hd/2018/td/2018_gmc_sierra-3500hd_f34_td_411183_1600.jpg",
    "https://hips.hearstapps.com/amv-prod-cad-assets.s3.amazonaws.com/images/16q1/665019/2016-chevrolet-silverado-2500hd-high-country-diesel-test-review-car-and-driver-photo-665520-s-original.jpg",
    "https://www.galeanasvandykedodge.net/assets/stock/ColorMatched_01/White/640/cc_2018DOV170002_01_640/cc_2018DOV170002_01_640_PSC.jpg",
    "https://media.onthemarket.com/properties/6191869/797156548/composite.jpg",
    "https://media.onthemarket.com/properties/6191840/797152761/composite.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) => Card(
          child: Column(
            children: <Widget>[
              Image.network(images[index]),
              Text("Some text"),
            ],
          ),
        ),
        staggeredTileBuilder: (int index) =>
        new StaggeredTile.fit(2),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    
    );
  }
}


// import 'package:flutter/material.dart';

// class Page extends StatefulWidget {
//   const Page({Key key}) : super(key: key);
//   @override
//   PageState createState() => new PageState();
// }

// class PageState extends State<Page> with SingleTickerProviderStateMixin {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Main Screen'),
//       ),
//       body: GestureDetector(
//         child: Hero(
//           tag: 'imageHero',
//           child: Image.network(
//             'https://picsum.photos/250?image=9',
//           ),
//         ),
//         onTap: () {
//           Navigator.push(context, MaterialPageRoute(builder: (_) {
//             return DetailScreen();
//           }));
//         },
//       ),
//     );
//   }
// }

// class DetailScreen extends StatefulWidget {
//   const DetailScreen({Key key}) : super(key: key);
//   @override
//   DetailScreenState createState() => new DetailScreenState();
// }

// class DetailScreenState extends State<DetailScreen> with SingleTickerProviderStateMixin {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         child: Center(
//           child: Hero(
//             tag: 'imageHero',
//             child: Image.network(
//               'https://picsum.photos/250?image=9',
//             ),
//           ),
//         ),
//         onTap: () {
//           Navigator.pop(context);
//         },
//       ),
//     );
//   }
// }
