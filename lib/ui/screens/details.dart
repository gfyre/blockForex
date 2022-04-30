import 'package:async_button_builder/async_button_builder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:cryptocurrency_app/constants/keys.dart';
import 'package:cryptocurrency_app/constants/utils.dart' as Utils;
import 'package:cryptocurrency_app/models/markets/pair/pair.dart';
import 'package:cryptocurrency_app/provider/crypto_provider.dart';
import 'package:cryptocurrency_app/ui/widgets/details/details_widget.dart';
import 'package:cryptocurrency_app/ui/widgets/details/time_bar_selector.dart';
import 'package:cryptocurrency_app/ui/widgets/line_chart.dart';
import 'package:cryptocurrency_app/ui/widgets/title_price.dart';

class DetailsScreen extends HookConsumerWidget {
  final Pair pair;
  DetailsScreen({required this.pair});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graph = ref.watch(graphDataProvider(pair));

    return Scaffold(
      key: Keys.DETAILS_SCREEN,
      appBar: AppBar(
        actions: [
          Container(
            width: 120,
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TitlePrice(pair: pair),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 250,
                child: graph.when(
                    data: (data) =>
                        LineChartWidget(data: Utils.getPoints(data)),
                    loading: () => LineChartWidget(loading: true),
                    error: (e, ex) => LineChartWidget(error: true)),
              ),
              SizedBox(
                height: 20,
              ),
              // OrderWindow(),
              TimeBarSelector(),
              SizedBox(
                height: 15,
              ),
              DetailsWidget(pair: pair),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
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
