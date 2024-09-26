import '../models/player/player.dart';
import '../models/player/player_info.dart';
import 'api_client.dart';

Future<List<TeamPlayer>> fetchTransfersByCountry(
    ApiClient apiClient, String country, List<TeamPlayer> statePlayers) async {
  List<TeamPlayer> allTransfers = [];
  int offset = 0;
  int limit = 200;
  bool hasMoreData = true;

  Set<int> statePlayerIds = statePlayers.map((player) => player.id).toSet();

  while (hasMoreData) {
    final endpoint =
        '/transfer?filter[offset]=$offset&filter[limit]=$limit&filter[includeEnded]=true';

    final response = await apiClient.fetchData(endpoint);
    if (response != null &&
        response['transfers'] != null &&
        response['transfers'].length > 0) {
      List<dynamic> transfers = response['transfers'];

      for (var transfer in transfers) {
        int playerId = transfer['player']['id'];

        if (statePlayerIds.contains(playerId)) {
          continue;
        }

        if (transfer['player']['info']['country']['name'] == country) {
          TeamPlayer player = TeamPlayer(
            id: playerId,
            info: PlayerInfo.fromJson(transfer['player']['info']),
            transfer: null,
            skillsHistory: {},
            isObserved: false,
          );
          allTransfers.add(player);
        }
      }

      if (transfers.length < limit) {
        hasMoreData = false;
      } else {
        offset += limit;
      }
    } else {
      hasMoreData = false;
    }
  }

  return allTransfers;
}
