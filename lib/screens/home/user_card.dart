import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state_notifier.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppStateNotifier>(context).state.user;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Colors.blue[900],
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              AnimatedTextKit(animatedTexts: [
                WavyAnimatedText(user.team.name ?? '',
                    textStyle: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Spartan MB',
                    ),
                    speed: const Duration(milliseconds: 200)),
              ], isRepeatingAnimation: false),
            ]),
            Text('Owner: ${user.name}',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            Text('Country: ${user.team.country?.name ?? ''}'),
            const SizedBox(height: 8),
            Text('Language: ${user.settings.locale.toUpperCase()}'),
          ],
        ),
      ),
    );
  }
}
