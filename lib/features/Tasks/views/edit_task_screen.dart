import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/features/Tasks/controllers/user_tasks_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For formatting date and time
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/widgets/custom_textformfield.dart';
import 'package:freelancerApp/features/Tasks/models/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _catController;
  late TextEditingController _dateController;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;
  late TextEditingController _phoneController;
  late TextEditingController _timeController;
  late TextEditingController _endTimeController;
  late TextEditingController _userNameController;
  late TextEditingController _userEmailController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _catController = TextEditingController(text: widget.task.cat);
    _dateController =
        TextEditingController(text: formatTaskDate(widget.task.date));
    _minPriceController = TextEditingController(text: widget.task.minPrice);
    _maxPriceController = TextEditingController(text: widget.task.maxPrice);
    _phoneController = TextEditingController(text: widget.task.phone);
    _timeController =
        TextEditingController(text: formatTimeString(widget.task.time));
    _endTimeController =
        TextEditingController(text: formatTimeString(widget.task.end_time));
    _userNameController = TextEditingController(text: widget.task.user_name);
    _userEmailController = TextEditingController(text: widget.task.user_email);
  }

  String formatTimeString(String timeString) {
    // Ensure that the input string is in "HH:mm" format
    if (timeString.contains('TimeOfDay')) {
      // Extract just the "07:31" part from "TimeOfDay(07:31)"
      timeString = timeString.replaceAll(RegExp(r'[^0-9:]'), '');
    }

    // Parse the time from the string (assumes format "HH:mm")
    final timeParts = timeString.split(":");
    final hour = int.parse(timeParts[0]);
    final minute = timeParts[1];

    // Convert to 12-hour format
    final period = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour == 0
        ? 12 // Midnight case
        : (hour > 12
            ? hour - 12
            : hour); // Convert 24-hour format to 12-hour format

    return '$formattedHour:$minute ';
  }

  String formatTaskDate(String date) {
    try {
      // Parse the input date string into a DateTime object
      DateTime parsedDate = DateTime.parse(date);

      // Format the date as YYYY-MM-DD (without leading zeros in day and month)
      String formattedDate =
          '${parsedDate.year}-${parsedDate.month}-${parsedDate.day}';

      return formattedDate;
    } catch (e) {
      // If the input date is invalid, handle the error
      print('Error parsing date: $e');
      return date; // Return the original date if there is an error
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _catController.dispose();
    _dateController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _phoneController.dispose();
    _timeController.dispose();
    _endTimeController.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    super.dispose();
  }

  // Method to pick a date
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Method to pick a start time
  Future<void> _pickTime(TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: false), // Ensure AM/PM is used
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final formattedTime = DateFormat('hh:mm a').format(
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute),
        );
        controller.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'تعديل هذه المهمة',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.task.image,
                    height: 180.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              CustomTextFormField(
                hint: 'عنوان الطلب', // Arabic hint for title
                max: 1,
                color: Colors.black,
                icon: Icons.title,
                obs: false,
                controller: _titleController,
              ),
              const SizedBox(height: 16.0),
              CustomTextFormField(
                hint: 'الفئة', // Arabic hint for category
                max: 1,
                color: Colors.black,
                icon: Icons.category,
                obs: false,
                controller: _catController,
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    hint: 'التاريخ', // Arabic hint for date
                    max: 1,
                    color: Colors.black,
                    icon: Icons.calendar_today,
                    obs: false,
                    controller: _dateController,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              CustomTextFormField(
                hint: 'الوصف', // Arabic hint for description
                max: 5,
                color: Colors.black,
                icon: Icons.description,
                obs: false,
                controller: _descriptionController,
              ),
              const SizedBox(height: 16.0),
              CustomTextFormField(
                hint: 'أدنى سعر', // Arabic hint for min price
                max: 1,
                color: Colors.black,
                icon: Icons.monetization_on,
                obs: false,
                controller: _minPriceController,
              ),
              const SizedBox(height: 16.0),
              CustomTextFormField(
                hint: 'أقصى سعر', // Arabic hint for max price
                max: 1,
                color: Colors.black,
                icon: Icons.monetization_on,
                obs: false,
                controller: _maxPriceController,
              ),
              const SizedBox(height: 16.0),
              CustomTextFormField(
                hint: 'رقم الهاتف', // Arabic hint for phone number
                max: 1,
                color: Colors.black,
                icon: Icons.phone,
                obs: false,
                controller: _phoneController,
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => _pickTime(_timeController),
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    hint: 'وقت البدء', // Arabic hint for start time
                    max: 1,
                    color: Colors.black,
                    icon: Icons.access_time,
                    obs: false,
                    controller: _timeController,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => _pickTime(_endTimeController),
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    hint: 'وقت الانتهاء', // Arabic hint for end time
                    max: 1,
                    color: Colors.black,
                    icon: Icons.access_time,
                    obs: false,
                    controller: _endTimeController,
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () {
                    //if (_formKey.currentState!.validate()) {
                      _saveTask();
                   // }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'تحديث المهمة',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveTask() async {

    print("SAVE TASK...");
    CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');
    String taskId = widget.task.id;

    try {
      await tasks.doc(taskId).update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'cat': _catController.text,
        'date': _dateController.text,
        'minPrice': _minPriceController.text,
        'maxPrice': _maxPriceController.text,
        'phone': _phoneController.text,
        'time': _timeController.text,
        'end_time': _endTimeController.text,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('تم تحديث المهمة بنجاح'),
        ),
      );
      Navigator.of(context).pop();
      UserTasksController controller = Get.put(UserTasksController());
      controller.getUserTaskList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('حدث خطأ ما'),
        ),
      );
    }
  }
}
