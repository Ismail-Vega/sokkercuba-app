import 'package:intl/intl.dart';

import '../constants/constants.dart';
import '../models/player/player.dart';

String? formatNumber(int? number) {
  if (number == null) return null;
  final formatter = NumberFormat('#,##0', 'en_US');
  return formatter.format(number).replaceAll(',', ' ');
}

String formatDateTime(String? date,
    {String locale = 'en_US', bool isShort = false}) {
  if (date == null) {
    return 'No date available';
  }

  final dateTime = DateTime.parse(date);
  final DateFormat dateFormatter = DateFormat('MMM d, y', locale);
  final DateFormat timeFormatter = DateFormat('HH:mm:ss', locale);

  final String formattedDate = dateFormatter.format(dateTime);
  final String formattedTime = timeFormatter.format(dateTime);

  if (isShort) return formattedDate;

  return '$formattedDate at $formattedTime';
}

String formatPlayerInfo(TeamPlayer player) {
  return """
[b][pid=${player.id}]${player.info.name.name} ${player.info.name.surname}[/pid][/b], age: [b]${player.info.characteristics.age}[/b], height: [b]${player.info.characteristics.height}[/b] cm
value: [b]${player.info.value?.value ?? 0} ${player.info.value?.currency ?? ''}[/b], wage: [b]${player.info.wage?.value ?? 0} ${player.info.wage?.currency ?? ''}[/b]
club: [tid=${player.info.team.id}]${player.info.team.name}[/tid], country: ${player.info.country.name}
${player.info.skills.form} form, ${player.info.skills.tacticalDiscipline} tactical discipline

[b]${skillsLevelsList[player.info.skills.stamina]}[/b] stamina, [b]${skillsLevelsList[player.info.skills.keeper]}[/b] keeper
[b]${skillsLevelsList[player.info.skills.pace]}[/b] pace, [b]${skillsLevelsList[player.info.skills.defending]}[/b] defender
[b]${skillsLevelsList[player.info.skills.technique]}[/b] technique, [b]${skillsLevelsList[player.info.skills.playmaking]}[/b] playmaker
[b]${skillsLevelsList[player.info.skills.passing]}[/b] passing, [b]${skillsLevelsList[player.info.skills.striker]}[/b] striker
  """;
}
