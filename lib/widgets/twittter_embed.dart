import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsnews/providers/theme_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TwitterEmbedd extends StatefulWidget {
  final String twitterId;

  const TwitterEmbedd({super.key, required this.twitterId});

  @override
  State<TwitterEmbedd> createState() => _TwitterEmbeddState();
}

class _TwitterEmbeddState extends State<TwitterEmbedd> {
  late bool isLoaded;
  late String themeMode = "";
  @override
  void initState() {
    super.initState();
    isLoaded = false;
  }

  @override
  Widget build(BuildContext context) {
    //1665264487090323457
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.getDarkTheme;
    //log(widget.twitterId);
    if (isDarkMode == true) {
      setState(() {
        themeMode = "dark";
      });
    } else {
      setState(() {
        themeMode = "white";
      });
    }
    return Stack(
      children: [
        WebView(
          initialUrl: Uri.dataFromString(
            getHtmlString(widget.twitterId, themeMode),
            mimeType: 'text/html',
            encoding: Encoding.getByName('utf-8'),
          ).toString(),
          javascriptMode: JavascriptMode.unrestricted,
          gestureNavigationEnabled: false,

          // javascriptChannels: <JavascriptChannel>{}..add(JavascriptChannel(
          //     name: 'twitter',
          //     onMessageReceived: (JavascriptMessage message) {
          //       setState(() {
          //         isLoaded = true;
          //       });
          //     })),
          javascriptChannels: <JavascriptChannel>{
            JavascriptChannel(
                name: 'Twitter',
                onMessageReceived: (JavascriptMessage message) {
                  setState(() {
                    isLoaded = true;
                  });
                })
          },
        ),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(microseconds: 300),
            transitionBuilder: ((child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            }),
            child: isLoaded
                ? const SizedBox.shrink()
                : const CircularProgressIndicator(),
          ),
        )
      ],
    );
  }
}

String getHtmlString(String tweetId, String themeMode) {
  return """
      <html>
      
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1">
        </head>
        <body>
            <div id="container"></div>
                
        </body>
        <script id="twitter-wjs" type="text/javascript" async defer src="https://platform.twitter.com/widgets.js" onload="createMyTweet()"></script>
        <script>
        
       
      function  createMyTweet() {  
         var twtter = window.twttr;
  
         twttr.widgets.createTweet(
          '$tweetId',
          document.getElementById('container'),
          {
            theme:'$themeMode',
          }
        ).then(function (el){
          Twitter.postMessage("Tweet Loaded");
        });
 
        
      }
        </script>
        
      </html>
    """;
}
