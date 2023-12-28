part of flutter_mentions;

class OptionList extends StatefulWidget {
  OptionList({
    required this.data,
    required this.onTap,
    required this.suggestionListHeight,
    required this.listFocusNode,
    this.suggestionListWidth,
    // this.suggestionBuilder,
    this.suggestionListDecoration,
  });

  final FocusNode listFocusNode;

  // final Widget Function(Map<String, dynamic>)? suggestionBuilder;

  final List<Map<String, dynamic>> data;

  final Function(Map<String, dynamic>) onTap;

  final double suggestionListHeight;
  final double? suggestionListWidth;

  final BoxDecoration? suggestionListDecoration;

  @override
  State<OptionList> createState() => _OptionListState();
}

class _OptionListState extends State<OptionList> {
  final ScrollController _controller = ScrollController();

  int? selectedIndex;

  void _handleKeyEvent(RawKeyEvent event) {
    var offset = _controller.offset;
    if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      setState(() {
        if (selectedIndex == null) {
          selectedIndex = 0;
        } else {
          if (selectedIndex != 0) {
            selectedIndex = selectedIndex! - 1;

            _controller.jumpTo(
              offset - 10,
            );
          }
        }
      });
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      setState(() {
        if (selectedIndex == null) {
          selectedIndex = 0;
        } else {
          if (selectedIndex != (widget.data.length - 1)) {
            selectedIndex = selectedIndex! + 1;
            _controller.jumpTo(
              offset + 10,
            );
          }
        }
      });
    } else if (event.isKeyPressed(LogicalKeyboardKey.enter) ||
        event.isKeyPressed(LogicalKeyboardKey.numpadEnter)) {
      widget.onTap(widget.data[selectedIndex!]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.data.isNotEmpty
        ? Container(
            decoration: widget.suggestionListDecoration ??
                BoxDecoration(color: Colors.white),
            constraints: BoxConstraints(
              maxHeight: widget.suggestionListHeight,
              minHeight: 0,
              maxWidth: widget.suggestionListWidth ?? double.infinity,
              minWidth: 0,
            ),
            child: RawKeyboardListener(
              focusNode: widget.listFocusNode,
              onKey: _handleKeyEvent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suggestions',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: _controller,
                        itemCount: widget.data.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              widget.onTap(widget.data[index]);
                            },
                            child: Container(
                              color: selectedIndex == index
                                  ? Colors.black38
                                  : Colors.white,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          widget.data[index]['display'],
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          widget.data[index]['email'],
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 5,
                                    thickness: 2,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }
}
