import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:freelancerApp/features/Tasks/controllers/user_tasks_controller.dart';
import 'package:get/get.dart';

import '../models/proposal.dart';

class ProposalScreen extends StatefulWidget {
  final String taskId;

  const ProposalScreen({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  @override
  _ProposalScreenState createState() => _ProposalScreenState();
}

class _ProposalScreenState extends State<ProposalScreen> {
  late Future<List<Proposal>> _proposalsFuture;
  UserTasksController controller = Get.put(UserTasksController());

  @override
  void initState() {
    super.initState();
    _proposalsFuture = controller.fetchProposals(widget.taskId);
  }

  // Function to accept a proposal
  Future<void> _acceptProposal(Proposal proposal) async {
    try {
      // Add the proposal to the accepted_proposals collection
      await FirebaseFirestore.instance
          .collection('accepted_proposals')
          .add(proposal.toMap());

      // Remove the proposal from the proposals collection
      await FirebaseFirestore.instance
          .collection('proposals')
          .doc(proposal.id) // assuming proposal has an 'id' field
          .delete();
      setState(() {});
      // Show success snackbar
      Get.snackbar(
        'نجاح',
        'تم قبول هذه الخدمة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to accept the proposal. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Function to reject a proposal
  Future<void> _rejectProposal(Proposal proposal) async {
    try {
      // Remove the proposal from the proposals collection
      await FirebaseFirestore.instance
          .collection('proposals')
          .doc(proposal.id) // assuming proposal has an 'id' field
          .delete();

      // Show rejection snackbar
      Get.snackbar(
        'رفض ناجح',
        'تم رفض هذه الخدمة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reject the proposal. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'العروض المقدمة لهذه الخدمة',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: FutureBuilder<List<Proposal>>(
        future: _proposalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا يوجد عروض مقدمة بعد'));
          }

          final proposals = snapshot.data!;

          return ListView.builder(
            itemCount: proposals.length,
            itemBuilder: (context, index) {
              final proposal = proposals[index];
              return Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.task,
                          color: AppColors.primary,
                          size: 30,
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                proposal.name,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                proposal.details,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Row(
                          children: [
                            Text(
                              proposal.price,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            const Text(
                              'KWD',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    FittedBox(
                      child: Row(
                        children: [
                          CustomButton(
                            text: 'قبول',
                            btnColor: Colors.green,
                            onPressed: () => _acceptProposal(proposal),
                          ),
                          const SizedBox(width: 10),
                          CustomButton(
                            text: 'رفض',
                            btnColor: Colors.red,
                            onPressed: () => _rejectProposal(proposal),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
