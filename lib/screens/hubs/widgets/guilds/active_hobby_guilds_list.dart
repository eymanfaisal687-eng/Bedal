import 'package:flutter/material.dart';
import '../../models/hub_data.dart';
import 'hobby_guild_card.dart';

class ActiveHobbyGuildsList extends StatelessWidget {
  const ActiveHobbyGuildsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text(
                    '👥 Active Hobby Guilds',
                    style: TextStyle(
                      color: Color(0xFF1A1B1E),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'See all',
                    style: TextStyle(
                      color: Color(0xFF777269),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFFC89B3C),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: HubData.mockHobbyGuilds.length,
          itemBuilder: (context, index) {
            return HobbyGuildCard(guild: HubData.mockHobbyGuilds[index]);
          },
        ),
      ],
    );
  }
}
