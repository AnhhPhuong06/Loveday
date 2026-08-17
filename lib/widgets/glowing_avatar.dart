import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GlowingAvatarFrame extends StatefulWidget {
  final String name;
  final String avatarAsset;
  final String? customImagePath;
  final String fallbackUrl;
  final String role; // 'boy' or 'girl'
  final Color frameColor;
  final Function(String name, String? newImagePath, Color newColor) onUpdate;

  const GlowingAvatarFrame({
    super.key,
    required this.name,
    required this.avatarAsset,
    this.customImagePath,
    required this.fallbackUrl,
    required this.role,
    this.frameColor = const Color(0xFFFF4B72),
    required this.onUpdate,
  });

  @override
  State<GlowingAvatarFrame> createState() => _GlowingAvatarFrameState();
}

class _GlowingAvatarFrameState extends State<GlowingAvatarFrame>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 4.0, end: 12.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showEditAvatarModal(BuildContext context) {
    final nameController = TextEditingController(text: widget.name);
    Color selectedColor = widget.frameColor;
    String? currentCustomPath = widget.customImagePath;

    final List<Color> frameColors = [
      const Color(0xFFFF4B72), // Romantic Pink
      const Color(0xFFFFB800), // Royal Gold
      const Color(0xFF00E5FF), // Cyber Cyan
      const Color(0xFF9D00FF), // Galaxy Violet
      const Color(0xFF00E676), // Emerald Mint
      const Color(0xFFFF5252), // Passion Crimson
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (modalCtx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 24,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E2E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tùy chỉnh Avatar ${widget.role == "boy" ? "Anh Yêu 👦" : "Em Yêu 👧"}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.pop(modalCtx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Avatar Preview with Glowing Frame
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: selectedColor.withOpacity(0.6),
                            blurRadius: 16,
                            spreadRadius: 4,
                          ),
                        ],
                        border: Border.all(color: selectedColor, width: 3.5),
                      ),
                      child: ClipOval(
                        child: currentCustomPath != null && File(currentCustomPath!).existsSync()
                            ? Image.file(File(currentCustomPath!), fit: BoxFit.cover)
                            : Image.asset(widget.avatarAsset, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Choose Image Buttons (Camera / Gallery)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white24),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.photo_library, size: 18, color: Colors.pinkAccent),
                          label: const Text('Thư viện'),
                          onPressed: () async {
                            final picker = ImagePicker();
                            final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                            if (picked != null) {
                              setModalState(() {
                                currentCustomPath = picked.path;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white24),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.camera_alt, size: 18, color: Colors.cyanAccent),
                          label: const Text('Chụp ảnh'),
                          onPressed: () async {
                            final picker = ImagePicker();
                            final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 85);
                            if (picked != null) {
                              setModalState(() {
                                currentCustomPath = picked.path;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Frame Border Color Picker
                  const Text(
                    'Chọn màu khung viền phát sáng',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: frameColors.map((color) {
                      final isCurrent = color == selectedColor;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            border: isCurrent ? Border.all(color: Colors.white, width: 3.5) : null,
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.5),
                                blurRadius: isCurrent ? 12 : 4,
                                spreadRadius: isCurrent ? 2 : 0,
                              ),
                            ],
                          ),
                          child: isCurrent
                              ? const Icon(Icons.check, color: Colors.white, size: 22)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Nickname text field
                  const Text(
                    'Biệt danh hiển thị',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Nhập biệt danh...',
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.favorite, color: Colors.pinkAccent, size: 20),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4B72),
                        elevation: 6,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        widget.onUpdate(
                          nameController.text.trim().isEmpty ? widget.name : nameController.text.trim(),
                          currentCustomPath,
                          selectedColor,
                        );
                        Navigator.pop(modalCtx);
                      },
                      child: const Text(
                        'Lưu Thay Đổi',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEditAvatarModal(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: widget.frameColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: widget.frameColor.withOpacity(0.55),
                      blurRadius: _glowAnimation.value,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipOval(
                      child: widget.customImagePath != null && File(widget.customImagePath!).existsSync()
                          ? Image.file(
                              File(widget.customImagePath!),
                              width: 78,
                              height: 78,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              widget.avatarAsset,
                              width: 78,
                              height: 78,
                              fit: BoxFit.cover,
                            ),
                    ),
                    // Small edit badge
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.frameColor,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: const Icon(Icons.edit, size: 10, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.frameColor.withOpacity(0.3), width: 1),
            ),
            child: Text(
              widget.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                shadows: [
                  Shadow(color: Colors.black87, blurRadius: 4),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
