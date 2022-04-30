import 'package:async_button_builder/async_button_builder.dart';
import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:cryptocurrency_app/models/pair/pair_summary/pair_summary.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../../generated/locale_keys.g.dart';

createOrder(pairData, order_type, qty) async {
  var blocUrl = Uri.parse('http://127.0.0.1:8000/mine_block/');
  dynamic data = {
    'type_data': pairData,
    'order_type': order_type,
    'Qty': qty,
  };

  Dio dio = Dio();
  var response = await dio.post('$blocUrl', queryParameters: data);
  print(response);
}

class SummarySection extends StatelessWidget {
  final PairSummary data;
  late var quantity;
  late var orderType;
  SummarySection({
    Key? key,
    required this.data,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: BeautyTextfield(
                      width: 200,
                      height: 60,
                      duration: Duration(milliseconds: 300),
                      inputType: TextInputType.text,
                      prefixIcon: Icon(
                        Icons.currency_exchange_outlined,
                        size: 10.0,
                      ),
                      placeholder: "  Quantity",
                      onTap: () {
                        print('Click');
                      },
                      onChanged: (t) {
                        print(t);
                      },
                      onSubmitted: (d) async {
                        quantity = d;
                        await createOrder(data.price.last, orderType, d);
                        print(orderType);
                        MotionToast.success(
                                title: Text("$orderType " + d + " Contracts"),
                                description: Text(
                                  "Order filled successfully",
                                ),
                                width: 300)
                            .show(context);
                        print(d);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  AsyncButtonBuilder(
                    child: Text(
                      'Buy',
                      style: TextStyle(
                        color: Color(0xff02d39a),
                      ),
                    ),
                    onPressed: () async {
                      await Future.delayed(
                        Duration(seconds: 1),
                      );
                      orderType = 'Bought';
                    },
                    builder: (context, child, callback, _) {
                      return TextButton(
                        child: child,
                        onPressed: callback,
                      );
                    },
                  ),
                  AsyncButtonBuilder(
                    child: Text(
                      'Sell',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onPressed: () async {
                      await Future.delayed(
                        Duration(seconds: 1),
                      );
                      orderType = 'Sold';
                    },
                    builder: (context, child, callback, _) {
                      return TextButton(
                        child: child,
                        onPressed: callback,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    LocaleKeys.price.tr(),
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.last.tr(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                data.price.last.toString(),
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.high.tr(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                data.price.high.toString(),
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.low.tr(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                data.price.low.toString(),
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.change.tr(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                data.price.change.absolute.toString(),
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                LocaleKeys.volume.tr(),
                style: Theme.of(context).textTheme.subtitle2,
              )
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.volume.tr(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                data.volume.toString(),
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleKeys.quoteVolume.tr(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                data.volumeQuote.toString(),
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          ),
        ],
      ),
    );
  }
}
