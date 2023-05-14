import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsnews/services/utils.dart';

class TopTrendingLoadingWidget extends StatefulWidget {
  const TopTrendingLoadingWidget({super.key});

  @override
  State<TopTrendingLoadingWidget> createState() =>
      _TopTrendingLoadingWidgetState();
}

class _TopTrendingLoadingWidgetState extends State<TopTrendingLoadingWidget> {
  BorderRadius borderRadius = BorderRadius.circular(18);
  late Color baseShimmerColor, highlightShimmerColor, widgetShimmerColor;
  @override
  void didChangeDependencies() {
    var utils = Utils(context);
    baseShimmerColor = utils.baseShimmerColor;
    highlightShimmerColor = utils.highlightShimmerColor;
    widgetShimmerColor = utils.widgetShimmerColor;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Swiper(
      autoplayDelay: 8000,
      autoplay: true,
      itemWidth: size.width * 0.9,
      layout: SwiperLayout.STACK,
      viewportFraction: 0.9,
      itemCount: 5,
      itemBuilder: (context, index) {
        return TopTrendingLoadingWidget2(
            baseShimmerColor: baseShimmerColor,
            highlightShimmerColor: highlightShimmerColor,
            size: size,
            widgetShimmerColor: widgetShimmerColor,
            borderRadius: borderRadius);
      },
    );
  }
}

//toptrending Widget
class TopTrendingLoadingWidget2 extends StatelessWidget {
  const TopTrendingLoadingWidget2({
    Key? key,
    required this.baseShimmerColor,
    required this.highlightShimmerColor,
    required this.size,
    required this.widgetShimmerColor,
    required this.borderRadius,
  }) : super(key: key);

  final Color baseShimmerColor;
  final Color highlightShimmerColor;
  final Size size;
  final Color widgetShimmerColor;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        // height: size.height * 0.45,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Shimmer.fromColors(
          baseColor: baseShimmerColor,
          highlightColor: highlightShimmerColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: size.height * 0.25,
                  width: double.infinity,
                  color: widgetShimmerColor,
                ),
              ),
              // Title
              Padding(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 0),
                child: Container(
                  width: double.infinity,
                  height: size.height * 0.06,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: widgetShimmerColor,
                  ),
                ),
              ),

              // Date
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Container(
              //       height: size.height * 0.025,
              //       width: size.width * 0.4,
              //       decoration: BoxDecoration(
              //         borderRadius: borderRadius,
              //         color: widgetShimmerColor,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
