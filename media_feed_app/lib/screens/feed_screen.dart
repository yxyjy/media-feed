import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/feed_notifier.dart';
import '../providers/feed_state.dart';
import 'widgets/feed_item_card.dart';
import 'widgets/feed_loader.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // final feedState = ref.read(feedProvider);
    // if (feedState.status == FeedStatus.loadingMore) return;
    // if (feedState.status == FeedStatus.noMoreData) return;
    // if (feedState.status == FeedStatus.loadingFirst) return;

    // final maxScroll = _scrollController.position.maxScrollExtent;
    // final currentScroll = _scrollController.position.pixels;

    // if (currentScroll >= maxScroll * 0.60) {
    //   ref.read(feedProvider.notifier).fetchNextPage();
    // }
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFdfdfd),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                'PetBacker',
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    color: const Color.fromARGB(255, 171, 148, 211),
                    letterSpacing: .3,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 171, 148, 211),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Feed',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 66, 57, 95),
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.w800,
                        fontSize: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(child: _buildBody(feedState)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(FeedState feedState) {
    if (feedState.status == FeedStatus.loadingFirst) {
      return ListView.builder(
        itemCount: 4,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (_, __) => const FeedShimmerCard(),
      );
    }

    if (feedState.status == FeedStatus.error && feedState.moments.isEmpty) {
      return Center(
        child: FeedErrorWidget(
          message: feedState.errorMessage ?? 'Unknown error',
          onRetry: () => ref.read(feedProvider.notifier).fetchFirstPage(),
        ),
      );
    }

    return RefreshIndicator(
      color: Colors.deepPurple.shade400,
      onRefresh: () => ref.read(feedProvider.notifier).fetchFirstPage(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: feedState.moments.length + 1,
        itemBuilder: (context, index) {
          final itemsLeft = feedState.moments.length - index;

          if (itemsLeft <= 3 &&
              feedState.status != FeedStatus.loadingMore &&
              feedState.status != FeedStatus.noMoreData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(feedProvider.notifier).fetchNextPage();
            });
          }

          if (index == feedState.moments.length) {
            return _buildFooter(feedState);
          }
          return FeedItemCard(moment: feedState.moments[index]);
        },
      ),
    );
  }

  Widget _buildFooter(FeedState feedState) {
    switch (feedState.status) {
      case FeedStatus.loadingMore:
        return const FeedBottomLoader();
      case FeedStatus.error:
        return FeedErrorWidget(
          message: feedState.errorMessage ?? 'Failed to load more',
          onRetry: () => ref.read(feedProvider.notifier).retry(),
        );
      case FeedStatus.noMoreData:
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Text(
              "You're all caught up!",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
