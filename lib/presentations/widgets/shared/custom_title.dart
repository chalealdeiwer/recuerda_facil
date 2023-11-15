import 'package:flutter/material.dart';

Widget customTitle(BuildContext context,{required String title1, required int size1, String title2 = "",int size2 = 0}){
  final colors = Theme.of(context).colorScheme;
  final size= MediaQuery.of(context).size;
  return  Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colors.surfaceVariant.withOpacity(0.5),
            ),
            margin: EdgeInsets.symmetric(horizontal: size.width * 0.2),
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title1,
                    style: TextStyle(
                        fontFamily: 'SpicyRice-Regular',
                        fontSize: size1.toDouble(),
                        color: colors.primary),
                        textScaleFactor: 1,
                  ),
                  Text(
                    title2,
                    style: TextStyle(
                        fontFamily: 'SpicyRice-Regular',
                        fontSize: size2.toDouble(),
                        color: colors.secondary),
                        textScaleFactor: 1,
                  ),
                ],
              ),
            )
          );
}