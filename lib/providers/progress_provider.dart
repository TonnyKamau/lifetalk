import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_progress.dart';
import '../models/conversation.dart';

class ProgressProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserProgress? _userProgress;
  bool _isLoading = false;
  String? _error;

  UserProgress? get userProgress => _userProgress;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUserProgress(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('progress')
          .doc('main')
          .get();

      if (doc.exists) {
        _userProgress = UserProgress.fromJson(doc.data()!);
      } else {
        _userProgress = UserProgress.initial(userId);
        await _saveUserProgress();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveUserProgress() async {
    if (_userProgress == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_userProgress!.userId)
          .collection('progress')
          .doc('main')
          .set(_userProgress!.toJson());
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> addExperience(String skill, int experience) async {
    if (_userProgress == null) return;

    final currentExp = _userProgress!.getSkillExperience(skill);
    final currentLevel = _userProgress!.getSkillLevel(skill);
    final newExp = currentExp + experience;

    // Check if level up
    final expForNextLevel = currentLevel * 100;
    final newLevel = newExp >= expForNextLevel
        ? currentLevel + 1
        : currentLevel;

    final updatedSkillExperience = Map<String, int>.from(
      _userProgress!.skillExperience,
    );
    final updatedSkillLevels = Map<String, int>.from(
      _userProgress!.skillLevels,
    );

    updatedSkillExperience[skill] = newExp;
    updatedSkillLevels[skill] = newLevel;

    _userProgress = _userProgress!.copyWith(
      skillExperience: updatedSkillExperience,
      skillLevels: updatedSkillLevels,
      totalExperience: _userProgress!.totalExperience + experience,
    );

    await _saveUserProgress();
    notifyListeners();
  }

  Future<void> completeScenario(
    String scenarioId,
    Map<String, int> skillScores,
  ) async {
    if (_userProgress == null) return;

    final completedScenarios = List<String>.from(
      _userProgress!.completedScenarios,
    );
    if (!completedScenarios.contains(scenarioId)) {
      completedScenarios.add(scenarioId);
    }

    _userProgress = _userProgress!.copyWith(
      completedScenarios: completedScenarios,
      lastPlayedDate: DateTime.now(),
    );

    // Add experience for each skill
    for (final entry in skillScores.entries) {
      await addExperience(entry.key, entry.value);
    }

    await _saveUserProgress();
    notifyListeners();
  }

  Future<void> updateStreak() async {
    if (_userProgress == null) return;

    final now = DateTime.now();
    final lastPlayed = _userProgress!.lastPlayedDate;
    final daysDifference = now.difference(lastPlayed).inDays;

    int newStreak = _userProgress!.currentStreak;

    if (daysDifference == 1) {
      // Consecutive day
      newStreak++;
    } else if (daysDifference > 1) {
      // Streak broken
      newStreak = 1;
    } else if (daysDifference == 0) {
      // Same day, keep current streak
      newStreak = _userProgress!.currentStreak;
    }

    _userProgress = _userProgress!.copyWith(
      currentStreak: newStreak,
      lastPlayedDate: now,
    );

    await _saveUserProgress();
    notifyListeners();
  }

  Future<void> saveConversation(Conversation conversation) async {
    if (_userProgress == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(_userProgress!.userId)
          .collection('conversations')
          .doc(conversation.id)
          .set(conversation.toJson());
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<List<Conversation>> getConversationHistory() async {
    if (_userProgress == null) return [];

    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(_userProgress!.userId)
          .collection('conversations')
          .orderBy('startedAt', descending: true)
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => Conversation.fromJson(doc.data()))
          .toList();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
