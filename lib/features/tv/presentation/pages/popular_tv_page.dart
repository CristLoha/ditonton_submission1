import 'package:ditonton_submission1/features/tv/presentation/bloc/popular/popular_tv_bloc.dart';
import 'package:ditonton_submission1/features/tv/presentation/widgets/media_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvPage extends StatefulWidget {
  const PopularTvPage({super.key});

  @override
  State<PopularTvPage> createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<PopularTvBloc>().add(FetchPopularTvData());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular TV Shows')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvBloc, PopularTvState>(
          builder: (context, state) {
            if (state is PopularTvLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PopularTvHasData) {
              final data = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data[index];
                  return MediaCardList(media: tv, isMovie: false);
                },
                itemCount: data.length,
              );
            } else if (state is PopularTvError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}
