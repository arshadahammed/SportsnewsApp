import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sportsnews/ads_helper/ads_helper.dart';
import 'package:sportsnews/models/news_model.dart';
import 'package:sportsnews/widgets/vertical_spacing.dart';

import '../consts/vars.dart';
import '../providers/news_provider.dart';
import '../services/utils.dart';
import '../widgets/articles_widget.dart';
import '../widgets/empty_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchTextController;
  late final FocusNode focusNode;

  final adPosition = 0;
  late BannerAd _inlineBannerAd;
  bool _isInlineBannerAdLoaded = false;

//inline Ad
  void _createInlineBannerAd() {
    _inlineBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isInlineBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _inlineBannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
    focusNode = FocusNode();
    _createInlineBannerAd();
  }

  List<NewsModel>? searchList = [];
  bool isSearching = false;
  @override
  void dispose() {
    if (mounted) {
      _searchTextController.dispose();
      focusNode.dispose();
    }
    super.dispose();
    _inlineBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;
    final newsProvider = Provider.of<NewsProvider>(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      focusNode.unfocus();
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      IconlyLight.arrowLeft2,
                    ),
                  ),
                  Flexible(
                      child: TextField(
                    focusNode: focusNode,
                    controller: _searchTextController,
                    style: TextStyle(color: color),
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.text,
                    onEditingComplete: () async {
                      searchList = await newsProvider.searchSlugNewsProvider(
                          query: _searchTextController.text);
                      isSearching = true;
                      focusNode.unfocus();
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        bottom: 8 / 5,
                      ),
                      hintText: "Search",
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      suffix: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            _searchTextController.clear();
                            focusNode.unfocus();
                            isSearching = false;
                            // searchList =[];
                            searchList!.clear();
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ))
                ],
              ),
            ),
            const VerticalSpacing(10),
            if (!isSearching && searchList!.isEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MasonryGridView.count(
                    itemCount: searchKeywords.length,
                    crossAxisCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          isSearching = true;
                          _searchTextController.text = searchKeywords[index];

                          searchList =
                              await newsProvider.searchSlugNewsProvider(
                                  query: _searchTextController.text.trim());
                          focusNode.unfocus();
                          setState(() {});
                        },
                        child: Container(
                            margin: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: color),
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: FittedBox(
                                  child: Text(searchKeywords[index]),
                                ),
                              ),
                            )),
                      );
                    },
                  ),
                ),
              ),
            if (isSearching && searchList!.isEmpty)
              const Expanded(
                child: EmptyNewsWidget(
                  text: "Ops! No resuls found",
                  imagePath: 'assets/images/search.png',
                ),
              ),
            if (searchList != null && searchList!.isNotEmpty)
              Expanded(
                child: ListView.builder(
                    itemCount: searchList!.length + 1,
                    itemBuilder: (ctx, index) {
                      if (index == adPosition && _isInlineBannerAdLoaded) {
                        // Render the ad widget
                        return Container(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          width: _inlineBannerAd.size.width.toDouble(),
                          height: _inlineBannerAd.size.height.toDouble(),
                          child: AdWidget(ad: _inlineBannerAd),
                        ); //  // Replace with your ad widget implementation
                      } else {
                        // Calculate the actual index excluding the ad position
                        int actualIndex =
                            index > adPosition ? index - 1 : index;

                        return ChangeNotifierProvider.value(
                          value: searchList![actualIndex],
                          child: const ArticlesWidget(),
                        );
                      }
                    }),
              ),
          ],
        )),
      ),
    );
  }
}
