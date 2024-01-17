import 'package:flutter/material.dart';

class MessageFieldBox extends StatelessWidget {
  final ValueChanged<String> onValue;
  final Function onTap;
  const MessageFieldBox({super.key, required this.onValue,required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final focusNode = FocusNode();

    // final ColorScheme colors = Theme.of(context).colorScheme;
    final outlineInputBorder = UnderlineInputBorder(
      borderRadius: BorderRadius.circular(40),
      borderSide: const BorderSide(color: Colors.transparent),
    );

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        onTap: () {
          onTap();
        },
        onTapOutside: (event) {
          focusNode.unfocus();
        },
        focusNode: focusNode,
        controller: textController,
        decoration: InputDecoration(
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder,
          filled: true,
          hintText: 'Escribe tu mensaje',
          suffixIcon: IconButton(
            icon: const Icon(Icons.send_outlined),
            onPressed: () {
              final textValue = textController.text;
              textController.clear();
              onValue(textValue);
            },
          ),
        ),
        
        onFieldSubmitted: (value) {
          onValue(value);
          textController.clear();
          focusNode.requestFocus();
        },
      ),
    );
  }
}
