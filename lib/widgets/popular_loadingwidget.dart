import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsnews/services/utils.dart';

class PopularLoadingWidget extends StatefulWidget {
  const PopularLoadingWidget({super.key});

  @override
  State<PopularLoadingWidget> createState() => _PopularLoadingWidgetState();
}

class _PopularLoadingWidgetState extends State<PopularLoadingWidget> {
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
    return PopularNewsShimmer(
        baseShimmerColor: baseShimmerColor,
        highlightShimmerColor: highlightShimmerColor,
        widgetShimmerColor: widgetShimmerColor,
        size: size,
        borderRadius: borderRadius);
  }
}

class PopularNewsShimmer extends StatelessWidget {
  final Color baseShimmerColor;
  final Color highlightShimmerColor;
  final Color widgetShimmerColor;
  final Size size;
  final BorderRadius borderRadius;
  const PopularNewsShimmer({
    super.key,
    required this.baseShimmerColor,
    required this.highlightShimmerColor,
    required this.widgetShimmerColor,
    required this.size,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
      child: Shimmer.fromColors(
        baseColor: baseShimmerColor,
        highlightColor: highlightShimmerColor,
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(left: 8),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text(
            //         "Popular",
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontSize: 18,
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: () {},
            //         style: TextButton.styleFrom(foregroundColor: Colors.blue),
            //         child: const Text("See All"),
            //       )
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 10),
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 16),
                      width: 200,
                      // color: Colors.blue,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: size.height * 0.25,
                                    width: double.infinity,
                                    color: widgetShimmerColor,
                                  ))),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Container(
                              width: double.infinity,
                              height: size.height * 0.05,
                              decoration: BoxDecoration(
                                borderRadius: borderRadius,
                                color: widgetShimmerColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
