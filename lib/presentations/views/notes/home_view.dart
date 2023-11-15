import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});
  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(
    BuildContext context,
  ) {
    super.build(context);
    final colors = Theme.of(context).colorScheme;
    final isListeningProv = ref.watch(isListeningProvider);
    final textProv = ref.watch(textProvider);
    final clockVisibility = ref.watch(clockVisibilityProvider);
    final categoriesVisibility = ref.watch(categoriesVisibilityProvider);
    final appBarVisibility = ref.watch(appBarVisibilityProvider);
    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [
      appBarVisibility
          ? const CustomAppbar()
          : SliverToBoxAdapter(
              child: SizedBox(
              height: size.height * 0.05,
            )),
      if (!appBarVisibility)
        SliverToBoxAdapter(
          child: customTitle(context, title1: "Recuerda ", size1: 35, title2: "Fácil", size2: 30)
        ),
      SliverToBoxAdapter(
        child: Column(
          children: [
            const SizedBox(
              height: 2,
            ),
            if (categoriesVisibility)
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.050,
                  child: const CategorySelector()),
            const SizedBox(
              height: 2,
            ),
            if (clockVisibility) const ClockWidget(),
          ],
        ),
      ),
      SliverToBoxAdapter(
        child: Column(
          children: [
            if (isListeningProv)
              SizedBox(
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    textProv,
                    style: TextStyle(
                        fontSize: 24,
                        color:
                            isListeningProv ? colors.primary : colors.secondary,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
          ],
        ),
      ),
      SliverToBoxAdapter(
          child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colors.surfaceVariant.withOpacity(0.5)),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Recordatorios Pendientes",
                style: textStyle.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold))),
      )),
      const StreamListWidget(done: true),
      SliverToBoxAdapter(
          child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: colors.surfaceVariant.withOpacity(0.5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Recordatorios finalizados",
              style:
                  textStyle.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
        ),
      )),
      const StreamListWidget(done: false),
      const SliverToBoxAdapter(
        child: SizedBox(
          height: 500,
        ),
      ),
    ]);
  }

  @override
  bool get wantKeepAlive => true;
}
