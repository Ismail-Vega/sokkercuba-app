import '../models/player/skills.dart';
import '../models/player/skills_change.dart';

mixin SkillMethods {
  Skills get skills;
  SkillsChange? get skillsChange;

  int? getSkill(String skill) {
    switch (skill) {
      case 'stamina':
        return skills.stamina;
      case 'keeper':
        return skills.keeper;
      case 'playmaking':
        return skills.playmaking;
      case 'passing':
        return skills.passing;
      case 'technique':
        return skills.technique;
      case 'defending':
        return skills.defending;
      case 'striker':
        return skills.striker;
      case 'pace':
        return skills.pace;
      default:
        return null;
    }
  }

  int? getSkillChange(String skill) {
    if (skillsChange == null) {
      return null;
    }

    switch (skill) {
      case 'Form':
        return skillsChange!.form;
      case 'Tact disc':
        return skillsChange!.tacticalDiscipline;
      case 'teamwork':
        return skillsChange!.teamwork;
      case 'experience':
        return skillsChange!.experience;
      case 'stamina':
        return skillsChange!.stamina;
      case 'keeper':
        return skillsChange!.keeper;
      case 'playmaker':
        return skillsChange!.playmaking;
      case 'passing':
        return skillsChange!.passing;
      case 'technique':
        return skillsChange!.technique;
      case 'defender':
        return skillsChange!.defending;
      case 'striker':
        return skillsChange!.striker;
      case 'pace':
        return skillsChange!.pace;
      default:
        return null;
    }
  }
}
