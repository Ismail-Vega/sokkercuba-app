import '../models/juniors/juniors.dart';
import '../models/squad/squad.dart';
import '../models/training/training.dart';

List<Junior> parseJuniors(List<dynamic> payload) =>
    payload.map((json) => Junior.fromJson(json)).toList();

List<TeamPlayer> parsePlayers(List<dynamic> payload) =>
    payload.map((json) => TeamPlayer.fromJson(json)).toList();

List<PlayerTrainingReport> parsePlayerReports(List<dynamic> payload) =>
    payload.map((json) => PlayerTrainingReport.fromJson(json)).toList();
