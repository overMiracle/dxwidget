import 'package:flutter/material.dart';

class DxTextFieldFab extends StatefulWidget {
  // The placeholder label
  final String label;

  // The icon to be used on the FAB
  final IconData icon;

  // The background color of the FAB
  final Color backgroundColor;

  // The color of the icon on the FAB
  final Color iconColor;

  // A callback function for each simple there is a change to the TextField's text
  final void Function(String)? onChange;

  // A callback function to return the current value of the TextField's text on submission
  final void Function(String)? onSubmit;

  // A function to handle operations that need to be performed when the TextField is cleared or closed
  final VoidCallback? onClear;

  const DxTextFieldFab(
    Key? key,
    this.label,
    this.icon, {
    this.onChange,
    this.onSubmit,
    this.onClear,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.grey,
  }) : super(key: key);

  @override
  State<DxTextFieldFab> createState() => _DxTextFieldFabState();
}

class _DxTextFieldFabState extends State<DxTextFieldFab> {
  bool folded = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: folded ? 56 : MediaQuery.of(context).size.width / 1.5,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: widget.backgroundColor,
        boxShadow: kElevationToShadow[6],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: !folded
                    ? TextField(
                        decoration: InputDecoration(
                          hintText: widget.label,
                          hintStyle: TextStyle(color: widget.iconColor),
                          border: InputBorder.none,
                        ),
                        onChanged: (String v) => widget.onChange?.call(v),
                        onSubmitted: (String v) => widget.onSubmit?.call(v),
                      )
                    : null),
          ),
          Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(folded ? 32 : 0),
                topRight: const Radius.circular(32),
                bottomLeft: Radius.circular(folded ? 32 : 0),
                bottomRight: const Radius.circular(32),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(folded ? widget.icon : Icons.close, color: widget.iconColor),
              ),
              onTap: () {
                setState(() {
                  widget.onClear?.call();
                  folded = !folded;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
