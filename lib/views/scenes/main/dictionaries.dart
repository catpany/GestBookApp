import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigest/bloc/favorites/favorites_cubit.dart';
import 'package:sigest/bloc/learned/learned_cubit.dart';
import 'package:sigest/views/scenes/main/saved.dart';
import 'package:sigest/views/scenes/main/search.dart';
import 'package:sigest/views/styles.dart';

import '../../../bloc/saved/saved_cubit.dart';
import '../../../bloc/search/search_cubit.dart';
import 'favorites.dart';

class DictionariesScreen extends StatefulWidget {
  const DictionariesScreen({Key? key})
      : super(key: key);

  @override
  _DictionariesScreenState createState() => _DictionariesScreenState();
}

class _DictionariesScreenState extends State<DictionariesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _getTabs() {
      return [
        const Tab(icon: Icon(Icons.search)),
        const Tab(icon: Icon(Icons.file_download_outlined)),
        const Tab(icon: Icon(Icons.star_rounded)),
        // Tab(icon: Icon(Icons.layers_outlined)),
      ];
  }

  List<Widget> _getTabViews() {
      return [
        const SearchScreen(),
        const SavedScreen(),
        const FavoritesScreen(),
        // LearnedScreen(),
      ];
  }

  PreferredSizeWidget _renderTopBar() {
    return AppBar(
      title: Text('ЖЕСТЫ', style: Theme.of(context).textTheme.titleSmall),
      flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [ColorStyles.orange, ColorStyles.accent]))),
      shadowColor: Colors.transparent,
      centerTitle: true,
      bottom: TabBar(
        indicatorColor: ColorStyles.white,
        tabs: _getTabs(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<SearchCubit>(
            lazy: false,
            create: (BuildContext context) => SearchCubit(),
          ),
          BlocProvider<SavedCubit>(
            lazy: false,
            create: (BuildContext context) => SavedCubit(),
          ),
          // BlocProvider<LearnedCubit>(
          //   lazy: false,
          //   create: (BuildContext context) => LearnedCubit(),
          // ),
          BlocProvider<FavoritesCubit>(
            lazy: false,
            create: (BuildContext context) => FavoritesCubit(),
          ),
        ],
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: _renderTopBar(),
                body: TabBarView(
                  children: _getTabViews(),
                ))));
  }
}
