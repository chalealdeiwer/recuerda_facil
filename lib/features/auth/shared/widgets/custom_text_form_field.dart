import 'package:flutter/material.dart';


class CustomTextFormField extends StatelessWidget {

  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;

  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key, 
    this.label, 
    this.hint, 
    this.errorMessage, 
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged, 
    this.onFieldSubmitted,
    this.validator, 

  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;


    


    return Container(
      decoration:  const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: TextFormField(
        
        onChanged: onChanged,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle( fontSize: 30, color: Colors.black),
        decoration: InputDecoration(
          floatingLabelStyle:  TextStyle(color: colors.primary, fontSize: 35),
          // enabledBorder: border,
          // focusedBorder: border,
          // errorBorder: border.copyWith( borderSide: const BorderSide( color: Colors.transparent )),
          // focusedErrorBorder: border.copyWith( borderSide:const  BorderSide( color: Colors.transparent )),
          isDense: true,
          label: label != null ? Text(label!) : null,
          labelStyle: const TextStyle(fontSize: 30,color: Colors.black),
          hintText: hint,
          errorText: errorMessage,
          errorStyle: const TextStyle(fontSize: 20,color: Colors.red ),
          focusColor: colors.primary,
          border:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.black))),
          // icon: Icon( Icons.supervised_user_circle_outlined, color: colors.primary, )
        
      ),
    );
  }
}
