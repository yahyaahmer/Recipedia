import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  final double rating;
  final String cookTime;
  final String difficulty;
  final Function onTap;
  final bool isCompact;

  RecipeCard({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.rating,
    required this.cookTime,
    required this.difficulty,
    required this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                imageUrl,
                height: isCompact ? 120 : 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isCompact ? 8.0 : 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isCompact ? 14 : 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isCompact ? 2 : 4),
                  Text(
                    'by $author',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: isCompact ? 12 : 14,
                    ),
                  ),
                  SizedBox(height: isCompact ? 4 : 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: isCompact ? 16 : 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontSize: isCompact ? 12 : 14,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.access_time,
                        color: Colors.grey,
                        size: isCompact ? 16 : 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        cookTime,
                        style: TextStyle(
                          fontSize: isCompact ? 12 : 14,
                        ),
                      ),
                    ],
                  ),
                  if (!isCompact) 
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: difficulty == 'Easy' 
                              ? Colors.green.shade100 
                              : difficulty == 'Medium' 
                                  ? Colors.orange.shade100 
                                  : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          difficulty,
                          style: TextStyle(
                            color: difficulty == 'Easy' 
                                ? Colors.green.shade800 
                                : difficulty == 'Medium' 
                                    ? Colors.orange.shade800 
                                    : Colors.red.shade800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
