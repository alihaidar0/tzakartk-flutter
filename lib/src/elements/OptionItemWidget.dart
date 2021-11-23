import 'package:flutter/material.dart';

import '../models/option.dart';
import '../models/option_group.dart';

class OptionItemWidget extends StatefulWidget {
  final OptionGroup optionGroup;
  final List<Option> options;
  final Option option;
  final VoidCallback onChanged;

  OptionItemWidget({
    Key key,
    this.optionGroup,
    this.options,
    this.option,
    this.onChanged,
  }) : super(key: key);

  @override
  _OptionItemWidgetState createState() => _OptionItemWidgetState();
}

class _OptionItemWidgetState extends State<OptionItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.option.checked
            ? Theme.of(context).accentColor
            : Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(color: Colors.black,)
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {
          widget.option.checked = !widget.option.checked;
          widget.options.forEach((opt) {
            if (opt.optionGroupId == widget.optionGroup.id &&
                opt.id != widget.option.id) opt.checked = false;
          });
          widget.onChanged();
        },
        child: Text(
          Localizations.localeOf(context).languageCode == 'en'
              ? widget.option.name
              : widget.option.ar_name,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w500,
              color: widget.option.checked ? Colors.white : Colors.black,
              height: 1.2),
        ),
      ),
    );
  }
}
