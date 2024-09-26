import '../constants/constants.dart';
import '../models/juniors/junior_progress.dart';
import '../models/juniors/juniors_training.dart';
import 'api_client.dart';

Future<JuniorsTraining> getJuniorsTraining(
  ApiClient apiClient,
  List<dynamic>? juniorsResponse,
  JuniorsTraining? stateTraining,
) async {
  if (juniorsResponse == null || juniorsResponse.isEmpty) {
    return stateTraining ?? JuniorsTraining(juniors: {});
  }

  final responses = await Future.wait(
    juniorsResponse
        .map((item) => apiClient.fetchData(getJuniorGraphUrl(item['id']))),
  );

  final Map<int, JuniorProgress> updatedJuniors = {...?stateTraining?.juniors};

  for (var junior in responses) {
    final id = junior['juniorId'];
    final newProgress = JuniorProgress.fromJson(junior);

    if (updatedJuniors.containsKey(id)) {
      final existingProgress = updatedJuniors[id]!;
      final existingValues = existingProgress.values;

      final newValues = newProgress.values.where((newValue) {
        return !existingValues.any((existingValue) =>
            existingValue.x == newValue.x && existingValue.y == newValue.y);
      }).toList();

      updatedJuniors[id] = JuniorProgress(
        juniorId: id,
        values: [...existingValues, ...newValues],
      );
    } else {
      updatedJuniors[id] = newProgress;
    }
  }

  return JuniorsTraining(juniors: updatedJuniors);
}
