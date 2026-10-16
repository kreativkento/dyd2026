import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

abstract final class HostParishCardAssets {
  static const image = 'assets/images/host_parish.png';
}

class HostParishCard extends StatefulWidget {
  /// Matches scaled hero height on the Event tab (shared with logo banner).
  static const kCardHeight = 130.0 * 0.85;

  const HostParishCard({
    super.key,
    required this.parishName,
    required this.onTap,
    this.imageAsset = HostParishCardAssets.image,
  });

  final String parishName;
  final VoidCallback onTap;
  final String imageAsset;

  @override
  State<HostParishCard> createState() => _HostParishCardState();
}

class _HostParishCardState extends State<HostParishCard> {
  bool _hovering = false;

  static const _heightScale = 0.85;
  static const _height = HostParishCard.kCardHeight;
  static const _radius = 16.0;
  static const _imageHeight = 118.0 * _heightScale;
  static const _imageScale = 1.092;

  String get _titleText {
    const marker = 'Heart';
    final name = widget.parishName.trim();
    final index = name.indexOf(marker);
    if (index == -1) return name;
    final splitAt = index + marker.length;
    final first = name.substring(0, splitAt).trim();
    final second = name.substring(splitAt).trim();
    if (second.isEmpty) return first;
    return '$first\n$second';
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Card(
        clipBehavior: Clip.none,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
        ),
        child: SizedBox(
          width: double.infinity,
          height: _height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(_radius),
                    child: Material(
                      color: const Color(0xFF521418),
                      child: InkWell(
                        onTap: widget.onTap,
                        hoverColor: AppColors.blue.withValues(alpha: 0.12),
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Color(0xFF521418),
                                Color(0xFFAE3037),
                              ],
                            ),
                          ),
                          width: constraints.maxWidth,
                          height: _height,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        16,
                                        34 * _heightScale,
                                        8,
                                        8 * _heightScale,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Host Parish',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge
                                                ?.copyWith(
                                                  color: _hovering
                                                      ? Colors.white
                                                      : AppColors.yellow,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.35,
                                                  fontSize: 11,
                                                  height: 1.1,
                                                ),
                                          ),
                                          SizedBox(height: 9 * _heightScale),
                                          Text(
                                            _titleText,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w800,
                                              height: 1.12,
                                              fontSize: 13.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                      flex: 5, child: SizedBox.shrink()),
                                ],
                              ),
                              Positioned(
                                top: 14 * _heightScale,
                                right: 16,
                                child: Text(
                                  'See info >',
                                  style: TextStyle(
                                    color: _hovering
                                        ? Colors.white
                                        : AppColors.yellow
                                            .withValues(alpha: 0.88),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10.5,
                                    height: 1.1,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: constraints.maxWidth * 0.5,
                    right: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Transform.scale(
                          scale: _imageScale,
                          alignment: Alignment.bottomRight,
                          child: Image.asset(
                            widget.imageAsset,
                            fit: BoxFit.contain,
                            alignment: Alignment.bottomRight,
                            height: _imageHeight,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (_, __, ___) =>
                                const SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
