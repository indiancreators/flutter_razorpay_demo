import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: CartScreen(),
    );
  }
}

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  var itemSize = 1;
  var itemPrices = 15;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A5D83),
        title: const Text("Indian Creator"),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            cartItemsList(),

          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: openCheckout,
          child: Container(
            height: 50,
            decoration:  BoxDecoration(
                color: const Color(0xFF0A5D83),
                borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: const Text(
              "Place order",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget cartItemsList() {
    return ListView.builder(
      itemCount: 1,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return cartItem();
      },
    );
  }

  Widget cartItem() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Image.asset(
                      "assets/tshirt.jpg"),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Text("Half Sleeve Tshirt"),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: (){
                              if(itemSize >=2){
                                itemSize -= 1;
                                itemPrices -= 15;
                                setState(() {
                                });
                              }
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration:  BoxDecoration(
                                  color: const Color(0xFF0A5D83),
                                  borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: const Text("-",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          ),
                          Text(itemSize.toString(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          InkWell(
                            onTap: (){
                              itemSize += 1;
                              itemPrices += 15;
                              setState(() {
                              });
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration:  BoxDecoration(
                                color: const Color(0xFF0A5D83),
                                  borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: const Text("+",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(" \$${itemPrices.toString()}",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void openCheckout() async {
    double price = 5000.56 * 100;
    // int.parse((price*100).toString());
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': itemPrices * 75 * 100 ,
      'name': 'IndianCreator',
      'description': 'This is a Text Payment',
      'prefill': {'contact': '8888888888', 'email': 'contact@indiancreator.in'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e as String?);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS: ${response.paymentId}", timeInSecForIosWeb: 4);
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
      return const PaymentSuccessful();
    }));
  }
  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: ${response.code} - ${response.message}",
        timeInSecForIosWeb: 4);
  }
  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName}", timeInSecForIosWeb: 4);
  }
}

class PaymentSuccessful extends StatelessWidget {
  const PaymentSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Successful"),
      ),body: const Text("Payment Successful",style: TextStyle(fontSize: 18),),
    );
  }
}