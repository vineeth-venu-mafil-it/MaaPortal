import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/styles/colors.dart';
import 'custom_text.dart';

// Shimmer Widget Class
class ShimmerWidget extends StatelessWidget {
  final double height;
  final double width;

  const ShimmerWidget({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

// Card Item Widget Class

class BuildCardItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool? loadingStatus;
  final Function() onTap;
  final int curIndex;
  final int selectedIndex;

  const BuildCardItem({
    super.key,
    required this.item,
    this.loadingStatus,
    required this.onTap,
    required this.curIndex,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final Color cardColor = item['cardColor'] as Color;
    final Color cardTitleColor = item['cardTitle'] as Color;
    final String logoPath = item['logo'] as String;
    final String title = item['title'] as String;
    return InkWell(
        onTap: onTap,
        child:  Material(
          color: Colors.transparent,
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              // border: Border.all(color: Colors.grey, width: 0.6),

              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.orange, Colors.yellow],
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Container(
                        width: 24.0,
                        height: 24.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child:  loadingStatus == true && curIndex == selectedIndex
                            ?SizedBox( width: 24.0,
                          height: 24.0,child: CircularProgressIndicator(color: AppColor.drawerColor,),): SvgPicture.asset(
                          item['logo'] as String,
                          width: 24.0,
                          height: 24.0,
                          color: item['cardTitle'] as Color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'poppinsRegular',
                              color: AppColor.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}


class BuildGridItem extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool? loadingStatus;
  final Function() onTap;
  final int curIndex;
  final int selectedIndex;

  const BuildGridItem({
    super.key,
    required this.item,
    this.loadingStatus,
    required this.onTap,
    required this.curIndex,
    required this.selectedIndex,
  });


  @override
  Widget build(BuildContext context) {
    final Color cardColor = item['cardColor'] as Color;
    final Color cardTitleColor = item['cardTitle'] as Color;
    final String logoPath = item['logo'] as String;
    final String title = item['title'] as String;

    return InkWell(
      onTap: onTap,
      child:  Material(
        color: Colors.transparent,
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            // border: Border.all(color: Colors.grey, width: 0.6),

            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.orange, Colors.yellow],
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Container(
                      width: 24.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child:  loadingStatus == true && curIndex == selectedIndex
                          ?SizedBox( width: 24.0,
                        height: 24.0,child: CircularProgressIndicator(color: AppColor.drawerColor,),): SvgPicture.asset(
                        item['logo'] as String,
                        width: 24.0,
                        height: 24.0,
                        color: item['cardTitle'] as Color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                      title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'poppinsRegular',
                          color: AppColor.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}


