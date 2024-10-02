import '../models/training/training_report.dart';

const skillsToConsider = [
  'pace',
  'technique',
  'passing',
  'keeper',
  'defending',
  'playmaking',
  'striker',
];

Map<String, double> calculateSkillGrowth(List<TrainingReport>? reports) {
  if (reports == null || reports.isEmpty) return {'averageGrowth': 0};

  final growth = <String, double>{};

  for (var skillName in skillsToConsider) {
    final skillData = reports.where((report) {
      final kind = report.kind.name;
      final type = report.type.name;
      final intensity = report.intensity;
      return skillName == type && kind != 'missing' && intensity >= 50;
    }).toList();

    if (skillData.length >= 3) {
      final weeks = skillData.length;
      final finalSkillValue = skillData.first.getSkill(skillName);
      final initialSkillValue = skillData.last.getSkill(skillName);

      if (finalSkillValue != null && initialSkillValue != null) {
        final skillDivisor = finalSkillValue - initialSkillValue;

        if (skillDivisor > 0) {
          final skillGrowth = weeks / skillDivisor;
          growth[skillName] = double.parse(skillGrowth.toStringAsFixed(1));
        } else {
          growth[skillName] = 0;
        }
      } else {
        growth[skillName] = 0;
      }
    } else {
      growth[skillName] = 0;
    }
  }

  final growthValues = growth.values.where((val) => val > 0).toList();
  var averageGrowth = 0.0;

  if (growthValues.isNotEmpty) {
    final sumGrowth = growthValues.reduce((a, b) => a + b);
    averageGrowth = sumGrowth / growthValues.length;
  }

  growth['Avg'] = double.parse(averageGrowth.toStringAsFixed(2));

  return growth;
}
