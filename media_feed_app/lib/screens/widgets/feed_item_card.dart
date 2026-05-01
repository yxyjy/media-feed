import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/moment.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedItemCard extends StatelessWidget {
  final Moment moment;
  const FeedItemCard({super.key, required this.moment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          _buildTextContent(context),
          _buildSeeMore(context),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = moment.firstImage?.url;

    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey.shade100,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey.shade300,
          size: 40,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: 200,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        height: 200,
        color: Colors.grey.shade100,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.deepPurple.shade200,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: 200,
        color: Colors.grey.shade100,
        child: Icon(
          Icons.broken_image_outlined,
          size: 40,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (moment.title.isNotEmpty)
            Text(
              moment.title,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: const Color.fromARGB(255, 66, 57, 95),
                  letterSpacing: .5,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          if (moment.subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              moment.subtitle,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSeeMore(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Center(
        child: Text(
          'see more',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
