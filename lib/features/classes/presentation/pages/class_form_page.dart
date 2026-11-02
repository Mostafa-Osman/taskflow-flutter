import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/class_form_cubit.dart';
import '../cubit/class_form_state.dart';

class ClassFormPage extends StatefulWidget {
  const ClassFormPage({super.key});

  @override
  State<ClassFormPage> createState() => _ClassFormPageState();
}

class _ClassFormPageState extends State<ClassFormPage> {
  late final TextEditingController _name;
  late final TextEditingController _subject;
  late final TextEditingController _description;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _subject = TextEditingController();
    _description = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _subject.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClassFormCubit, ClassFormState>(
      listenWhen: (previous, current) =>
          current.submitted || current.failure != null,
      listener: (context, state) {
        if (state.failure != null) {
          context.showSnack(state.failure!.message);
        }
        if (state.submitted) {
          context.showSnack(context.l10n.nativeClassCreated);
          context.pop(true);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(context.l10n.createNativeClass)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(context.l10n.nativeClassHint),
              const SizedBox(height: 16),
              AppTextField(
                label: context.l10n.className,
                controller: _name,
                onChanged: context.read<ClassFormCubit>().setName,
              ),
              if (state.nameError != null) ...[
                const SizedBox(height: 6),
                Text(
                  state.nameError!,
                  style: TextStyle(color: context.colors.error),
                ),
              ],
              const SizedBox(height: 16),
              AppTextField(
                label: context.l10n.subjectOptional,
                controller: _subject,
                onChanged: context.read<ClassFormCubit>().setSubject,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: context.l10n.localDescription,
                controller: _description,
                maxLines: 3,
                onChanged: context.read<ClassFormCubit>().setDescription,
              ),
              const SizedBox(height: 24),
              AppButton(
                label: context.l10n.createNativeClass,
                loading: state.submitting,
                onPressed: () => context.read<ClassFormCubit>().submit(),
              ),
            ],
          ),
        );
      },
    );
  }
}
