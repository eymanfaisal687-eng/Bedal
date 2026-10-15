import 'package:flutter/material.dart';
import '../../models/hub_models.dart';

class CafeCard extends StatefulWidget {
  final Venue venue;
  final bool isSelected;
  final VoidCallback onTap;

  const CafeCard({
    super.key,
    required this.venue,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<CafeCard> createState() => _CafeCardState();
}

class _CafeCardState extends State<CafeCard> {
  static const Color primaryGold = Color(0xFFC5A059);
  static const Color charcoal = Color(0xFF16171A);
  static const Color mutedText = Color(0xFF7A7368);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE3E0D6);

  String _selectedDate = 'Today, Nov 20';
  String _selectedTime = '4:00 PM';

  final List<String> _availableDates = [
    'Today, Nov 20',
    'Tomorrow, Nov 21',
    'Sat, Nov 22',
    'Sun, Nov 23',
  ];

  final List<String> _availableTimes = [
    '2:00 PM',
    '4:00 PM',
    '6:00 PM',
    '8:00 PM',
  ];

  void _showSeatReservationSheet(BuildContext context) {
    final int totalSeats = 10;
    final int bookedSeats = widget.venue.id == 'v1' ? 7 : (widget.venue.id == 'v2' ? 10 : 3);
    final int availableSeats = totalSeats - bookedSeats;
    final bool isAllBooked = availableSeats <= 0;

    // Café specialties based on venue
    final List<String> specialties = [
      '☕ Free High-Speed Wi-Fi & Power Outlets',
      '🏷️ 20% discount on specialty drip coffee',
      '🛋️ Reserved quiet mentor corner & study pods',
      '🍪 Complimentary artisanal cookies for Bedal members',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF1EEE7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 28),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: charcoal.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.venue.name,
                                style: const TextStyle(
                                  color: charcoal,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Plus Jakarta Sans',
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${widget.venue.neighborhood} • 5 SAR / Seat',
                                style: const TextStyle(
                                  color: primaryGold,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Plus Jakarta Sans',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isAllBooked ? Colors.red.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isAllBooked ? 'All Booked' : '$availableSeats seats available',
                            style: TextStyle(
                              color: isAllBooked ? Colors.red.shade700 : const Color(0xFF27AE60),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Specialties Section
                    const Text(
                      'CAFÉ SPECIALTIES & PERKS',
                      style: TextStyle(
                        color: mutedText,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: specialties.map((spec) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            spec,
                            style: const TextStyle(
                              color: charcoal,
                              fontSize: 12.5,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Calendar Date Selector
                    const Text(
                      'SELECT DATE',
                      style: TextStyle(
                        color: mutedText,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _availableDates.length,
                        itemBuilder: (context, index) {
                          final date = _availableDates[index];
                          final isSelected = _selectedDate == date;
                          return GestureDetector(
                            onTap: () => setModalState(() => _selectedDate = date),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? primaryGold : cardBg,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: isSelected ? primaryGold : borderColor),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                date,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : charcoal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Plus Jakarta Sans',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Timing Slots Selector
                    const Text(
                      'SELECT TIMING SLOT',
                      style: TextStyle(
                        color: mutedText,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableTimes.map((time) {
                        final isSelected = _selectedTime == time;
                        return ChoiceChip(
                          label: Text(time),
                          selected: isSelected,
                          selectedColor: primaryGold,
                          backgroundColor: cardBg,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : charcoal,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: isSelected ? primaryGold : borderColor),
                          ),
                          onSelected: (sel) => setModalState(() => _selectedTime = time),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Book Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isAllBooked ? Colors.grey : primaryGold,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: isAllBooked
                            ? null
                            : () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: charcoal,
                                    content: Text(
                                      '🎉 Seat booked at ${widget.venue.name} for $_selectedDate at $_selectedTime (5 SAR)!',
                                      style: const TextStyle(color: primaryGold, fontFamily: 'Plus Jakarta Sans'),
                                    ),
                                  ),
                                );
                              },
                        child: Text(
                          isAllBooked ? 'SOLD OUT (ALL BOOKED)' : 'Book a café seat - 5 SAR',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 170,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          border: widget.isSelected
              ? Border.all(color: primaryGold, width: 2)
              : Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
                  child: Image.network(
                    widget.venue.image,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: charcoal.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '5 SAR',
                      style: TextStyle(
                        color: primaryGold,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.venue.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: charcoal,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.venue.neighborhood,
                    style: const TextStyle(
                      color: mutedText,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showSeatReservationSheet(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGold,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.coffee_rounded, size: 12),
                          SizedBox(width: 4),
                          Text(
                            'Book a café seat - 5 SAR',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ],
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
