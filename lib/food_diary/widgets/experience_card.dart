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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  userImageUrl.isNotEmpty
                      ? NetworkImage(userImageUrl)
                      : const AssetImage('assets/images/default_user.png')
                          as ImageProvider,
              child: userImageUrl.isEmpty ? const Icon(Icons.person) : null,
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(comment),
          ),
          if (imageUrl.isNotEmpty)
            SizedBox(
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  },
                ),
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
