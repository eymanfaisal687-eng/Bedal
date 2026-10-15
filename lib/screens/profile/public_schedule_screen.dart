import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/schedule_provider.dart';
import '../../models/schedule_models.dart';

// =========================================================================
// 📄 FILE: public_schedule_screen.dart
// PURPOSE: Public visitor booking screen showing only shareable availability slots (Privacy enforced)
// =========================================================================

class PublicScheduleScreen extends StatefulWidget {
  final String hostUserId;
  final String hostUserName;

  const PublicScheduleScreen({
    super.key,
    required this.hostUserId,
    required this.hostUserName,
  });

  @override
  State<PublicScheduleScreen> createState() => _PublicScheduleScreenState();
}

class _PublicScheduleScreenState extends State<PublicScheduleScreen> {
  static const Color gold = Color(0xFFC5A059);
  static const Color charcoal = Color(0xFF16171A);
  static const Color cream = Color(0xFFF8F5EF);

  AvailabilitySlotModel? _selectedSlot;
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _purposeController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitRequest(BuildContext context, AvailabilitySlotModel slot) {
    if (_purposeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a purpose or skill for this meetup request.')),
      );
      return;
    }

    final request = MeetupRequestModel(
      id: 'req_${DateTime.now().millisecondsSinceEpoch}',
      senderUid: 'current_user',
      senderName: 'You',
      senderAvatar: 'assets/images/character_images/reem.png',
      receiverUid: widget.hostUserId,
      slotId: slot.id,
      date: slot.date,
      timeSlot: '${slot.startTime} – ${slot.endTime}',
      purpose: _purposeController.text.trim(),
      message: _messageController.text.trim(),
      timestamp: DateTime.now(),
    );

    context.read<ScheduleProvider>().sendMeetupRequest(request);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: charcoal,
        content: Text(
          '✨ Meetup request sent to ${widget.hostUserName}!',
          style: const TextStyle(color: gold, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = context.watch<ScheduleProvider>();
    final hostSlots = scheduleProvider.getPublicSlotsForUser(widget.hostUserId);
    final availableSlots = hostSlots.where((s) => s.isAvailable).toList();

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: charcoal, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Schedule Meetup with ${widget.hostUserName}',
          style: const TextStyle(
            color: charcoal,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: gold.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: gold.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_outline_rounded, color: gold, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '🔒 Privacy Enforced: Only explicitly shareable availability is shown. Private personal appointments and details are hidden.',
                      style: TextStyle(
                        color: charcoal,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select an Available Time Slot',
              style: TextStyle(
                color: charcoal,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
            const SizedBox(height: 12),
            availableSlots.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    child: Text(
                      '${widget.hostUserName} has no available slots published right now.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF7A7368)),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: availableSlots.length,
                    itemBuilder: (context, index) {
                      final slot = availableSlots[index];
                      final isSelected = _selectedSlot?.id == slot.id;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSlot = slot),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected ? gold.withValues(alpha: 0.15) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? gold : const Color(0xFFE5E0D5),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                                    color: isSelected ? gold : const Color(0xFF7A7368),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${slot.startTime} – ${slot.endTime}',
                                        style: const TextStyle(
                                          color: charcoal,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          fontFamily: 'Plus Jakarta Sans',
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Available for 1-on-1 Meetup',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: gold.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Select',
                                  style: TextStyle(color: charcoal, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            if (_selectedSlot != null) ...[
              const SizedBox(height: 24),
              const Text(
                'Meetup Purpose & Skill Swap',
                style: TextStyle(
                  color: charcoal,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _purposeController,
                style: const TextStyle(color: charcoal),
                decoration: const InputDecoration(
                  labelText: 'Skill or Purpose (e.g. Flutter UI / Coffee & Code)',
                  labelStyle: TextStyle(color: Color(0xFF7A7368)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _messageController,
                style: const TextStyle(color: charcoal),
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Optional Message / Location Note',
                  labelStyle: TextStyle(color: Color(0xFF7A7368)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => _submitRequest(context, _selectedSlot!),
                  child: const Text(
                    '✨ Submit Meetup Request',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, fontFamily: 'Plus Jakarta Sans'),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
