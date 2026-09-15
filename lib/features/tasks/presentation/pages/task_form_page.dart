import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../projects/domain/entities/project.dart';
import '../../../projects/presentation/cubit/projects_cubit.dart';
import '../../../projects/presentation/cubit/projects_state.dart';
import '../../domain/entities/task_priority.dart';
import '../../domain/entities/task_status.dart';
import '../cubit/task_form_cubit.dart';
import '../cubit/task_form_state.dart';

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({super.key});

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  late final TextEditingController _title;
  late final TextEditingController _description;

  @override
  void initState() {
    super.initState();
    final state = context.read<TaskFormCubit>().state;
    _title = TextEditingController(text: state.title);
    _description = TextEditingController(text: state.description);
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskFormCubit, TaskFormState>(
      listenWhen: (previous, current) =>
          current.submitted || current.failure != null,
      listener: (context, state) {
        if (state.failure != null) {
          context.showSnack(state.failure!.message);
        }
        if (state.submitted) {
          context.showSnack(
            state.isEditing ? 'Task updated.' : 'Task created.',
          );
          context.pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.isEditing ? 'Edit task' : 'New task'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppTextField(
                label: 'Title',
                controller: _title,
                onChanged: context.read<TaskFormCubit>().setTitle,
              ),
              if (state.titleError != null) ...[
                const SizedBox(height: 6),
                Text(
                  state.titleError!,
                  style: TextStyle(color: context.colors.error),
                ),
              ],
              const SizedBox(height: 16),
              AppTextField(
                label: 'Description',
                controller: _description,
                maxLines: 4,
                onChanged: context.read<TaskFormCubit>().setDescription,
              ),
              const SizedBox(height: 16),
              BlocBuilder<ProjectsCubit, ProjectsState>(
                builder: (context, projectsState) {
                  final projects = switch (projectsState) {
                    ProjectsSuccess(:final projects) => projects,
                    _ => const <Project>[],
                  };
                  return DropdownButtonFormField<String>(
                    // ignore: deprecated_member_use
                    value: state.projectId,
                    decoration: InputDecoration(
                      labelText: 'Project',
                      errorText: state.projectError,
                    ),
                    items: projects
                        .map(
                          (project) => DropdownMenuItem(
                            value: project.id,
                            child: Text(project.name),
                          ),
                        )
                        .toList(),
                    onChanged: context.read<TaskFormCubit>().setProjectId,
                  );
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskStatus>(
                // ignore: deprecated_member_use
                value: state.status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: TaskStatus.values
                    .map(
                      (status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    context.read<TaskFormCubit>().setStatus(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskPriority>(
                // ignore: deprecated_member_use
                value: state.priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: TaskPriority.values
                    .map(
                      (priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(priority.label),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    context.read<TaskFormCubit>().setPriority(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Due date'),
                subtitle: Text(
                  state.dueDate == null
                      ? 'Not set'
                      : DateFormat.yMMMd().format(state.dueDate!.toLocal()),
                ),
                trailing: const Icon(Icons.event),
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                    initialDate: state.dueDate ?? DateTime.now(),
                  );
                  if (selected != null && context.mounted) {
                    context.read<TaskFormCubit>().setDueDate(selected);
                  }
                },
              ),
              const SizedBox(height: 24),
              AppButton(
                label: state.isEditing ? 'Save changes' : 'Create task',
                loading: state.submitting,
                onPressed: () => context.read<TaskFormCubit>().submit(),
              ),
            ],
          ),
        );
      },
    );
  }
}
