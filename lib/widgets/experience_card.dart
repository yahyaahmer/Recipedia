import 'package:flutter/material.dart';

class ExperienceCard extends StatelessWidget {
  final String username;
  final int rating;
  final String comment;
  final String imageUrl;
  final String userImageUrl;
  final String date;

  ExperienceCard({
    required this.username,
    required this.rating,
    required this.comment,
    required this.imageUrl,
    required this.userImageUrl,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(userImageUrl),
            ),
            title: Text(username),
            subtitle: Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Theme.of(context).highlightColor,
                  size: 16,
                ),
              ),
            ),
            trailing: Text(date),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(comment),
          ),
          Container(
            height: 200,
            width: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.favorite_border),
                  label: Text('12'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.comment_outlined),
                  label: Text('3'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.share),
                  label: Text('Share'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
