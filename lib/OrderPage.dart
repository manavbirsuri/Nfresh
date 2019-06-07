import 'package:flutter/material.dart';


class OrderPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: stateOrder(),
    );

  }

}
class stateOrder extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return stateOrderPage();
  }
}
class stateOrderPage extends State<stateOrder> {
  @override
  Widget build(BuildContext context) {

    return new Stack(
      children: <Widget>[
    SizedBox.expand(
    child: Image.asset(
      'assets/sigbg.jpg',
      fit: BoxFit.fill,
    ),
    )]);
  }

}