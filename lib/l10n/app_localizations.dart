import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TaskFlow'**
  String get appTitle;

  /// No description provided for @navProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// No description provided for @navClasses.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get navClasses;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get navTasks;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @environment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get environment;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @retryLoadingMore.
  ///
  /// In en, this message translates to:
  /// **'Retry loading more'**
  String get retryLoadingMore;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage projects and tasks.'**
  String get signInSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAnAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccount;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required.'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required.'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get passwordTooShort;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required.'**
  String get nameRequired;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters.'**
  String get nameTooShort;

  /// No description provided for @classNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Class name is required.'**
  String get classNameRequired;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required.'**
  String get titleRequired;

  /// No description provided for @projectRequired.
  ///
  /// In en, this message translates to:
  /// **'Project is required.'**
  String get projectRequired;

  /// No description provided for @projectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projectsTitle;

  /// No description provided for @noProjectsYet.
  ///
  /// In en, this message translates to:
  /// **'No projects yet'**
  String get noProjectsYet;

  /// No description provided for @noProjectsMessage.
  ///
  /// In en, this message translates to:
  /// **'Projects will appear here once they are created.'**
  String get noProjectsMessage;

  /// No description provided for @projectTitle.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get projectTitle;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get addTask;

  /// No description provided for @tasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksTitle;

  /// No description provided for @noTasksInProject.
  ///
  /// In en, this message translates to:
  /// **'No tasks in this project yet.'**
  String get noTasksInProject;

  /// No description provided for @projectProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} done'**
  String projectProgress(int completed, int total);

  /// No description provided for @updatedOn.
  ///
  /// In en, this message translates to:
  /// **'Updated {date}'**
  String updatedOn(String date);

  /// No description provided for @newTask.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get newTask;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get editTask;

  /// No description provided for @searchTasks.
  ///
  /// In en, this message translates to:
  /// **'Search tasks'**
  String get searchTasks;

  /// No description provided for @noTasksMatch.
  ///
  /// In en, this message translates to:
  /// **'No tasks match'**
  String get noTasksMatch;

  /// No description provided for @noTasksMatchMessage.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or clear filters.'**
  String get noTasksMatchMessage;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All statuses'**
  String get allStatuses;

  /// No description provided for @allPriorities.
  ///
  /// In en, this message translates to:
  /// **'All priorities'**
  String get allPriorities;

  /// No description provided for @endOfList.
  ///
  /// In en, this message translates to:
  /// **'You have reached the end.'**
  String get endOfList;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get dueDate;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @createTask.
  ///
  /// In en, this message translates to:
  /// **'Create task'**
  String get createTask;

  /// No description provided for @taskCreated.
  ///
  /// In en, this message translates to:
  /// **'Task created.'**
  String get taskCreated;

  /// No description provided for @taskUpdated.
  ///
  /// In en, this message translates to:
  /// **'Task updated.'**
  String get taskUpdated;

  /// No description provided for @taskDeleted.
  ///
  /// In en, this message translates to:
  /// **'Task deleted.'**
  String get taskDeleted;

  /// No description provided for @taskTitle.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get taskTitle;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @markCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as completed'**
  String get markCompleted;

  /// No description provided for @taskStatusTodo.
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get taskStatusTodo;

  /// No description provided for @taskStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get taskStatusInProgress;

  /// No description provided for @taskStatusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get taskStatusDone;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @noNotificationsMessage.
  ///
  /// In en, this message translates to:
  /// **'Activity from your workspace will show up here.'**
  String get noNotificationsMessage;

  /// No description provided for @notFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFoundTitle;

  /// No description provided for @pageDoesNotExist.
  ///
  /// In en, this message translates to:
  /// **'This page does not exist'**
  String get pageDoesNotExist;

  /// No description provided for @pageDoesNotExistMessage.
  ///
  /// In en, this message translates to:
  /// **'The link may be broken or the item was removed.'**
  String get pageDoesNotExistMessage;

  /// No description provided for @goToProjects.
  ///
  /// In en, this message translates to:
  /// **'Go to projects'**
  String get goToProjects;

  /// No description provided for @classesTitle.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get classesTitle;

  /// No description provided for @integrationSettings.
  ///
  /// In en, this message translates to:
  /// **'Integration settings'**
  String get integrationSettings;

  /// No description provided for @createNativeClass.
  ///
  /// In en, this message translates to:
  /// **'Create Native class'**
  String get createNativeClass;

  /// No description provided for @noClassesYet.
  ///
  /// In en, this message translates to:
  /// **'No classes yet'**
  String get noClassesYet;

  /// No description provided for @noClassesMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a Native class anytime. Google Classroom is optional.'**
  String get noClassesMessage;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterNative.
  ///
  /// In en, this message translates to:
  /// **'Native'**
  String get filterNative;

  /// No description provided for @filterGoogleConnected.
  ///
  /// In en, this message translates to:
  /// **'Google connected'**
  String get filterGoogleConnected;

  /// No description provided for @filterSyncIssues.
  ///
  /// In en, this message translates to:
  /// **'Sync issues'**
  String get filterSyncIssues;

  /// No description provided for @nativeClassHint.
  ///
  /// In en, this message translates to:
  /// **'You can create a Native class without connecting Google Classroom.'**
  String get nativeClassHint;

  /// No description provided for @className.
  ///
  /// In en, this message translates to:
  /// **'Class name'**
  String get className;

  /// No description provided for @subjectOptional.
  ///
  /// In en, this message translates to:
  /// **'Subject (optional)'**
  String get subjectOptional;

  /// No description provided for @localDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (local)'**
  String get localDescription;

  /// No description provided for @nativeClassCreated.
  ///
  /// In en, this message translates to:
  /// **'Native class created.'**
  String get nativeClassCreated;

  /// No description provided for @sourceNative.
  ///
  /// In en, this message translates to:
  /// **'Native'**
  String get sourceNative;

  /// No description provided for @sourceImported.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get sourceImported;

  /// No description provided for @googleConnected.
  ///
  /// In en, this message translates to:
  /// **'Google connected'**
  String get googleConnected;

  /// No description provided for @syncIssue.
  ///
  /// In en, this message translates to:
  /// **'Sync issue'**
  String get syncIssue;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get statusArchived;

  /// No description provided for @externalLabel.
  ///
  /// In en, this message translates to:
  /// **'External: {name} · {section}'**
  String externalLabel(String name, String section);

  /// No description provided for @classTitle.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get classTitle;

  /// No description provided for @mapped.
  ///
  /// In en, this message translates to:
  /// **'Mapped'**
  String get mapped;

  /// No description provided for @locallyManaged.
  ///
  /// In en, this message translates to:
  /// **'Locally managed'**
  String get locallyManaged;

  /// No description provided for @localClassFields.
  ///
  /// In en, this message translates to:
  /// **'Name override / description / subject'**
  String get localClassFields;

  /// No description provided for @noLocalNotes.
  ///
  /// In en, this message translates to:
  /// **'No local notes'**
  String get noLocalNotes;

  /// No description provided for @noSubject.
  ///
  /// In en, this message translates to:
  /// **'No subject'**
  String get noSubject;

  /// No description provided for @externallySynchronized.
  ///
  /// In en, this message translates to:
  /// **'Externally synchronized'**
  String get externallySynchronized;

  /// No description provided for @externalSectionRoom.
  ///
  /// In en, this message translates to:
  /// **'Section {section} · Room {room}'**
  String externalSectionRoom(String section, String room);

  /// No description provided for @mapExistingCourse.
  ///
  /// In en, this message translates to:
  /// **'Map existing Google course'**
  String get mapExistingCourse;

  /// No description provided for @synchronizeCourse.
  ///
  /// In en, this message translates to:
  /// **'Synchronize course'**
  String get synchronizeCourse;

  /// No description provided for @unmapExternalCourse.
  ///
  /// In en, this message translates to:
  /// **'Unmap external course'**
  String get unmapExternalCourse;

  /// No description provided for @coursework.
  ///
  /// In en, this message translates to:
  /// **'Coursework'**
  String get coursework;

  /// No description provided for @noCourseworkYet.
  ///
  /// In en, this message translates to:
  /// **'No coursework imported yet.'**
  String get noCourseworkYet;

  /// No description provided for @connectBrowseFirst.
  ///
  /// In en, this message translates to:
  /// **'Connect Google Classroom and import or browse courses first.'**
  String get connectBrowseFirst;

  /// No description provided for @confirmMapping.
  ///
  /// In en, this message translates to:
  /// **'Confirm mapping'**
  String get confirmMapping;

  /// No description provided for @confirmMappingMessage.
  ///
  /// In en, this message translates to:
  /// **'Map this Native class to {name}? This will not merge students by name or phone.'**
  String confirmMappingMessage(String name);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @mappingSaved.
  ///
  /// In en, this message translates to:
  /// **'Mapping saved.'**
  String get mappingSaved;

  /// No description provided for @googleClassroom.
  ///
  /// In en, this message translates to:
  /// **'Google Classroom'**
  String get googleClassroom;

  /// No description provided for @googleOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Connecting Google Classroom is optional. Native classes stay on this account if you never connect or later disconnect.'**
  String get googleOptionalHint;

  /// No description provided for @connectGoogleClassroom.
  ///
  /// In en, this message translates to:
  /// **'Connect Google Classroom'**
  String get connectGoogleClassroom;

  /// No description provided for @connectionStatus.
  ///
  /// In en, this message translates to:
  /// **'Connection {status}'**
  String connectionStatus(String status);

  /// No description provided for @defaultGradePolicy.
  ///
  /// In en, this message translates to:
  /// **'Default grade-publication policy'**
  String get defaultGradePolicy;

  /// No description provided for @approvalVsPublication.
  ///
  /// In en, this message translates to:
  /// **'Approval is an internal decision. Publication is a separate Classroom API write. A grade is not visible to students just because it was approved here.'**
  String get approvalVsPublication;

  /// No description provided for @importSelectedCourses.
  ///
  /// In en, this message translates to:
  /// **'Import selected courses'**
  String get importSelectedCourses;

  /// No description provided for @disconnectGoogleClassroom.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Google Classroom'**
  String get disconnectGoogleClassroom;

  /// No description provided for @policyDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled — never publish through this connection'**
  String get policyDisabled;

  /// No description provided for @policyManualOnly.
  ///
  /// In en, this message translates to:
  /// **'Manual only — publish after an explicit publish action'**
  String get policyManualOnly;

  /// No description provided for @policyAfterApproval.
  ///
  /// In en, this message translates to:
  /// **'After teacher approval — create a publication job when a grade is approved'**
  String get policyAfterApproval;

  /// No description provided for @googleConnectedSnack.
  ///
  /// In en, this message translates to:
  /// **'Google Classroom connected.'**
  String get googleConnectedSnack;

  /// No description provided for @googleDisconnectedSnack.
  ///
  /// In en, this message translates to:
  /// **'Disconnected. Native classes and history were preserved.'**
  String get googleDisconnectedSnack;

  /// No description provided for @policyUpdatedSnack.
  ///
  /// In en, this message translates to:
  /// **'Default publication policy updated.'**
  String get policyUpdatedSnack;

  /// No description provided for @importedCoursesSnack.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} course(s). Duplicates were reused.'**
  String importedCoursesSnack(int count);

  /// No description provided for @courseworkFallback.
  ///
  /// In en, this message translates to:
  /// **'Coursework'**
  String get courseworkFallback;

  /// No description provided for @courseworkNotFound.
  ///
  /// In en, this message translates to:
  /// **'Coursework not found.'**
  String get courseworkNotFound;

  /// No description provided for @effectivePolicy.
  ///
  /// In en, this message translates to:
  /// **'Effective policy: {policy}'**
  String effectivePolicy(String policy);

  /// No description provided for @approvalLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Approval is local. Publication happens only after a verified Classroom API result.'**
  String get approvalLocalOnly;

  /// No description provided for @capabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Capability: {state}'**
  String capabilityLabel(String state);

  /// No description provided for @lastCheck.
  ///
  /// In en, this message translates to:
  /// **'Last check {date}'**
  String lastCheck(String date);

  /// No description provided for @eligibleCount.
  ///
  /// In en, this message translates to:
  /// **'Eligible {count}'**
  String eligibleCount(int count);

  /// No description provided for @blockedCount.
  ///
  /// In en, this message translates to:
  /// **'Blocked {count}'**
  String blockedCount(int count);

  /// No description provided for @pendingCount.
  ///
  /// In en, this message translates to:
  /// **'Pending {count}'**
  String pendingCount(int count);

  /// No description provided for @publishedCount.
  ///
  /// In en, this message translates to:
  /// **'Published {count}'**
  String publishedCount(int count);

  /// No description provided for @failedCount.
  ///
  /// In en, this message translates to:
  /// **'Failed {count}'**
  String failedCount(int count);

  /// No description provided for @conflictsCount.
  ///
  /// In en, this message translates to:
  /// **'Conflicts {count}'**
  String conflictsCount(int count);

  /// No description provided for @reviewPublicationPreview.
  ///
  /// In en, this message translates to:
  /// **'Review publication preview'**
  String get reviewPublicationPreview;

  /// No description provided for @publishGrades.
  ///
  /// In en, this message translates to:
  /// **'Publish grades'**
  String get publishGrades;

  /// No description provided for @unableToLoadPreview.
  ///
  /// In en, this message translates to:
  /// **'Unable to load preview.'**
  String get unableToLoadPreview;

  /// No description provided for @publicationPreviewHint.
  ///
  /// In en, this message translates to:
  /// **'Eligible items can be published. Blocked items stay local. Approved is not the same as published to students.'**
  String get publicationPreviewHint;

  /// No description provided for @scoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score {score}/{max}'**
  String scoreLabel(String score, String max);

  /// No description provided for @eligible.
  ///
  /// In en, this message translates to:
  /// **'Eligible'**
  String get eligible;

  /// No description provided for @blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blocked;

  /// No description provided for @approvedLocally.
  ///
  /// In en, this message translates to:
  /// **'Approved locally'**
  String get approvedLocally;

  /// No description provided for @notApproved.
  ///
  /// In en, this message translates to:
  /// **'Not approved'**
  String get notApproved;

  /// No description provided for @publishSelected.
  ///
  /// In en, this message translates to:
  /// **'Publish selected'**
  String get publishSelected;

  /// No description provided for @publishAllEligible.
  ///
  /// In en, this message translates to:
  /// **'Publish all eligible'**
  String get publishAllEligible;

  /// No description provided for @latestApiOutcomes.
  ///
  /// In en, this message translates to:
  /// **'Latest API outcomes'**
  String get latestApiOutcomes;

  /// No description provided for @verifiedGrade.
  ///
  /// In en, this message translates to:
  /// **'Verified grade {grade}'**
  String verifiedGrade(String grade);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @retryStatus.
  ///
  /// In en, this message translates to:
  /// **'Retry status: {status}'**
  String retryStatus(String status);

  /// No description provided for @publicationFinished.
  ///
  /// In en, this message translates to:
  /// **'Publication finished. Status comes from the Classroom API result, not this screen.'**
  String get publicationFinished;

  /// No description provided for @inheritPolicy.
  ///
  /// In en, this message translates to:
  /// **'Inherit connection default'**
  String get inheritPolicy;

  /// No description provided for @disablePublication.
  ///
  /// In en, this message translates to:
  /// **'Disable grade publication'**
  String get disablePublication;

  /// No description provided for @manualPublication.
  ///
  /// In en, this message translates to:
  /// **'Manual publication'**
  String get manualPublication;

  /// No description provided for @publishAfterApproval.
  ///
  /// In en, this message translates to:
  /// **'Publish after teacher approval'**
  String get publishAfterApproval;

  /// No description provided for @policyLabel.
  ///
  /// In en, this message translates to:
  /// **'Policy {policy} · {capability}'**
  String policyLabel(String policy, String capability);

  /// No description provided for @noLocalNotesLine.
  ///
  /// In en, this message translates to:
  /// **'{name}\n{notes}\n{subject}'**
  String noLocalNotesLine(String name, String notes, String subject);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
