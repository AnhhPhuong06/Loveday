import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/period_service.dart';

class PeriodTrackerScreen extends StatefulWidget {
  final PeriodService periodService;
  final String userId;

  const PeriodTrackerScreen({
    super.key,
    required this.periodService,
    required this.userId,
  });

  @override
  State<PeriodTrackerScreen> createState() => _PeriodTrackerScreenState();
}

class _PeriodTrackerScreenState extends State<PeriodTrackerScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    widget.periodService.loadPeriodData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final log = widget.periodService.currentLog;
    final advice = widget.periodService.partnerAdvice;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theo Dõi Chu Kỳ 🩸', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sweet Advice Box for Partner / Girl
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFEEF2), Color(0xFFFFF5F7)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.periodFlow.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gợi Ý Chăm Sóc & Đồng Bộ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.periodFlow,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          advice,
                          style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Cycle Summary Card
            if (log != null)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: AppColors.periodGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.periodFlow.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _CycleStat(
                      title: 'Kỳ tới dự kiến',
                      value: DateFormat('dd/MM').format(log.nextPeriodDate),
                      subtitle: 'Còn ${log.daysUntilNextPeriod} ngày',
                    ),
                    Container(height: 40, width: 1, color: Colors.white30),
                    _CycleStat(
                      title: 'Rụng trứng',
                      value: DateFormat('dd/MM').format(log.ovulationDate),
                      subtitle: 'Dễ thụ thai',
                    ),
                    Container(height: 40, width: 1, color: Colors.white30),
                    _CycleStat(
                      title: 'Chu kỳ',
                      value: '${log.cycleLength} ngày',
                      subtitle: 'Độ dài kỳ kinh',
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Interactive Calendar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.periodFlow,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Quick Log Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.periodFlow,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.water_drop_rounded),
                label: const Text(
                  'Ghi Nhận Kỳ Kinh Mới',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                onPressed: () => _showLogDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cập nhật ngày bắt đầu kỳ kinh',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.today, color: AppColors.periodFlow),
                title: const Text('Bắt đầu từ hôm nay'),
                onTap: () {
                  widget.periodService.logNewPeriod(
                    userId: widget.userId,
                    startDate: DateTime.now(),
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month, color: AppColors.periodFlow),
                title: const Text('Chọn ngày khác trong lịch'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CycleStat extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const _CycleStat({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }
}
