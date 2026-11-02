enum ClassSourceType {
  native,
  externalImport;

  String get apiValue => switch (this) {
    ClassSourceType.native => 'NATIVE',
    ClassSourceType.externalImport => 'EXTERNAL_IMPORT',
  };

  static ClassSourceType fromApi(String? value) {
    return switch (value) {
      'EXTERNAL_IMPORT' => ClassSourceType.externalImport,
      _ => ClassSourceType.native,
    };
  }
}

enum ClassStatus {
  active,
  archived;

  String get apiValue => switch (this) {
    ClassStatus.active => 'ACTIVE',
    ClassStatus.archived => 'ARCHIVED',
  };

  static ClassStatus fromApi(String? value) {
    return switch (value) {
      'ARCHIVED' => ClassStatus.archived,
      _ => ClassStatus.active,
    };
  }
}

enum MappingStatus {
  active,
  unmapped,
  conflict,
  syncError;

  String get apiValue => switch (this) {
    MappingStatus.active => 'ACTIVE',
    MappingStatus.unmapped => 'UNMAPPED',
    MappingStatus.conflict => 'CONFLICT',
    MappingStatus.syncError => 'SYNC_ERROR',
  };

  static MappingStatus fromApi(String? value) {
    return switch (value) {
      'UNMAPPED' => MappingStatus.unmapped,
      'CONFLICT' => MappingStatus.conflict,
      'SYNC_ERROR' => MappingStatus.syncError,
      _ => MappingStatus.active,
    };
  }
}

enum ConnectionStatus {
  connected,
  requiresReauthorization,
  disconnected;

  String get apiValue => switch (this) {
    ConnectionStatus.connected => 'CONNECTED',
    ConnectionStatus.requiresReauthorization => 'REQUIRES_REAUTHORIZATION',
    ConnectionStatus.disconnected => 'DISCONNECTED',
  };

  static ConnectionStatus fromApi(String? value) {
    return switch (value) {
      'REQUIRES_REAUTHORIZATION' => ConnectionStatus.requiresReauthorization,
      'DISCONNECTED' => ConnectionStatus.disconnected,
      _ => ConnectionStatus.connected,
    };
  }
}

enum ConnectionGradeSyncPolicy {
  disabled,
  manualOnly,
  afterTeacherApproval;

  String get apiValue => switch (this) {
    ConnectionGradeSyncPolicy.disabled => 'DISABLED',
    ConnectionGradeSyncPolicy.manualOnly => 'MANUAL_ONLY',
    ConnectionGradeSyncPolicy.afterTeacherApproval => 'AFTER_TEACHER_APPROVAL',
  };

  static ConnectionGradeSyncPolicy fromApi(String? value) {
    return switch (value) {
      'MANUAL_ONLY' => ConnectionGradeSyncPolicy.manualOnly,
      'AFTER_TEACHER_APPROVAL' => ConnectionGradeSyncPolicy.afterTeacherApproval,
      _ => ConnectionGradeSyncPolicy.disabled,
    };
  }
}

enum CourseworkGradeSyncPolicy {
  inheritConnectionDefault,
  disabled,
  manualOnly,
  afterTeacherApproval;

  String get apiValue => switch (this) {
    CourseworkGradeSyncPolicy.inheritConnectionDefault =>
      'INHERIT_CONNECTION_DEFAULT',
    CourseworkGradeSyncPolicy.disabled => 'DISABLED',
    CourseworkGradeSyncPolicy.manualOnly => 'MANUAL_ONLY',
    CourseworkGradeSyncPolicy.afterTeacherApproval => 'AFTER_TEACHER_APPROVAL',
  };

  static CourseworkGradeSyncPolicy fromApi(String? value) {
    return switch (value) {
      'DISABLED' => CourseworkGradeSyncPolicy.disabled,
      'MANUAL_ONLY' => CourseworkGradeSyncPolicy.manualOnly,
      'AFTER_TEACHER_APPROVAL' =>
        CourseworkGradeSyncPolicy.afterTeacherApproval,
      _ => CourseworkGradeSyncPolicy.inheritConnectionDefault,
    };
  }
}

