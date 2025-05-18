import 'package:flutter/material.dart';

class ExperienceListItem extends StatefulWidget {
  final String username;
  final int rating;
  final String comment;
  final String date;

  const ExperienceListItem({
    Key? key,
    required this.username,
    required this.rating,
    required this.comment,
    required this.date,
  }) : super(key: key);

  @override
  State<ExperienceListItem> createState() => _ExperienceListItemState();
}

class _ExperienceListItemState extends State<ExperienceListItem> {
  bool _isExpanded = false;
  static const int _maxLines = 2;
  late final TextPainter _textPainter;
  late final bool _hasOverflow;

  @override
  void initState() {
    super.initState();
    // Check if the text will overflow
    _textPainter = TextPainter(
      text: TextSpan(
        text: widget.comment,
        style: const TextStyle(fontSize: 14),
      ),
      maxLines: _maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 300); // Approximate width

    _hasOverflow = _textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info and rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Rating stars
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < widget.rating ? Icons.star : Icons.star_border,
                  color: Theme.of(context).highlightColor,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Comment with "See more" option
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.comment,
                  maxLines: _isExpanded ? null : _maxLines,
                  overflow: _isExpanded ? null : TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
                if (_hasOverflow)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        _isExpanded ? 'See less' : 'See more',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
