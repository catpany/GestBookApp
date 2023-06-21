import 'dart:developer';

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
import 'learned.dart';


class DictionariesScreen extends StatefulWidget {
  const DictionariesScreen({Key? key}) : super(key: key);

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

  PreferredSizeWidget _renderTopBar() {
    return AppBar(
      title: const Text('ЖЕСТЫ', style: TextStyles.title18Medium),
      flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [ColorStyles.orange, ColorStyles.accent]))),      shadowColor: Colors.transparent,
      centerTitle: true,
      bottom: const TabBar(
        indicatorColor: ColorStyles.white,
        tabs: [
          Tab(icon: Icon(Icons.search)),
          Tab(icon: Icon(Icons.file_download_outlined)),
          Tab(icon: Icon(Icons.star_rounded)),
          // Tab(icon: Icon(Icons.layers_outlined)),
        ],
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
                body: const TabBarView(
                        children: [
                          SearchScreen(),
                          SavedScreen(),
                          FavoritesScreen(),
                          // LearnedScreen(),
                        ],
                      )
            )));
  }
}
