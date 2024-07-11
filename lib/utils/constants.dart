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

const String userUrl = '/current';
const String juniorsUrl = '/junior';
const String cweekUrl = '/training';
const String tsummaryUrl = '/training/summary';

String getPlayerFullReportURL(String playerId) {
  return '/training/$playerId/report';
}

String getTeamPlayersURL(int teamId) {
  return '/player?filter[team]=$teamId&filter[limit]=200&filter[offset]=0';
}

String getTeamStatsURL(int teamId) {
  return '/team/$teamId/stats';
}
