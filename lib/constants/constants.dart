import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  errorStyle: TextStyle(color: Colors.red),
  floatingLabelBehavior: FloatingLabelBehavior.always,
);

enum SkillsLevels {
  tragic,
  hopeless,
  unsatisfactory,
  poor,
  weak,
  average,
  adequate,
  good,
  solid,
  veryGood,
  excellent,
  formidable,
  outstanding,
  incredible,
  brilliant,
  magical,
  unearthly,
  divine,
  superdivine
}

const List<String> skillsLevelsList = [
  'Tragic',
  'Hopeless',
  'Unsatisfactory',
  'Poor',
  'Weak',
  'Average',
  'Adequate',
  'Good',
  'Solid',
  'Very Good',
  'Excellent',
  'Formidable',
  'Outstanding',
  'Incredible',
  'Brilliant',
  'Magical',
  'Unearthly',
  'Divine',
  'Superdivine'
];

const String userUrl = '/api/current';
const String juniorsUrl = '/api/junior';
const String trainingUrl = '/api/training';
const String tsummaryUrl = '/api/training/summary';

String getPlayerFullReportURL(int playerId) {
  return '/api/training/$playerId/report';
}

String getTeamPlayersURL(int teamId) {
  return '/api/player?filter[team]=$teamId&filter[limit]=200&filter[offset]=0';
}

String getTeamStatsURL(int teamId) {
  return '/api/team/$teamId/stats';
}

String getJuniorGraphUrl(int juniorId) {
  return '/api/junior/$juniorId/graph';
}

const newsUrl = '/api/news?filter[limit]=200';

String getJuniorNewsURL(int newsId) {
  return '/api/news/$newsId';
}

String getNtDeleteURL(int id) {
  return '/api/national?action=removeplayer&PID=$id';
}

String getNtAddURL(int id) {
  return '/api/national?action=addplayer&PID=$id';
}

String getNtObserveURL(int id) {
  return '/api/national?action=observe&PID=$id';
}
