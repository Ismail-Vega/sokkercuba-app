import '../constants/constants.dart';

String parseSkillToText(int index) {
  if (index < 0 || index >= skillsLevelsList.length) {
    'Unknown';
  }
  return skillsLevelsList[index];
}
