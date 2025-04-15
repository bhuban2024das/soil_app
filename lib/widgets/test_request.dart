import 'dart:async';

import 'package:dsi_pro/dsi_pro.dart';
import 'package:original/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class TestRequestWidget extends StatelessWidget {
  const TestRequestWidget({super.key, required this.cartItem});

  final Product cartItem;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,
        ),
        child: const Icon(
          IconlyLight.delete,
          color: Colors.white,
          size: 25,
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        final completer = Completer<bool>();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: "Keep",
              onPressed: () {
                completer.complete(false);
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
              },
            ),
            content: const Text(
              "Remove from cart?",
            ),
          ),
        );
        Timer(const Duration(seconds: 3), () {
          if (!completer.isCompleted) {
            completer.complete(true);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          }
        });

        return await completer.future;
      },
      child: SizedBox(
        height: 125,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          elevation: 0.1,
          child: Stack(
            children: [
              Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    Icons.timelapse_rounded,
                    color: const Color.fromARGB(96, 179, 57, 48),
                    size: 90,
                  )),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      height: double.infinity,
                      width: 90,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(cartItem.image),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cartItem.name,
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 2),
                          Text(
                            cartItem.description,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "₹${cartItem.price}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                              H4(
                                  text: "Pending".toUpperCase(),
                                  color: Colors.grey.shade500),
                              SizedBox(
                                height: 30,
                                child: Row(
                                  children: [
                                    Icon(
                                      IconlyBold.calendar,
                                      color: Colors.grey.shade500,
                                      size: 19,
                                    ),
                                    SizedBox(width: 5),
                                    Text("11-01-2025"),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