enum EffectiveGradeSyncPolicy {
  disabled,
  manualOnly,
  afterTeacherApproval;

  String get apiValue => switch (this) {
    EffectiveGradeSyncPolicy.disabled => 'DISABLED',
    EffectiveGradeSyncPolicy.manualOnly => 'MANUAL_ONLY',
    EffectiveGradeSyncPolicy.afterTeacherApproval => 'AFTER_TEACHER_APPROVAL',
  };

  static EffectiveGradeSyncPolicy fromApi(String? value) {
    return switch (value) {
      'MANUAL_ONLY' => EffectiveGradeSyncPolicy.manualOnly,
      'AFTER_TEACHER_APPROVAL' => EffectiveGradeSyncPolicy.afterTeacherApproval,
      _ => EffectiveGradeSyncPolicy.disabled,
    };
  }
}

enum CapabilityState {
  unknown,
  supported,
  unsupported,
  permissionDenied,
  requiresReauthorization,
  temporarilyUnavailable;

  String get apiValue => switch (this) {
    CapabilityState.unknown => 'UNKNOWN',
    CapabilityState.supported => 'SUPPORTED',
    CapabilityState.unsupported => 'UNSUPPORTED',
    CapabilityState.permissionDenied => 'PERMISSION_DENIED',
    CapabilityState.requiresReauthorization => 'REQUIRES_REAUTHORIZATION',
    CapabilityState.temporarilyUnavailable => 'TEMPORARILY_UNAVAILABLE',
  };

  static CapabilityState fromApi(String? value) {
    return switch (value) {
      'SUPPORTED' => CapabilityState.supported,
      'UNSUPPORTED' => CapabilityState.unsupported,
      'PERMISSION_DENIED' => CapabilityState.permissionDenied,
      'REQUIRES_REAUTHORIZATION' => CapabilityState.requiresReauthorization,
      'TEMPORARILY_UNAVAILABLE' => CapabilityState.temporarilyUnavailable,
      _ => CapabilityState.unknown,
    };
  }
}

enum PublicationMode {
  manual,
  afterTeacherApproval;

  String get apiValue => switch (this) {
    PublicationMode.manual => 'MANUAL',
    PublicationMode.afterTeacherApproval => 'AFTER_TEACHER_APPROVAL',
  };

  static PublicationMode fromApi(String? value) {
    return switch (value) {
      'AFTER_TEACHER_APPROVAL' => PublicationMode.afterTeacherApproval,
      _ => PublicationMode.manual,
    };
  }
}

enum PublicationAttemptStatus {
  pending,
  inProgress,
  succeeded,
  failed,
  conflict,
  cancelled;

  String get apiValue => switch (this) {
    PublicationAttemptStatus.pending => 'PENDING',
    PublicationAttemptStatus.inProgress => 'IN_PROGRESS',
    PublicationAttemptStatus.succeeded => 'SUCCEEDED',
    PublicationAttemptStatus.failed => 'FAILED',
    PublicationAttemptStatus.conflict => 'CONFLICT',
    PublicationAttemptStatus.cancelled => 'CANCELLED',
  };

  static PublicationAttemptStatus fromApi(String? value) {
    return switch (value) {
      'IN_PROGRESS' => PublicationAttemptStatus.inProgress,
      'SUCCEEDED' => PublicationAttemptStatus.succeeded,
      'FAILED' => PublicationAttemptStatus.failed,
      'CONFLICT' => PublicationAttemptStatus.conflict,
      'CANCELLED' => PublicationAttemptStatus.cancelled,
      _ => PublicationAttemptStatus.pending,
    };
  }
}

enum RosterLinkStatus {
  linkedByGoogleId,
  linkedByEmail,
  unmatched;

  String get apiValue => switch (this) {
    RosterLinkStatus.linkedByGoogleId => 'LINKED_GOOGLE_ID',
    RosterLinkStatus.linkedByEmail => 'LINKED_EMAIL',
    RosterLinkStatus.unmatched => 'UNMATCHED',
  };
}
