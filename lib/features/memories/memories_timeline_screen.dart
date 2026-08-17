import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../models/memory_model.dart';

class MemoriesTimelineScreen extends StatefulWidget {
  final String coupleId;

  const MemoriesTimelineScreen({super.key, required this.coupleId});

  @override
  State<MemoriesTimelineScreen> createState() => _MemoriesTimelineScreenState();
}

class _MemoriesTimelineScreenState extends State<MemoriesTimelineScreen> {
  final List<MemoryModel> _memories = [
    MemoryModel(
      id: 'mem_1',
      coupleId: 'couple_1',
      title: 'Lần đầu tiên gặp nhau tại Đà Lạt 🌲☕',
      description: 'Ngày hôm đó trời se lạnh, hai đứa ngồi uống cà phê trứng và nói chuyện suốt 4 tiếng đồng hồ.',
      photoUrls: ['https://images.unsplash.com/photo-1518199266791-5375a83190b7?w=800'],
      eventDate: DateTime.now().subtract(const Duration(days: 120)),
      category: 'first_date',
      createdAt: DateTime.now(),
    ),
    MemoryModel(
      id: 'mem_2',
      coupleId: 'couple_1',
      title: 'Chuyến du lịch biển Phú Quốc 🌊🌴',
      description: 'Cùng nhau đón hoàng hôn đẹp nhất cuộc đời tại bãi biển Sunset Sanato.',
      photoUrls: ['https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800'],
      eventDate: DateTime.now().subtract(const Duration(days: 60)),
      category: 'travel',
      createdAt: DateTime.now(),
    ),
    MemoryModel(
      id: 'mem_3',
      coupleId: 'couple_1',
      title: 'Kỷ niệm tròn 100 ngày yêu nhau 🎉💍',
      description: 'Một bữa tối lãng mạn dưới ánh nến và bó hoa hồng anh tặng em.',
      photoUrls: ['https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?w=800'],
      eventDate: DateTime.now().subtract(const Duration(days: 28)),
      category: 'anniversary',
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dòng Thời Gian Kỷ Niệm 📖', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_photo_alternate_rounded, color: AppColors.primary),
            onPressed: _showAddMemoryDialog,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _memories.length,
        itemBuilder: (context, index) {
          final item = _memories[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.photoUrls.isNotEmpty)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Image.network(
                      item.photoUrls.first,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(item.eventDate),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Icon(Icons.favorite, color: AppColors.primaryLight, size: 20),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (item.description != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          item.description!,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.4),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddMemoryDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng thêm khoảnh khắc mới đã sẵn sàng!')),
    );
  }
}
