import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rajesh_dada_padvi/controllers/Admin/grievance_controller.dart';
import 'package:rajesh_dada_padvi/widgets/app_page_frame.dart';

class AdminGrievanceScreen extends ConsumerStatefulWidget {
  const AdminGrievanceScreen({super.key});

  @override
  ConsumerState<AdminGrievanceScreen> createState() =>
      _AdminGrievanceScreenState();
}

class _AdminGrievanceScreenState extends ConsumerState<AdminGrievanceScreen> {
  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd-MM-yyyy hh:mm a').format(date);
  }

  Widget getScaffold(GrievanceState state) {
    final complaints = state.complaintsList?.complaints ?? [];
    return AppPageFrame(
      title: 'Complaints',
      subtitle: 'Admin view of grievance submissions.',
      icon: Icons.inbox_rounded,
      child: complaints.isEmpty
          ? const Center(child: Text('No Complaints'))
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                final complaint = complaints[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              complaint.fullName ?? 'N/A',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_rounded),
                            onPressed: () async {
                              try {
                                EasyLoading.show();
                                final response = await ref
                                    .read(grievanceControllerProvider.notifier)
                                    .deleteComplaintsById(
                                      id: complaint.id ?? '',
                                    );
                                if (response) {
                                  await ref
                                      .read(
                                        grievanceControllerProvider.notifier,
                                      )
                                      .refreshComplaintsList();
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Complaint deleted successfully',
                                      ),
                                    ),
                                  );
                                }
                              } finally {
                                EasyLoading.dismiss();
                              }
                            },
                          ),
                        ],
                      ),
                      Text('Mobile: ${complaint.mobileNumber ?? 'N/A'}'),
                      Text('Tehsil: ${complaint.tehsil ?? 'N/A'}'),
                      Text('Gender: ${complaint.gender ?? 'N/A'}'),
                      Text('Address: ${complaint.address ?? 'N/A'}'),
                      Text('Message: ${complaint.yourMessage ?? 'N/A'}'),
                      Text('Created: ${formatDate(complaint.createdAt)}'),
                    ],
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grievanceState = ref.watch(grievanceControllerProvider);
    return grievanceState.when(
      data: (state) => getScaffold(state),
      error: (error, stackTrace) =>
          const Scaffold(body: Text('Something Went Wrong')),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

