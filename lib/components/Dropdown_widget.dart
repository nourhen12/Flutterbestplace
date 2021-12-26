import 'package:flutter/material.dart';
import 'package:flutterbestplace/components/text_field_container.dart';
import 'package:flutterbestplace/constants.dart';

class DropdownWidget extends StatelessWidget {
  final Widget HintText;
  final IconData icon;
  final List<String> Items;
  final ValueChanged<String> onChanged;
  final String valueSelect;
  final FormFieldValidator<String> validate;
  const DropdownWidget({
    Key key,
    this.HintText,
    this.icon,
    this.Items,
    this.onChanged,
    this.valueSelect,
    this.validate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      nb: 0.8,
      child: DropdownButtonFormField<String>(
        value: valueSelect,
        hint: HintText,
        iconDisabledColor: kPrimaryColor,
        iconSize: 20,
        onChanged: onChanged,
        items: Items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        validator: validate,
      ),
    );
  }
}
