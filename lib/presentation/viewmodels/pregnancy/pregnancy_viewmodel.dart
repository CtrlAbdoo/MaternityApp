import 'package:flutter/material.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/pregnancy.dart';
import 'package:maternity_app/domain/entities/user.dart';
import 'package:maternity_app/domain/usecases/pregnancy/get_current_pregnancy.dart';
import 'package:maternity_app/domain/usecases/pregnancy/update_pregnancy.dart';

/// Pregnancy states
enum PregnancyState {
  initial,
  loading,
  loaded,
  noPregnancy,
  error,
}

/// View model for pregnancy management
class PregnancyViewModel extends ChangeNotifier {
  final GetCurrentPregnancy getCurrentPregnancy;
  final UpdatePregnancy updatePregnancy;

  // State
  PregnancyState _state = PregnancyState.initial;
  Pregnancy? _currentPregnancy;
  String _errorMessage = '';
  bool _isLoading = false;

  // Getters
  PregnancyState get state => _state;
  Pregnancy? get currentPregnancy => _currentPregnancy;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get hasError => _errorMessage.isNotEmpty;
  bool get hasActivePregnancy => _currentPregnancy != null && _currentPregnancy!.isActive;

  // Computed pregnancy info
  int? get currentWeek => _currentPregnancy?.currentWeek;
  int? get trimester => _currentPregnancy?.trimester;
  bool get isFirstTrimester => trimester == 1;
  bool get isSecondTrimester => trimester == 2;
  bool get isThirdTrimester => trimester == 3;
  DateTime? get dueDate => _currentPregnancy?.dueDate;
  int? get daysUntilDueDate => _currentPregnancy?.daysUntilDue;
  bool? get isPastDue => _currentPregnancy?.isPastDue;

  PregnancyViewModel({
    required this.getCurrentPregnancy,
    required this.updatePregnancy,
  });

  /// Load current active pregnancy for the user
  Future<void> loadCurrentPregnancy(String userId) async {
    _isLoading = true;
    _state = PregnancyState.loading;
    _errorMessage = '';
    notifyListeners();
    
    final result = await getCurrentPregnancy(PregnancyParams(userId: userId));
    
    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _state = PregnancyState.error;
      },
      (pregnancy) {
        _currentPregnancy = pregnancy;
        _state = pregnancy != null ? PregnancyState.loaded : PregnancyState.noPregnancy;
      },
    );
    
    _isLoading = false;
    notifyListeners();
  }
  
  /// Update the current pregnancy
  Future<bool> updateCurrentPregnancy({
    required String pregnancyId,
    required String userId,
    DateTime? dueDate,
    DateTime? startDate,
    int? babyCount,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    // Create a pregnancy entity with the parameters
    final pregnancy = Pregnancy(
      id: pregnancyId,
      userId: userId,
      dueDate: dueDate ?? _currentPregnancy?.dueDate ?? DateTime.now().add(const Duration(days: 280)),
      startDate: startDate ?? _currentPregnancy?.startDate ?? DateTime.now(),
      babyCount: babyCount ?? _currentPregnancy?.babyCount ?? 1,
      isActive: true,
    );
    
    final result = await updatePregnancy(
      UpdatePregnancyParams(pregnancy: pregnancy),
    );
    
    bool success = false;
    
    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (updatedPregnancy) {
        _currentPregnancy = updatedPregnancy;
        _state = PregnancyState.loaded;
        success = true;
      },
    );
    
    _isLoading = false;
    notifyListeners();
    
    return success;
  }
  
  /// Add a note to current pregnancy
  Future<bool> addNote({
    required String note,
  }) async {
    if (_currentPregnancy == null) {
      _errorMessage = 'No active pregnancy found';
      notifyListeners();
      return false;
    }
    
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    // Create a new pregnancy with updated notes
    final currentNotes = _currentPregnancy!.notes ?? [];
    final newNote = {
      'content': note,
      'date': DateTime.now().toIso8601String(),
    };
    
    final pregnancy = Pregnancy(
      id: _currentPregnancy!.id,
      userId: _currentPregnancy!.userId,
      dueDate: _currentPregnancy!.dueDate,
      startDate: _currentPregnancy!.startDate,
      babyCount: _currentPregnancy!.babyCount,
      isActive: _currentPregnancy!.isActive,
      notes: [...currentNotes, newNote],
      createdAt: _currentPregnancy!.createdAt,
      updatedAt: DateTime.now(),
    );
    
    final result = await updatePregnancy(
      UpdatePregnancyParams(pregnancy: pregnancy),
    );
    
    bool success = false;
    
    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (updatedPregnancy) {
        _currentPregnancy = updatedPregnancy;
        success = true;
      },
    );
    
    _isLoading = false;
    notifyListeners();
    
    return success;
  }
  
  /// Clear error
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  /// Get pregnancy detail text (for display)
  String getPregnancyDetailText() {
    if (_currentPregnancy == null) {
      return 'No active pregnancy';
    }

    final week = _currentPregnancy!.currentWeek;
    return 'Week $week (Trimester ${_currentPregnancy!.trimester})';
  }

  /// Get due date formatted string
  String getDueDateText() {
    if (_currentPregnancy == null) {
      return 'N/A';
    }

    final dueDate = _currentPregnancy!.dueDate;
    return '${dueDate.day}/${dueDate.month}/${dueDate.year}';
  }

  /// Reset error state
  void resetError() {
    if (_state == PregnancyState.error) {
      _state = _currentPregnancy != null ? PregnancyState.loaded : PregnancyState.noPregnancy;
      _errorMessage = '';
      notifyListeners();
    }
  }

  /// Get formatted pregnancy duration (like "20 weeks and 3 days")
  String getFormattedDuration() {
    if (_currentPregnancy == null) return "No pregnancy data";
    
    final now = DateTime.now();
    final weeks = _currentPregnancy!.currentWeek;
    final totalDays = now.difference(_currentPregnancy!.startDate).inDays;
    final days = totalDays % 7;
    
    return '$weeks weeks and $days days';
  }
  
  /// Get days remaining until due date
  String getDaysRemainingText() {
    if (_currentPregnancy == null) return "No pregnancy data";
    
    final daysRemaining = _currentPregnancy!.daysUntilDue;
    
    if (daysRemaining < 0) {
      return 'Baby is ${daysRemaining.abs()} days overdue';
    } else if (daysRemaining == 0) {
      return 'Due today!';
    } else {
      return '$daysRemaining days until due date';
    }
  }
} 