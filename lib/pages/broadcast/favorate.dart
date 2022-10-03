import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FavorateView extends StatefulWidget {
  const FavorateView({super.key});

  @override
  State<FavorateView> createState() => _FavorateViewState();
}

class _FavorateViewState extends State<FavorateView> {
  final ScrollController _scrollController = ScrollController();

  List listData = [
    {
      "title": "标题1",
      "author": "内容1",
      "image": "https://www.itying.com/images/flutter/1.png"
    },
    {
      "title": "标题2",
      "author": "内容2",
      "image": "https://www.itying.com/images/flutter/2.png"
    },
    {
      "title": "标题3",
      "author": "内容3",
      "image": "https://www.itying.com/images/flutter/3.png"
    },
    {
      "title": "标题4",
      "author": "内容4",
      "image": "https://www.itying.com/images/flutter/4.png"
    },
    {
      "title": "标题5",
      "author": "内容5",
      "image": "https://www.itying.com/images/flutter/5.png"
    },
    {
      "title": "标题6",
      "author": "内容6",
      "image": "https://www.itying.com/images/flutter/6.png"
    },
    {
      "title": "标题7",
      "author": "内容7",
      "image": "https://www.itying.com/images/flutter/7.png"
    },
    {
      "title": "标题8",
      "author": "内容8",
      "image": "https://www.chiyustudio.com:81/tingfm/隋唐演义·田连元|田连元/隋唐演义·田连元.png"
    }
    // {
    //   "title": "标题9",
    //   "author": "内容9",
    //   "image": "https://www.itying.com/images/flutter/2.png"
    // }
  ];
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (
      BuildContext context,
      BoxConstraints constraints,
    ) {
      return GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //设置列数
          crossAxisCount: 3,
          //设置横向间距
          crossAxisSpacing: 5,
          //设置主轴间距
          mainAxisSpacing: 5,
        ),
        scrollDirection: Axis.vertical,
        itemCount: listData.length,
        itemBuilder: (context, index) {
          return Card(
              elevation: 0.2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  CachedNetworkImage(
                    fit: BoxFit.cover,
                    errorWidget: (BuildContext context, _, __) => const Image(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/images/cover.jpg',
                      ),
                    ),
                    placeholder: (BuildContext context, _) => const Image(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/images/cover.jpg',
                      ),
                    ),
                    imageUrl: listData[index]["image"],
                  ),
                ],
              ));
        },
      );
    });
  }
}
