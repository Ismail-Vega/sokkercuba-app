import '../models/juniors/junior_progress.dart';
import '../models/juniors/juniors_training.dart';
import '../utils/constants.dart';
import 'api_client.dart';

Future<JuniorsTraining> getJuniorsTraining(
    ApiClient apiClient, List<dynamic>? juniorsResponse) async {
  if (juniorsResponse == null || juniorsResponse.isEmpty) {
    return JuniorsTraining(juniors: {});
  }

  final responses = await Future.wait(juniorsResponse
      .map((item) => apiClient.fetchData(getJuniorGraphUrl(item['id']))));

  final juniorsTraining = JuniorsTraining(juniors: {});

  for (var junior in responses) {
    final id = junior['juniorId'];
    juniorsTraining.juniors[id] = JuniorProgress.fromJson(junior);
  }

  return juniorsTraining;
}
