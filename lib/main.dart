import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tingfm/global/global.dart';
import 'package:tingfm/pages/home/home.dart';
import 'package:tingfm/pages/my/my.dart';
import 'package:tingfm/pages/player/player.dart';
import 'package:tingfm/widgets/custom_physics.dart';
import 'package:tingfm/widgets/mini_player.dart';

Future<void> main() => Global.init().then((e) => runApp(const MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(Object context) {
    return ScreenUtilInit(
        designSize: const Size(1125, 2346),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                scaffoldBackgroundColor:
                    const Color.fromARGB(255, 245, 245, 245),
                shadowColor: const Color.fromARGB(255, 245, 245, 245),
                cardColor: const Color.fromARGB(255, 254, 254, 254),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color.fromARGB(255, 245, 245, 245),
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  foregroundColor: Colors.black,
                ),
              ),
              home: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                      body: SafeArea(
                        child: Column(
                          children: [
                            Expanded(
                              child: PageView(
                                  physics: const CustomPhysics(),
                                  onPageChanged: onPageChanged,
                                  controller: _pageController,
                                  children: const [
                                    HomePage(),
                                    PlayerPage(),
                                    MyPage()
                                  ]),
                            ),
                            const MiniPlayer(),
                          ],
                        ),
                      ),
                      bottomNavigationBar: SafeArea(
                        child: ValueListenableBuilder(
                            valueListenable: _selectedIndex,
                            builder: (BuildContext context, int indexValue,
                                Widget? child) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 100),
                                height: 60,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  child: SalomonBottomBar(
                                      currentIndex: indexValue,
                                      onTap: (index) {
                                        onItemTapped(index);
                                      },
                                      items: [
                                        SalomonBottomBarItem(
                                            icon: const Icon(
                                                Icons.multitrack_audio),
                                            title: const Text("探索"),
                                            selectedColor: const Color.fromARGB(
                                                255, 234, 78, 94)),
                                        SalomonBottomBarItem(
                                            icon: const Icon(
                                                Icons.trending_up_rounded),
                                            title: const Text("收听"),
                                            selectedColor: const Color.fromARGB(
                                                255, 234, 78, 94)),
                                        SalomonBottomBarItem(
                                            icon: const Icon(
                                                Icons.panorama_fisheye_rounded),
                                            title: const Text("听书铺子"),
                                            selectedColor: const Color.fromARGB(
                                                255, 234, 78, 94)),
                                      ]),
                                ),
                              );
                            }),
                      ))));
        });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void onItemTapped(int index) {
    onPageChanged(index);
    _pageController.jumpToPage(
      index,
    );
  }

  void onPageChanged(int index) {
    _selectedIndex.value = index;
  }
}
