import 'package:flutter/material.dart';
import 'package:maternity_app/core/error/failures.dart';
import 'package:maternity_app/domain/entities/medication.dart';
import 'package:maternity_app/domain/usecases/medication/add_medication.dart';
import 'package:maternity_app/domain/usecases/medication/get_medications.dart';

/// View model for medication management
class MedicationViewModel extends ChangeNotifier {
  final GetMedications getMedications;
  final AddMedication addMedication;
  
  // State
  bool _isLoading = false;
  List<Medication> _medications = [];
  String _errorMessage = '';
  
  // Getters
  bool get isLoading => _isLoading;
  List<Medication> get medications => _medications;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  
  MedicationViewModel({
    required this.getMedications,
    required this.addMedication,
  });
  
  /// Load all medications for a user
  Future<void> loadMedications({
    required String userId,
    String? pregnancyId,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    final result = await getMedications(
      GetMedicationsParams(
        userId: userId,
        pregnancyId: pregnancyId,
      ),
    );
    
    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (medications) {
        _medications = medications;
      },
    );
    
    _isLoading = false;
    notifyListeners();
  }
  
  /// Add a new medication
  Future<bool> addNewMedication(Medication medication) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    final result = await addMedication(
      AddMedicationParams(medication: medication),
    );
    
    bool success = false;
    
    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (newMedication) {
        _medications = [..._medications, newMedication];
        success = true;
      },
    );
    
    _isLoading = false;
    notifyListeners();
    
    return success;
  }
  
  /// Get active medications
  List<Medication> get activeMedications => 
      _medications.where((m) => m.isCurrent).toList();
  
  /// Clear error
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
} 