import '../models/training/training_report.dart';

class SkillGrowthData {
  final int week;
  final String skill;
  final int growth;

  SkillGrowthData({
    required this.week,
    required this.skill,
    required this.growth,
  });
}

double estimateTalent(List<SkillGrowthData> skillGrowthData) {
  final skillData = <String, Map<String, List<int>>>{};

  for (var data in skillGrowthData) {
    if (!skillData.containsKey(data.skill)) {
      skillData[data.skill] = {'x': [], 'y': []};
    }
    skillData[data.skill]!['x']!.add(data.week);
    skillData[data.skill]!['y']!.add(data.growth);
  }

  final skillTalent = <String, double>{};
  skillData.forEach((skill, values) {
    final x = values['x']!;
    final y = values['y']!;
    final n = x.length;
    final sumX = x.reduce((a, b) => a + b);
    final sumY = y.reduce((a, b) => a + b);
    final sumXY = x
        .asMap()
        .entries
        .map((e) => e.value * y[e.key])
        .reduce((a, b) => a + b);
    final sumXSquare = x.map((e) => e * e).reduce((a, b) => a + b);

    final m = (n * sumXY - sumX * sumY) / (n * sumXSquare - sumX * sumX);
    skillTalent[skill] = m;
  });

  final totalTalent = skillTalent.values.reduce((a, b) => a + b);
  final averageTalent = totalTalent / skillTalent.length;
  return averageTalent;
}

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
  if (reports == null) return {'averageGrowth': 0};

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
      final skillDivisor = finalSkillValue! - initialSkillValue!;

      if (skillDivisor > 0) {
        final skillGrowth = weeks / skillDivisor;
        growth[skillName] = double.parse(skillGrowth.toStringAsFixed(1));
      } else {
        growth[skillName] = 0;
      }
    } else {
      growth[skillName] = 0;
    }
  }

  final growthValues = growth.values.toList();
  final sumGrowth = growthValues.reduce((a, b) => a + b);
  var averageGrowth = 0.0;

  if (sumGrowth > 0) {
    averageGrowth = sumGrowth / growthValues.where((val) => val != 0).length;
  }

  growth['Avg'] = double.parse(averageGrowth.toStringAsFixed(2));
  return growth;
}
