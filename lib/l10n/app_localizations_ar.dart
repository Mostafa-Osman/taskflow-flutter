// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تاسك فلو';

  @override
  String get navProjects => 'المشاريع';

  @override
  String get navClasses => 'الفصول';

  @override
  String get navTasks => 'المهام';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get language => 'اللغة';

  @override
  String get languageSystem => 'النظام';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get appearance => 'المظهر';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get environment => 'البيئة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get guest => 'زائر';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get retryLoadingMore => 'إعادة تحميل المزيد';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get signInSubtitle => 'سجّل الدخول لإدارة المشاريع والمهام.';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get name => 'الاسم';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get createAnAccount => 'إنشاء حساب';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ سجّل الدخول';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب.';

  @override
  String get emailInvalid => 'أدخل بريدًا إلكترونيًا صالحًا.';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة.';

  @override
  String get passwordTooShort => 'يجب أن تكون كلمة المرور 8 أحرف على الأقل.';

  @override
  String get nameRequired => 'الاسم مطلوب.';

  @override
  String get nameTooShort => 'يجب أن يتكون الاسم من حرفين على الأقل.';

  @override
  String get classNameRequired => 'اسم الفصل مطلوب.';

  @override
  String get titleRequired => 'العنوان مطلوب.';

  @override
  String get projectRequired => 'المشروع مطلوب.';

  @override
  String get projectsTitle => 'المشاريع';

  @override
  String get noProjectsYet => 'لا توجد مشاريع بعد';

  @override
  String get noProjectsMessage => 'ستظهر المشاريع هنا بعد إنشائها.';

  @override
  String get projectTitle => 'المشروع';

  @override
  String get addTask => 'إضافة مهمة';

  @override
  String get tasksTitle => 'المهام';

  @override
  String get noTasksInProject => 'لا توجد مهام في هذا المشروع بعد.';

  @override
  String projectProgress(int completed, int total) {
    return '$completed/$total مكتمل';
  }

  @override
  String updatedOn(String date) {
    return 'تحديث $date';
  }

  @override
  String get newTask => 'مهمة جديدة';

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get searchTasks => 'البحث في المهام';

  @override
  String get noTasksMatch => 'لا توجد مهام مطابقة';

  @override
  String get noTasksMatchMessage => 'جرّب بحثًا مختلفًا أو امسح عوامل التصفية.';

  @override
  String get status => 'الحالة';

  @override
  String get priority => 'الأولوية';

  @override
  String get clear => 'مسح';

  @override
  String get allStatuses => 'كل الحالات';

  @override
  String get allPriorities => 'كل الأولويات';

  @override
  String get endOfList => 'وصلت إلى نهاية القائمة.';

  @override
  String get title => 'العنوان';

  @override
  String get description => 'الوصف';

  @override
  String get project => 'المشروع';

  @override
  String get dueDate => 'تاريخ الاستحقاق';

  @override
  String get notSet => 'غير محدد';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get createTask => 'إنشاء مهمة';

  @override
  String get taskCreated => 'تم إنشاء المهمة.';

  @override
  String get taskUpdated => 'تم تحديث المهمة.';

  @override
  String get taskDeleted => 'تم حذف المهمة.';

  @override
  String get taskTitle => 'المهمة';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get markCompleted => 'تعيين كمكتملة';

  @override
  String get taskStatusTodo => 'للتنفيذ';

  @override
  String get taskStatusInProgress => 'قيد التنفيذ';

  @override
  String get taskStatusDone => 'مكتملة';

  @override
  String get priorityLow => 'منخفضة';

  @override
  String get priorityMedium => 'متوسطة';

  @override
  String get priorityHigh => 'عالية';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get noNotifications => 'لا توجد إشعارات';

  @override
  String get noNotificationsMessage => 'ستظهر هنا نشاطات مساحة العمل.';

  @override
  String get notFoundTitle => 'غير موجود';

  @override
  String get pageDoesNotExist => 'هذه الصفحة غير موجودة';

  @override
  String get pageDoesNotExistMessage =>
      'قد يكون الرابط تالفًا أو تمت إزالة العنصر.';

  @override
  String get goToProjects => 'الانتقال إلى المشاريع';

  @override
  String get classesTitle => 'الفصول';

  @override
  String get integrationSettings => 'إعدادات التكامل';

  @override
  String get createNativeClass => 'إنشاء فصل محلي';

  @override
  String get noClassesYet => 'لا توجد فصول بعد';

  @override
  String get noClassesMessage =>
      'يمكنك إنشاء فصل محلي في أي وقت. جوجل كلاس روم اختياري.';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterNative => 'محلي';

  @override
  String get filterGoogleConnected => 'مرتبط بجوجل';

  @override
  String get filterSyncIssues => 'مشاكل المزامنة';

  @override
  String get nativeClassHint => 'يمكنك إنشاء فصل محلي دون ربط جوجل كلاس روم.';

  @override
  String get className => 'اسم الفصل';

  @override
  String get subjectOptional => 'المادة (اختياري)';

  @override
  String get localDescription => 'الوصف (محلي)';

  @override
  String get nativeClassCreated => 'تم إنشاء الفصل المحلي.';

  @override
  String get sourceNative => 'محلي';

  @override
  String get sourceImported => 'مستورد';

  @override
  String get googleConnected => 'مرتبط بجوجل';

  @override
  String get syncIssue => 'مشكلة مزامنة';

  @override
  String get statusActive => 'نشط';

  @override
  String get statusArchived => 'مؤرشف';

  @override
  String externalLabel(String name, String section) {
    return 'خارجي: $name · $section';
  }

  @override
  String get classTitle => 'الفصل';

  @override
  String get mapped => 'مربوط';

  @override
  String get locallyManaged => 'يُدار محليًا';

  @override
  String get localClassFields => 'الاسم والوصف والمادة المحلية';

  @override
  String get noLocalNotes => 'لا توجد ملاحظات محلية';

  @override
  String get noSubject => 'بدون مادة';

  @override
  String get externallySynchronized => 'متزامن خارجيًا';

  @override
  String externalSectionRoom(String section, String room) {
    return 'الشعبة $section · الغرفة $room';
  }

  @override
  String get mapExistingCourse => 'ربط مقرر جوجل قائم';

  @override
  String get synchronizeCourse => 'مزامنة المقرر';

  @override
  String get unmapExternalCourse => 'إلغاء ربط المقرر الخارجي';

  @override
  String get coursework => 'الواجبات';

  @override
  String get noCourseworkYet => 'لا توجد واجبات مستوردة بعد.';

  @override
  String get connectBrowseFirst =>
      'اربط جوجل كلاس روم ثم استورد المقررات أو تصفحها أولًا.';

  @override
  String get confirmMapping => 'تأكيد الربط';

  @override
  String confirmMappingMessage(String name) {
    return 'ربط هذا الفصل المحلي بـ $name؟ لن يتم دمج الطلاب بالاسم أو رقم الهاتف.';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get mappingSaved => 'تم حفظ الربط.';

  @override
  String get googleClassroom => 'جوجل كلاس روم';

  @override
  String get googleOptionalHint =>
      'ربط جوجل كلاس روم اختياري. تبقى الفصول المحلية في هذا الحساب إذا لم تربط أو إذا فصلت لاحقًا.';

  @override
  String get connectGoogleClassroom => 'ربط جوجل كلاس روم';

  @override
  String connectionStatus(String status) {
    return 'الاتصال $status';
  }

  @override
  String get defaultGradePolicy => 'سياسة نشر الدرجات الافتراضية';

  @override
  String get approvalVsPublication =>
      'الاعتماد قرار داخلي. النشر عملية منفصلة عبر واجهة كلاس روم. الدرجة لا تظهر للطلاب لمجرد اعتمادها هنا.';

  @override
  String get importSelectedCourses => 'استيراد المقررات المحددة';

  @override
  String get disconnectGoogleClassroom => 'فصل جوجل كلاس روم';

  @override
  String get policyDisabled => 'معطّل — لا يُنشر أي شيء عبر هذا الاتصال';

  @override
  String get policyManualOnly => 'يدوي فقط — انشر بعد إجراء نشر صريح';

  @override
  String get policyAfterApproval =>
      'بعد اعتماد المعلم — إنشاء مهمة نشر عند اعتماد الدرجة';

  @override
  String get googleConnectedSnack => 'تم ربط جوجل كلاس روم.';

  @override
  String get googleDisconnectedSnack =>
      'تم الفصل. بقيت الفصول المحلية والسجل محفوظة.';

  @override
  String get policyUpdatedSnack => 'تم تحديث سياسة النشر الافتراضية.';

  @override
  String importedCoursesSnack(int count) {
    return 'تم استيراد $count مقرر. أُعيد استخدام المكرر.';
  }

  @override
  String get courseworkFallback => 'الواجب';

  @override
  String get courseworkNotFound => 'الواجب غير موجود.';

  @override
  String effectivePolicy(String policy) {
    return 'السياسة الفعلية: $policy';
  }

  @override
  String get approvalLocalOnly =>
      'الاعتماد محلي. يحدث النشر فقط بعد نتيجة مؤكدة من واجهة كلاس روم.';

  @override
  String capabilityLabel(String state) {
    return 'القدرة: $state';
  }

  @override
  String lastCheck(String date) {
    return 'آخر فحص $date';
  }

  @override
  String eligibleCount(int count) {
    return 'مؤهل $count';
  }

  @override
  String blockedCount(int count) {
    return 'محظور $count';
  }

  @override
  String pendingCount(int count) {
    return 'قيد الانتظار $count';
  }

  @override
  String publishedCount(int count) {
    return 'منشور $count';
  }

  @override
  String failedCount(int count) {
    return 'فشل $count';
  }

  @override
  String conflictsCount(int count) {
    return 'تعارضات $count';
  }

  @override
  String get reviewPublicationPreview => 'مراجعة معاينة النشر';

  @override
  String get publishGrades => 'نشر الدرجات';

  @override
  String get unableToLoadPreview => 'تعذر تحميل المعاينة.';

  @override
  String get publicationPreviewHint =>
      'يمكن نشر العناصر المؤهلة. تبقى المحظورة محلية. الاعتماد لا يعني أن الدرجة ظهرت للطلاب.';

  @override
  String scoreLabel(String score, String max) {
    return 'الدرجة $score/$max';
  }

  @override
  String get eligible => 'مؤهل';

  @override
  String get blocked => 'محظور';

  @override
  String get approvedLocally => 'معتمد محليًا';

  @override
  String get notApproved => 'غير معتمد';

  @override
  String get publishSelected => 'نشر المحدد';

  @override
  String get publishAllEligible => 'نشر كل المؤهل';

  @override
  String get latestApiOutcomes => 'أحدث نتائج الواجهة';

  @override
  String verifiedGrade(String grade) {
    return 'درجة مؤكدة $grade';
  }

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String retryStatus(String status) {
    return 'حالة إعادة المحاولة: $status';
  }

  @override
  String get publicationFinished =>
      'انتهى النشر. الحالة ناتجة عن واجهة كلاس روم وليس من هذه الشاشة.';

  @override
  String get inheritPolicy => 'وراثة إعداد الاتصال';

  @override
  String get disablePublication => 'تعطيل نشر الدرجات';

  @override
  String get manualPublication => 'نشر يدوي';

  @override
  String get publishAfterApproval => 'النشر بعد اعتماد المعلم';

  @override
  String policyLabel(String policy, String capability) {
    return 'السياسة $policy · $capability';
  }

  @override
  String noLocalNotesLine(String name, String notes, String subject) {
    return '$name\n$notes\n$subject';
  }
}
