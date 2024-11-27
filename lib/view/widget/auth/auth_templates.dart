import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class AuthInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool visibilityIcon;
  final FormFieldValidator<String>? validator;

  const AuthInputField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.visibilityIcon = false,
    this.validator,
  }) : super(key: key);

  @override
  _AuthInputFieldState createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 238, 250, 235),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: widget.controller,
        cursorColor: Colors.black,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        style: TextStyle(color: Colors.black),
        obscureText: widget.visibilityIcon ? isObscure : false,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.black),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
          suffixIcon: widget.visibilityIcon
              ? IconButton(
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}

class AuthIconButton extends StatelessWidget {
  final void Function()? onPressed;

  final Icon icon;
  final String label;

  const AuthIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(50),
        foregroundColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Color.fromARGB(255, 244, 253, 241),
      ),
      icon: icon,
      label: Text(
        label,
        style: TextStyle(
          fontSize: 24,
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class AuthRichText extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onPressed;

  const AuthRichText({
    Key? key,
    required this.text,
    required this.linkText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
            color: Theme.of(context).colorScheme.secondary, fontSize: 20),
        text: text,
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()..onTap = onPressed,
            text: linkText,
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
