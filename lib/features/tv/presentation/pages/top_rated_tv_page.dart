import 'package:core/core.dart';
import 'package:ditonton_submission1/features/tv/presentation/bloc/top_rated/top_rated_tv_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/widgets/media_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvPage extends StatefulWidget {
  const TopRatedTvPage({super.key});

  @override
  State<TopRatedTvPage> createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<TopRatedTvBloc>().add(FetchTopRatedTv());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated TV Shows')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvBloc, TopRatedTvState>(
          builder: (context, state) {
            if (state is TopRatedTvLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TopRatedTvHasData) {
              final result = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = result[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushNamed(tvDetailRoute, arguments: tv.id);
                    },
                    child: MediaCardList(media: tv, isMovie: false),
                  );
                },
                itemCount: result.length,
              );
            } else if (state is TopRatedTvError) {
              return Center(
                child: Text(key: Key('error_message'), state.message),
              );
            } else if (state is TopRatedTvEmpty) {
              return Center(child: Text(key: Key('empty_message'), 'No Data'));
            } else {
              return Center(child: Text('Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}
