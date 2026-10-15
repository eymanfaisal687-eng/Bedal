import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/schedule_provider.dart';
import '../../models/schedule_models.dart';

// =========================================================================
// 📄 FILE: my_schedule_screen.dart
// PURPOSE: Dedicated calendar grid widget styled with Bedal's app theme
//          (warm cream, crisp white cards, dark charcoal text, and Bedal Gold).
// =========================================================================

class MyScheduleScreen extends StatefulWidget {
  const MyScheduleScreen({super.key});

  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen> {
  static const Color gold = Color(0xFFC5A059);
  static const Color charcoal = Color(0xFF16171A);
  static const Color cream = Color(0xFFF8F5EF);
  static const Color mutedText = Color(0xFF7A7368);

  DateTime _selectedDate = DateTime.now();
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;

  void _showAddSlotDialog(BuildContext context) {
    final startTimeController = TextEditingController(text: '10:00 AM');
    final endTimeController = TextEditingController(text: '12:00 PM');
    bool isAvailable = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Slot for ${_formattedDate(_selectedDate)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: charcoal,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: startTimeController,
                    style: const TextStyle(color: charcoal),
                    decoration: const InputDecoration(
                      labelText: 'Start Time (e.g. 10:00 AM)',
                      labelStyle: TextStyle(color: mutedText),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: endTimeController,
                    style: const TextStyle(color: charcoal),
                    decoration: const InputDecoration(
                      labelText: 'End Time (e.g. 12:00 PM)',
                      labelStyle: TextStyle(color: mutedText),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Status:',
                        style: TextStyle(fontWeight: FontWeight.w700, color: charcoal),
                      ),
                      Switch(
                        value: isAvailable,
                        activeThumbColor: gold,
                        onChanged: (val) => setModalState(() => isAvailable = val),
                      ),
                      Text(
                        isAvailable ? 'Available' : 'Busy / Unavailable',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isAvailable ? Colors.green.shade700 : Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: gold,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        final newSlot = AvailabilitySlotModel(
                          id: 'slot_${DateTime.now().millisecondsSinceEpoch}',
                          userId: 'current_user',
                          date: _selectedDate,
                          startTime: startTimeController.text,
                          endTime: endTimeController.text,
                          isAvailable: isAvailable,
                        );
                        context.read<ScheduleProvider>().addSlot(newSlot);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('📅 Availability slot added successfully!')),
                        );
                      },
                      child: const Text('Save Availability Slot', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formattedDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _getMonthName(int month) {
    const months = ['JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER'];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = context.watch<ScheduleProvider>();
    final allUserSlots = scheduleProvider.getSlotsForUser('current_user');
    
    // Filter slots for the selected date
    final selectedDateSlots = allUserSlots.where((s) => 
      s.date.year == _selectedDate.year &&
      s.date.month == _selectedDate.month &&
      s.date.day == _selectedDate.day
    ).toList();

    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: charcoal, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Schedule & Calendar',
          style: TextStyle(
            color: charcoal,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: gold, size: 26),
            onPressed: () => _showAddSlotDialog(context),
            tooltip: 'Add Slot',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================================================
            // MONTHLY CALENDAR GRID WIDGET (App Theme Matching)
            // =========================================================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white, // Crisp white card matching profile theme
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE5E0D5)),
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
                  // Month Header and Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getMonthName(_currentMonth),
                        style: const TextStyle(
                          color: gold,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left_rounded, color: charcoal, size: 22),
                            onPressed: () {
                              setState(() {
                                if (_currentMonth > 1) {
                                  _currentMonth--;
                                } else {
                                  _currentMonth = 12;
                                  _currentYear--;
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right_rounded, color: charcoal, size: 22),
                            onPressed: () {
                              setState(() {
                                if (_currentMonth < 12) {
                                  _currentMonth++;
                                } else {
                                  _currentMonth = 1;
                                  _currentYear++;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Weekday Header (S M T W T F S)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('S', style: TextStyle(color: Color(0xFFE74C3C), fontWeight: FontWeight.bold)),
                      Text('M', style: TextStyle(color: mutedText, fontWeight: FontWeight.bold)),
                      Text('T', style: TextStyle(color: mutedText, fontWeight: FontWeight.bold)),
                      Text('W', style: TextStyle(color: mutedText, fontWeight: FontWeight.bold)),
                      Text('T', style: TextStyle(color: mutedText, fontWeight: FontWeight.bold)),
                      Text('F', style: TextStyle(color: Color(0xFF3498DB), fontWeight: FontWeight.bold)),
                      Text('S', style: TextStyle(color: Color(0xFFE74C3C), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Calendar Days Grid
                  _buildCalendarGrid(),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // =========================================================
            // PUBLISHED SLOTS FOR SELECTED DATE
            // =========================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Published Slots for ${_formattedDate(_selectedDate)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: charcoal,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showAddSlotDialog(context),
                  icon: const Icon(Icons.add, size: 16, color: gold),
                  label: const Text('Add Slot', style: TextStyle(color: gold, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),

            selectedDateSlots.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    child: Text(
                      'No availability slots added for ${_formattedDate(_selectedDate)}.\nTap "Add Slot" to schedule.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: mutedText),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: selectedDateSlots.length,
                    itemBuilder: (context, index) {
                      final slot = selectedDateSlots[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E0D5)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: (slot.isAvailable ? Colors.green : Colors.red).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                slot.isAvailable ? Icons.check_circle_outline_rounded : Icons.block_rounded,
                                color: slot.isAvailable ? Colors.green.shade700 : Colors.red.shade700,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _formattedDate(slot.date),
                                    style: const TextStyle(
                                      color: mutedText,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Plus Jakarta Sans',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
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
                                  Text(
                                    slot.isAvailable ? 'Available for Bookings' : 'Marked Busy / Unavailable',
                                    style: TextStyle(
                                      color: slot.isAvailable ? Colors.green.shade700 : mutedText,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.grey, size: 20),
                              onPressed: () {
                                context.read<ScheduleProvider>().deleteSlot(slot.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Slot removed.')),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_currentYear, _currentMonth, 1);
    final daysInMonth = DateTime(_currentYear, _currentMonth + 1, 0).day;
    final startingWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    List<Widget> dayWidgets = [];

    // Empty spaces before first day of month
    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(const SizedBox());
    }

    // Days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentYear, _currentMonth, day);
      final isSelected = date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day;
      final isToday = date.year == DateTime.now().year &&
          date.month == DateTime.now().month &&
          date.day == DateTime.now().day;

      dayWidgets.add(
        GestureDetector(
          onTap: () => setState(() => _selectedDate = date),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? gold : Colors.transparent,
              shape: BoxShape.circle,
              border: isToday && !isSelected ? Border.all(color: gold, width: 1.5) : null,
            ),
            child: Text(
              '$day',
              style: TextStyle(
                color: isSelected ? Colors.white : (isToday ? gold : charcoal),
                fontSize: 14,
                fontWeight: isSelected || isToday ? FontWeight.w900 : FontWeight.w600,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: dayWidgets,
    );
  }
}
