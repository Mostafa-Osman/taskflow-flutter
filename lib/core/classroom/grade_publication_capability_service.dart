import 'classroom_client.dart';
import 'enums.dart';

class CapabilityCheck {
  const CapabilityCheck({
    required this.state,
    required this.checkedAt,
    this.lastSuccessfulCheckAt,
    this.lastErrorCode,
    this.lastErrorMessage,
    this.capabilityVersion = 'v1',
  });

  final CapabilityState state;
  final String checkedAt;
  final String? lastSuccessfulCheckAt;
  final String? lastErrorCode;
  final String? lastErrorMessage;
  final String capabilityVersion;

  Map<String, dynamic> toJson() => {
    'capabilityState': state.apiValue,
    'checkedAt': checkedAt,
    'lastSuccessfulCheckAt': lastSuccessfulCheckAt,
    'lastErrorCode': lastErrorCode,
    'lastErrorMessage': lastErrorMessage,
    'capabilityVersion': capabilityVersion,
  };
}

class GradePublicationCapabilityService {
  const GradePublicationCapabilityService(this._client);

  final ClassroomClient _client;

  Future<CapabilityCheck> check({
    required String connectionId,
    required String courseworkId,
    required String now,
    String? lastSuccessfulCheckAt,
  }) async {
    try {
      final state = await _client.checkGradePublicationCapability(
        connectionId: connectionId,
        courseworkId: courseworkId,
      );
      return CapabilityCheck(
        state: state,
        checkedAt: now,
        lastSuccessfulCheckAt: state == CapabilityState.supported
            ? now
            : lastSuccessfulCheckAt,
        lastErrorCode: state == CapabilityState.supported ? null : state.apiValue,
        lastErrorMessage: _messageFor(state),
      );
    } on ClassroomClientException catch (error) {
      return CapabilityCheck(
        state: error.capability,
        checkedAt: now,
        lastSuccessfulCheckAt: lastSuccessfulCheckAt,
        lastErrorCode: error.code,
        lastErrorMessage: error.message,
      );
    }
  }

  String? unavailableReason({
    required CapabilityState capability,
    required EffectiveGradeSyncPolicy policy,
    required bool hasPublishPermission,
    required ConnectionStatus connectionStatus,
    required bool hasSubmission,
    required bool hasConflict,
  }) {
    if (connectionStatus == ConnectionStatus.requiresReauthorization) {
      return 'The Google Classroom connection has expired and must be reauthorized.';
    }
    if (connectionStatus == ConnectionStatus.disconnected) {
      return 'Google Classroom is disconnected.';
    }
    if (!hasPublishPermission) {
      return 'You do not have permission to publish grades.';
    }
    if (policy == EffectiveGradeSyncPolicy.disabled) {
      return 'Grade publication is disabled by policy.';
    }
    if (capability == CapabilityState.unsupported) {
      return 'This coursework does not support grade publication.';
    }
    if (capability == CapabilityState.permissionDenied) {
      return 'Classroom denied grade publication permission.';
    }
    if (capability == CapabilityState.requiresReauthorization) {
      return 'The Google Classroom connection has expired and must be reauthorized.';
    }
    if (capability == CapabilityState.temporarilyUnavailable) {
      return 'Google Classroom is temporarily unavailable. This is not a permanent limitation.';
    }
    if (!hasSubmission) {
      return 'The external submission is invalid or unavailable.';
    }
    if (hasConflict) {
      return 'An external grade already exists and conflicts with the local result.';
    }
    if (capability != CapabilityState.supported) {
      return 'Grade publication capability has not been verified.';
    }
    return null;
  }

  String? _messageFor(CapabilityState state) {
    return switch (state) {
      CapabilityState.supported => null,
      CapabilityState.unsupported =>
        'Coursework was not created by this developer project.',
      CapabilityState.permissionDenied =>
        'Classroom denied grade publication permission.',
      CapabilityState.requiresReauthorization =>
        'The Google Classroom connection must be reauthorized.',
      CapabilityState.temporarilyUnavailable =>
        'Google Classroom is temporarily unavailable.',
      CapabilityState.unknown => 'Capability has not been verified.',
    };
  }
}
