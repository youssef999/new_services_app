import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:freelancerApp/core/widgets/custom_textformfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _changePassword() async {
    final user = _auth.currentUser;
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;

    // Validation checks
    if (currentPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب إدخال كلمة المرور الحالية')),
      );
      return;
    }

    if (newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب إدخال كلمة المرور الجديدة')),
      );
      return;
    }

    if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('يجب أن تكون كلمة المرور الجديدة على الأقل 6 أحرف')),
      );
      return;
    }

    if (currentPassword == newPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمة المرور الحالية')),
      );
      return;
    }

    if (user == null) {
      print('لا يوجد مستخدم مسجل الدخول حاليا.');
      return;
    }

    try {
      // Re-authenticate the user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update the password
      await user.updatePassword(newPassword);
      await user.reload();
      final updatedUser = _auth.currentUser;

      // Notify user of success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تحديث كلمة المرور بنجاح')),
      );
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تحديث كلمة المرور: $e')),
      );
      print('خطأ في تحديث كلمة المرور: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تغيير كلمة المرور')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(
              controller: _currentPasswordController,
              hint: 'كلمة المرور الحالية',
              obs: false,
            ),
            const SizedBox(height: 20),
            CustomTextFormField(
              controller: _newPasswordController,
              hint: 'كلمة المرور الجديدة',
              obs: false,
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: _changePassword,
              text: 'تغيير',
            ),
          ],
        ),
      ),
    );
  }
}
