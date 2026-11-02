// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TaskFlow';

  @override
  String get navProjects => 'Projects';

  @override
  String get navClasses => 'Classes';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navProfile => 'Profile';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get environment => 'Environment';

  @override
  String get notifications => 'Notifications';

  @override
  String get signOut => 'Sign out';

  @override
  String get guest => 'Guest';

  @override
  String get tryAgain => 'Try again';

  @override
  String get retryLoadingMore => 'Retry loading more';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signInSubtitle => 'Sign in to manage projects and tasks.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get signIn => 'Sign in';

  @override
  String get createAnAccount => 'Create an account';

  @override
  String get createAccount => 'Create account';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get emailRequired => 'Email is required.';

  @override
  String get emailInvalid => 'Enter a valid email address.';

  @override
  String get passwordRequired => 'Password is required.';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters.';

  @override
  String get nameRequired => 'Name is required.';

  @override
  String get nameTooShort => 'Name must be at least 2 characters.';

  @override
  String get classNameRequired => 'Class name is required.';

  @override
  String get titleRequired => 'Title is required.';

  @override
  String get projectRequired => 'Project is required.';

  @override
  String get projectsTitle => 'Projects';

  @override
  String get noProjectsYet => 'No projects yet';

  @override
  String get noProjectsMessage =>
      'Projects will appear here once they are created.';

  @override
  String get projectTitle => 'Project';

  @override
  String get addTask => 'Add task';

  @override
  String get tasksTitle => 'Tasks';

  @override
  String get noTasksInProject => 'No tasks in this project yet.';

  @override
  String projectProgress(int completed, int total) {
    return '$completed/$total done';
  }

  @override
  String updatedOn(String date) {
    return 'Updated $date';
  }

  @override
  String get newTask => 'New task';

  @override
  String get editTask => 'Edit task';

  @override
  String get searchTasks => 'Search tasks';

  @override
  String get noTasksMatch => 'No tasks match';

  @override
  String get noTasksMatchMessage => 'Try a different search or clear filters.';

  @override
  String get status => 'Status';

  @override
  String get priority => 'Priority';

  @override
  String get clear => 'Clear';

  @override
  String get allStatuses => 'All statuses';

  @override
  String get allPriorities => 'All priorities';

  @override
  String get endOfList => 'You have reached the end.';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get project => 'Project';

  @override
  String get dueDate => 'Due date';

  @override
  String get notSet => 'Not set';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get createTask => 'Create task';

  @override
  String get taskCreated => 'Task created.';

  @override
  String get taskUpdated => 'Task updated.';

  @override
  String get taskDeleted => 'Task deleted.';

  @override
  String get taskTitle => 'Task';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get markCompleted => 'Mark as completed';

  @override
  String get taskStatusTodo => 'To do';

  @override
  String get taskStatusInProgress => 'In progress';

  @override
  String get taskStatusDone => 'Done';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get profileTitle => 'Profile';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get noNotificationsMessage =>
      'Activity from your workspace will show up here.';

  @override
  String get notFoundTitle => 'Not found';

  @override
  String get pageDoesNotExist => 'This page does not exist';

  @override
  String get pageDoesNotExistMessage =>
      'The link may be broken or the item was removed.';

  @override
  String get goToProjects => 'Go to projects';

  @override
  String get classesTitle => 'Classes';

  @override
  String get integrationSettings => 'Integration settings';

  @override
  String get createNativeClass => 'Create Native class';

  @override
  String get noClassesYet => 'No classes yet';

  @override
  String get noClassesMessage =>
      'Create a Native class anytime. Google Classroom is optional.';

  @override
  String get filterAll => 'All';

  @override
  String get filterNative => 'Native';

  @override
  String get filterGoogleConnected => 'Google connected';

  @override
  String get filterSyncIssues => 'Sync issues';

  @override
  String get nativeClassHint =>
      'You can create a Native class without connecting Google Classroom.';

  @override
  String get className => 'Class name';

  @override
  String get subjectOptional => 'Subject (optional)';

  @override
  String get localDescription => 'Description (local)';

  @override
  String get nativeClassCreated => 'Native class created.';

  @override
  String get sourceNative => 'Native';

  @override
  String get sourceImported => 'Imported';

  @override
  String get googleConnected => 'Google connected';

  @override
  String get syncIssue => 'Sync issue';

  @override
  String get statusActive => 'Active';

  @override
  String get statusArchived => 'Archived';

  @override
  String externalLabel(String name, String section) {
    return 'External: $name · $section';
  }

  @override
  String get classTitle => 'Class';

  @override
  String get mapped => 'Mapped';

  @override
  String get locallyManaged => 'Locally managed';

  @override
  String get localClassFields => 'Name override / description / subject';

  @override
  String get noLocalNotes => 'No local notes';

  @override
  String get noSubject => 'No subject';

  @override
  String get externallySynchronized => 'Externally synchronized';

  @override
  String externalSectionRoom(String section, String room) {
    return 'Section $section · Room $room';
  }

  @override
  String get mapExistingCourse => 'Map existing Google course';

  @override
  String get synchronizeCourse => 'Synchronize course';

  @override
  String get unmapExternalCourse => 'Unmap external course';

  @override
  String get coursework => 'Coursework';

  @override
  String get noCourseworkYet => 'No coursework imported yet.';

  @override
  String get connectBrowseFirst =>
      'Connect Google Classroom and import or browse courses first.';

  @override
  String get confirmMapping => 'Confirm mapping';

  @override
  String confirmMappingMessage(String name) {
    return 'Map this Native class to $name? This will not merge students by name or phone.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get mappingSaved => 'Mapping saved.';

  @override
  String get googleClassroom => 'Google Classroom';

  @override
  String get googleOptionalHint =>
      'Connecting Google Classroom is optional. Native classes stay on this account if you never connect or later disconnect.';

  @override
  String get connectGoogleClassroom => 'Connect Google Classroom';

  @override
  String connectionStatus(String status) {
    return 'Connection $status';
  }

  @override
  String get defaultGradePolicy => 'Default grade-publication policy';

  @override
  String get approvalVsPublication =>
      'Approval is an internal decision. Publication is a separate Classroom API write. A grade is not visible to students just because it was approved here.';

  @override
  String get importSelectedCourses => 'Import selected courses';

  @override
  String get disconnectGoogleClassroom => 'Disconnect Google Classroom';

  @override
  String get policyDisabled =>
      'Disabled — never publish through this connection';

  @override
  String get policyManualOnly =>
      'Manual only — publish after an explicit publish action';

  @override
  String get policyAfterApproval =>
      'After teacher approval — create a publication job when a grade is approved';

  @override
  String get googleConnectedSnack => 'Google Classroom connected.';

  @override
  String get googleDisconnectedSnack =>
      'Disconnected. Native classes and history were preserved.';

  @override
  String get policyUpdatedSnack => 'Default publication policy updated.';

  @override
  String importedCoursesSnack(int count) {
    return 'Imported $count course(s). Duplicates were reused.';
  }

  @override
  String get courseworkFallback => 'Coursework';

  @override
  String get courseworkNotFound => 'Coursework not found.';

  @override
  String effectivePolicy(String policy) {
    return 'Effective policy: $policy';
  }

  @override
  String get approvalLocalOnly =>
      'Approval is local. Publication happens only after a verified Classroom API result.';

  @override
  String capabilityLabel(String state) {
    return 'Capability: $state';
  }

  @override
  String lastCheck(String date) {
    return 'Last check $date';
  }

  @override
  String eligibleCount(int count) {
    return 'Eligible $count';
  }

  @override
  String blockedCount(int count) {
    return 'Blocked $count';
  }

  @override
  String pendingCount(int count) {
    return 'Pending $count';
  }

  @override
  String publishedCount(int count) {
    return 'Published $count';
  }

  @override
  String failedCount(int count) {
    return 'Failed $count';
  }

  @override
  String conflictsCount(int count) {
    return 'Conflicts $count';
  }

  @override
  String get reviewPublicationPreview => 'Review publication preview';

  @override
  String get publishGrades => 'Publish grades';

  @override
  String get unableToLoadPreview => 'Unable to load preview.';

  @override
  String get publicationPreviewHint =>
      'Eligible items can be published. Blocked items stay local. Approved is not the same as published to students.';

  @override
  String scoreLabel(String score, String max) {
    return 'Score $score/$max';
  }

  @override
  String get eligible => 'Eligible';

  @override
  String get blocked => 'Blocked';

  @override
  String get approvedLocally => 'Approved locally';

  @override
  String get notApproved => 'Not approved';

  @override
  String get publishSelected => 'Publish selected';

  @override
  String get publishAllEligible => 'Publish all eligible';

  @override
  String get latestApiOutcomes => 'Latest API outcomes';

  @override
  String verifiedGrade(String grade) {
    return 'Verified grade $grade';
  }

  @override
  String get retry => 'Retry';

  @override
  String retryStatus(String status) {
    return 'Retry status: $status';
  }

  @override
  String get publicationFinished =>
      'Publication finished. Status comes from the Classroom API result, not this screen.';

  @override
  String get inheritPolicy => 'Inherit connection default';

  @override
  String get disablePublication => 'Disable grade publication';

  @override
  String get manualPublication => 'Manual publication';

  @override
  String get publishAfterApproval => 'Publish after teacher approval';

  @override
  String policyLabel(String policy, String capability) {
    return 'Policy $policy · $capability';
  }

  @override
  String noLocalNotesLine(String name, String notes, String subject) {
    return '$name\n$notes\n$subject';
  }
}
