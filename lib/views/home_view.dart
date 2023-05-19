import 'package:flutter/material.dart';
import 'package:netflix_redesign/data/data_image.dart';
import 'package:netflix_redesign/views/widgets/image_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late ScrollController _scrollController;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  double _scrollOffset = 0.0;

  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: _buildAppBar(screenSize, _scrollOffset),
      body: _buildBody(screenSize),
    );
  }

  PreferredSize _buildAppBar(Size screenSize, double scrollOffset) {
    TextStyle textStyle = const TextStyle(color: Colors.white, fontSize: 14);
    return PreferredSize(
      preferredSize: Size(screenSize.width, 50.0),
      child: AppBar(
        title: scrollOffset < 165
            ? Image.asset(
                'assets/images/netflix2.png',
                width: 90,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/netflix1.png',
                    width: 30,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'TV Shows',
                          style: textStyle,
                        ),
                        Text('Movies', style: textStyle),
                        Row(
                          children: [Text('Categories', style: textStyle), const SizedBox(width: 2), const Icon(Icons.arrow_drop_down, color: Colors.white)],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        centerTitle: true,
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.black.withOpacity((scrollOffset / 350).clamp(0, 1).toDouble()),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage(
                "assets/images/image2.jpg",
              ),
              radius: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(Size screenSize) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      header: BezierHeader(bezierColor: Colors.white),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          _contentHeader(screenSize),
          _buildMovieListSection('Popular on Netflix', DataImage.popularList),
          _buildMovieListSection('My List', DataImage.mylist),
          _buildMovieListSection('Trending List', DataImage.trendingList),
          const SliverPadding(padding: EdgeInsets.symmetric(vertical: 45)),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildMovieListSection(String label, List<dynamic> imageList) {
    return SliverToBoxAdapter(
      child: ImageList(
        label: label,
        imageList: imageList,
      ),
    );
  }

  SliverToBoxAdapter _contentHeader(Size screenSize) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Container(
            height: screenSize.height / 1.3,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: screenSize.height / 3.0,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 80,
            child: _buildTopMenu(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                const Text(
                  'ไทย - แอ็คชั่นไทย - ดราม่า - อาชญากรรม',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Column(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        Text(
                          'My List',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    _buildCustomPlayButton(),
                    const Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
                        Text(
                          'Info',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InkWell _buildCustomPlayButton() {
    return InkWell(
      onTap: () {},
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: const Padding(
          padding: EdgeInsets.only(left: 20, right: 25, bottom: 8, top: 8),
          child: Row(
            children: [
              Icon(
                Icons.play_arrow,
              ),
              Text(
                'Play',
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopMenu() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'TV Shows',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Text(
          'Movies',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        Row(
          children: [
            Text(
              'Categories',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(width: 2),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            )
          ],
        ),
      ],
    );
  }
}
