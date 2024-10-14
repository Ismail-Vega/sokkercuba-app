import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/player/player.dart';
import '../services/toast_service.dart';
import 'actions.dart';
import 'app_state.dart';

class AppStateNotifier extends ChangeNotifier {
  AppState _state;

  AppStateNotifier(this._state) {
    _loadState();
  }

  AppState get state => _state;

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final stateString = prefs.getString('appState');
    if (stateString != null) {
      _state = AppState.fromJson(jsonDecode(stateString));
      notifyListeners();
    }
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('appState', jsonEncode(_state.toJson()));
  }

  Future<void> exportAppStateWithFilePicker(BuildContext context) async {
    final stateJson = jsonEncode(_state.toJson());
    final toastService = ToastService(context);

    try {
      String? downloadsDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select Export Directory',
        initialDirectory: '/storage/emulated/0/Download',
        lockParentWindow: true,
      );

      if (downloadsDirectory != null) {
        final filePath = '$downloadsDirectory/sokker_data.json';
        final file = File(filePath);

        if (await file.exists()) {
          await file.delete();
        }

        await file.writeAsString(stateJson);

        toastService.showToastWithCloseButton(
          "Data successfully exported to: $filePath",
          backgroundColor: Colors.green,
        );
        return;
      } else {
        toastService.showToast(
          "Export canceled or no directory selected.",
          backgroundColor: Colors.orange,
        );
        return;
      }
    } catch (e) {
      toastService.showToast(
        "Failed to export to the selected directory. Saving in internal storage instead.",
        backgroundColor: Colors.orange,
      );
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/sokker_data.json';
      final file = File(filePath);
      await file.writeAsString(stateJson);

      toastService.showToastWithCloseButton(
        "Data saved in: $filePath",
        backgroundColor: Colors.orange,
      );
    } catch (e) {
      toastService.showToastWithCloseButton(
        "Error saving data: $e",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> importAppStateWithFilePicker(BuildContext context) async {
    final toastService = ToastService(context);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      final stateJson = await file.readAsString();

      try {
        final jsonData = jsonDecode(stateJson);

        final appState = AppState.fromJson(jsonData);
        _state = appState;
        await _saveState();
        notifyListeners();

        toastService.showToast(
          "Your sokker data was imported successfully!",
          backgroundColor: Colors.green,
        );
      } catch (e) {
        toastService.showToastWithCloseButton(
          'There was an error while trying to parse the file: $e',
          backgroundColor: Colors.red,
        );
      }
    } else {
      toastService.showToast(
        "Import canceled or no directory selected!",
        backgroundColor: Colors.red,
      );
    }
  }

  void dispatch(StoreAction action) {
    switch (action.type) {
      case StoreActionTypes.setError:
        _state = _state.copyWith(error: action.payload);
        break;
      case StoreActionTypes.setErrorMsg:
        _state = _state.copyWith(errorMsg: action.payload);
        break;
      case StoreActionTypes.setUsername:
        _state = _state.copyWith(username: action.payload);
        break;
      case StoreActionTypes.setTeamId:
        _state = _state.copyWith(teamId: action.payload);
        break;
      case StoreActionTypes.setTrainingWeek:
        _state = _state.copyWith(trainingWeek: action.payload);
        break;
      case StoreActionTypes.setLoading:
        _state = _state.copyWith(loading: action.payload);
        break;
      case StoreActionTypes.setTransfersLoading:
        _state = _state.copyWith(transfersLoading: action.payload);
        break;
      case StoreActionTypes.setLogin:
        _state = _state.copyWith(loggedIn: action.payload);
        break;
      case StoreActionTypes.setUser:
        _state = _state.copyWith(user: action.payload);
        break;
      case StoreActionTypes.setUserStats:
        _state = _state.copyWith(userStats: action.payload);
        break;
      case StoreActionTypes.setJuniors:
        _state = _state.copyWith(juniors: action.payload);
        break;
      case StoreActionTypes.setJuniorsTraining:
        _state = _state.copyWith(juniorsTraining: action.payload);
        break;
      case StoreActionTypes.setSummary:
        _state = _state.copyWith(tsummary: action.payload);
        break;
      case StoreActionTypes.setTeam:
        _state = _state.copyWith(players: action.payload);
        break;
      case StoreActionTypes.setTraining:
        _state = _state.copyWith(training: action.payload);
        break;
      case StoreActionTypes.updateObservedPlayers:
        final List<TeamPlayer> fetchedPlayers =
            action.payload as List<TeamPlayer>;
        final List<TeamPlayer> updatedObservedPlayers =
            List.from(_state.observedPlayers);

        for (var newPlayer in fetchedPlayers) {
          if (!updatedObservedPlayers
              .any((player) => player.id == newPlayer.id)) {
            updatedObservedPlayers.add(newPlayer);
          }
        }

        _state = _state.copyWith(observedPlayers: updatedObservedPlayers);
        break;
      case StoreActionTypes.delObservedPlayer:
        final int playerId = action.payload;
        final List<TeamPlayer> updatedObservedPlayers =
            List.from(_state.observedPlayers);
        updatedObservedPlayers.removeWhere((player) => player.id == playerId);
        _state = _state.copyWith(observedPlayers: updatedObservedPlayers);
        break;
      case StoreActionTypes.setAll:
        _state = _state.copyWithAll(action.payload);
        break;
    }
    _saveState();
    if (action.notify) notifyListeners();
  }
}
