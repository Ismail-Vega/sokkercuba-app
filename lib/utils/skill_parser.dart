import 'constants.dart';

String parseSkillToText(int index) {
  if (index < 0 || index >= skillsLevelsList.length) {
    'Unknown [$index]';
  }
  return '${skillsLevelsList[index]} [$index]';
}
