import 'package:flutter/material.dart';
import 'package:flutterbestplace/components/text_field_container.dart';
import 'package:flutterbestplace/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final String InitialValue;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validate;
  final TextInputType KeyboardType;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.InitialValue,
    this.icon,
    this.onChanged,
    this.validate,
    this.KeyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      nb: 0.8,
      child: TextFormField(
        initialValue: InitialValue,
        onSaved: onChanged,
        cursorColor: kPrimaryColor,
        validator: validate,
        keyboardType: KeyboardType,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
