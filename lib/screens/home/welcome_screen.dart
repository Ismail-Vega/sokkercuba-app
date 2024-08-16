import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/team/user.dart';
import '../../state/actions.dart';
import '../../state/app_state_notifier.dart';
import 'squad_summary_card.dart';
import 'tsummary_card.dart';
import 'user_card.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  final User? user;

  const WelcomeScreen({super.key, this.user});

  @override
  State<WelcomeScreen> createState() {
    return _WelcomeScreenState();
  }
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Color?> animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleUserUpdate();
    });
  }

  void handleUserUpdate() {
    if (widget.user != null) {
      final week = widget.user?.today.week;
      final day = widget.user?.today.day;
      final appStateNotifier =
          Provider.of<AppStateNotifier>(context, listen: false);
      final stateWeek = appStateNotifier.state.trainingWeek;

      if (week != null && day != null) {
        final trainingWeek = day < 5 ? week - 1 : week;

        if (trainingWeek != stateWeek) {
          appStateNotifier.dispatch(
              StoreAction(StoreActionTypes.setTrainingWeek, trainingWeek));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!,
      child: const SingleChildScrollView(
        child: Column(
          children: [
            UserCard(),
            SizedBox(height: 8),
            SquadSummaryCard(),
            SizedBox(height: 8),
            TSummaryCard(),
          ],
        ),
      ),
    );
  }
}
