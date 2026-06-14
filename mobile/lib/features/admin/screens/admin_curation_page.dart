import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../core/state.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../inventory/widgets/admin_curation_card.dart';
import '../../../l10n/app_localizations.dart';

class AdminCurationPage extends StatefulWidget {
  const AdminCurationPage({super.key});

  @override
  State<AdminCurationPage> createState() => _AdminCurationPageState();
}

class _AdminCurationPageState extends State<AdminCurationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RuangBukuState.instance.fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;

        if (state.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final pendingBooks = state.books
            .where((b) =>
                b.isPublic &&
                b.statusVerifikasi == BookStatus.publicPending)
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(
              l10n?.adminCuration ?? 'Admin Curation',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () => state.fetchBooks(),
            child: pendingBooks.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 120),
                    EmptyStateView(
                      icon: Icons.check_circle_outline,
                      title: l10n?.allCaughtUp ?? 'All Caught Up!',
                      message: l10n?.noBooksAwaitingCuration ?? 'There are no books awaiting curation approval right now.',
                    ),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.all(RuangBukuSpacing.marginMobile),
                  itemCount: pendingBooks.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: RuangBukuSpacing.lg),
                  itemBuilder: (context, index) =>
                      AdminCurationCard(book: pendingBooks[index]),
                ),
          ),
        );
      },
    );
  }
}
