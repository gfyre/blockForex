import 'dart:convert';

import 'package:async_button_builder/async_button_builder.dart';
import 'package:cryptocurrency_app/constants/keys.dart';
import 'package:cryptocurrency_app/models/trades/trade/trade.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../constants/utils.dart' as Utils;
import 'package:http/http.dart' as http;

Dio dio = Dio();
Future getData() async {
  var tradeBook = await dio.get('http://127.0.0.1:8000/blockchain/');
  print(tradeBook.data['index'].toString());
  // tradeBook.data['Currency_Pair'];
}

class TradesSection extends StatelessWidget {
  final List<Trade> data;
  const TradesSection({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                  // AsyncButtonBuilder(
                  //   child: Text(
                  //     'Fetch Orders',
                  //     style: TextStyle(
                  //       color: Color(0xff02d39a),
                  //     ),
                  //   ),
                  //   onPressed: () async {
                  //     await getData();
                  //   },
                  //   builder: (context, child, callback, _) {
                  //     return TextButton(
                  //       child: child,
                  //       onPressed: callback,
                  //     );
                  //   },
                  // ),
                  Expanded(
                    child: Text(
                      LocaleKeys.time.tr(),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      LocaleKeys.price.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      LocaleKeys.amount.tr(),
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            height: 250,
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          Utils.epochToString(data[index].timestamp),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          data[index].price,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          data[index].amount,
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceOrder {
  String currencyPair;
  int quantity;
  bool buy;
  bool sell;

  var blocUrl = Uri.parse('http://127.0.0.1:8000/mine_block/');
  PlaceOrder({
    required this.currencyPair,
    required this.quantity,
    required this.buy,
    required this.sell,
  });

  createOrder(pairData, buy, sell, qty) async {
    var blocUrl = Uri.parse('http://127.0.0.1:8000/mine_block/');
    dynamic data = {
      'type_data': pairData,
      'Buy': buy,
      'Sell': sell,
      'Qty': qty,
    };

    Dio dio = Dio();
    var response = await dio.post('$blocUrl', queryParameters: data);
    // print(response);
  }

  Widget? OrderWindow() {
    return Container(
      child: Row(children: [
        AsyncButtonBuilder(
          child: Text('Click Me'),
          onPressed: () async {
            await Future.delayed(Duration(seconds: 1));
          },
          builder: (context, child, callback, _) {
            return TextButton(
              child: child,
              onPressed: callback,
            );
          },
        ),
      ]),
    );
  }
}
