import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _handleWeekChange();
  }

  void _handleWeekChange() {
    final week = _state.user?.today.week;
    final day = _state.user?.today.day;
    if (week != null && day != null) {
      final trainingWeek = day < 5 ? week - 1 : week;
      _state.players?.players.forEach((player) {
        player.skillsHistory?[trainingWeek] = player.info;
      });
    }
  }

  Future<void> exportAppStateWithFilePicker() async {
    final stateJson = jsonEncode(_state.toJson());

    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      final file = File('$selectedDirectory/sokker_data.json');
      await file.writeAsString(stateJson);

      Fluttertoast.showToast(
          msg: "Your sokker data was exported to: ${file.path}!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "There was an error while trying to export your sokker data!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> importAppStateWithFilePicker() async {
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

        Fluttertoast.showToast(
            msg: "Your sokker data was imported successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } catch (e) {
        Fluttertoast.showToast(
            msg: 'There was an error while trying to parse the file: $e',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      Fluttertoast.showToast(
          msg: "There was an error while trying to read the file!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
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
      case StoreActionTypes.setAll:
        _state = _state.copyWithAll(action.payload);
        break;
    }
    if (action.notify) notifyListeners();
    _saveState();
    notifyListeners();
  }
}
