import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tingfm/pages/auth/auth.dart';
import 'package:tingfm/pages/broadcast/broadcast.dart';
import 'package:tingfm/pages/index/index.dart';
import 'package:tingfm/pages/my/my.dart';
import 'package:tingfm/widgets/custom_physics.dart';
import 'package:tingfm/widgets/mini_player.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
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
                    const Color.fromARGB(255, 246, 246, 246),
                shadowColor: const Color.fromARGB(255, 245, 245, 245),
                cardColor: const Color.fromARGB(255, 254, 254, 254),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color.fromARGB(255, 246, 246, 246),
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  foregroundColor: Colors.black,
                ),
                sliderTheme: const SliderThemeData(
                  thumbColor: Color.fromARGB(255, 234, 78, 94),
                  activeTrackColor: Color.fromARGB(120, 234, 78, 94),
                  overlayColor: Color.fromARGB(120, 234, 78, 94),
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
                                    IndexPage(),
                                    BroadcastPage(),
                                    MyPage(),
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
                                            title: const Text("书场"),
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
