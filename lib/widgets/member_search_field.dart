import 'package:flutter/material.dart';

import '../core/services/content_service.dart';
import '../core/theme/app_theme.dart';
import '../models/content_models.dart';
import 'member_avatar.dart';
import 'member_namecard_dialog.dart';

/// Full-name search against [members.json]; suggestions overlay the tab content.
class MemberSearchField extends StatefulWidget {
  const MemberSearchField({super.key});

  static const _maxSuggestions = 80;

  @override
  State<MemberSearchField> createState() => _MemberSearchFieldState();
}

class _MemberSearchFieldState extends State<MemberSearchField>
    with WidgetsBindingObserver {
  static const _mainNavBarHeight = 64.0;
  static const _dropdownGap = 6.0;

  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  final _fieldKey = GlobalKey();

  MembersRoster? _roster;
  List<RosterMember> _suggestions = [];
  bool _rosterLoading = true;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onQueryChanged);
    _focusNode.addListener(_scheduleOverlayUpdate);
    WidgetsBinding.instance.addObserver(this);
    _loadRoster();
  }

  @override
  void didChangeMetrics() {
    _scheduleOverlayUpdate();
  }

  Future<void> _loadRoster() async {
    final roster = await ContentService.instance.membersRoster;
    if (!mounted) return;
    setState(() {
      _roster = roster;
      _rosterLoading = false;
    });
    _onQueryChanged();
  }

  void _onQueryChanged() {
    final query = _controller.text.trim().toLowerCase();
    if (query.isEmpty || _roster == null) {
      setState(() => _suggestions = []);
      _removeOverlay();
      return;
    }

    final matches = <RosterMember>[];
    for (final member in _roster!.members) {
      if (member.fullName.toLowerCase().contains(query)) {
        matches.add(member);
        if (matches.length >= MemberSearchField._maxSuggestions) break;
      }
    }
    setState(() => _suggestions = matches);
    _scheduleOverlayUpdate();
  }

  bool get _shouldShowSuggestions {
    return _focusNode.hasFocus &&
        _controller.text.trim().isNotEmpty &&
        !_rosterLoading;
  }

  void _scheduleOverlayUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_shouldShowSuggestions) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  void _showOverlay() {
    _overlayEntry ??= OverlayEntry(builder: _buildOverlay);
    _overlayEntry!.markNeedsBuild();
    if (_overlayEntry!.mounted) return;
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  double _maxDropdownHeight(BuildContext overlayContext) {
    final media = MediaQuery.of(overlayContext);
    final fieldBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (fieldBox == null || !fieldBox.hasSize) {
      return media.size.height * 0.35;
    }
    final fieldBottom =
        fieldBox.localToGlobal(Offset.zero).dy + fieldBox.size.height;
    final reservedBottom = media.padding.bottom +
        media.viewInsets.bottom +
        _mainNavBarHeight +
        12;
    final available =
        media.size.height - fieldBottom - _dropdownGap - reservedBottom;
    return available.clamp(120.0, media.size.height * 0.55);
  }

  Widget _buildOverlay(BuildContext overlayContext) {
    if (!_shouldShowSuggestions) return const SizedBox.shrink();

    final fieldBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final fieldWidth = fieldBox?.size.width ??
        MediaQuery.sizeOf(overlayContext).width - 32;
    final maxHeight = _maxDropdownHeight(overlayContext);

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _focusNode.unfocus();
              _removeOverlay();
            },
          ),
        ),
        CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, _dropdownGap),
          child: Material(
            elevation: 8,
            shadowColor: AppColors.primary.withValues(alpha: 0.18),
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: fieldWidth,
              child: _SuggestionsPanel(
                suggestions: _suggestions,
                maxHeight: maxHeight,
                onTap: _onSuggestionTap,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _clear() {
    _controller.clear();
    _focusNode.unfocus();
    _removeOverlay();
  }

  void _onSuggestionTap(RosterMember member) {
    _removeOverlay();
    _focusNode.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _removeOverlay();
      showMemberNamecardModal(context, member: member);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _removeOverlay();
    _controller.removeListener(_onQueryChanged);
    _focusNode.removeListener(_scheduleOverlayUpdate);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim();

    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        key: _fieldKey,
        controller: _controller,
        focusNode: _focusNode,
        textInputAction: TextInputAction.search,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              height: 1.25,
            ),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search member by full name',
          hintStyle: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary.withValues(alpha: 0.85),
          ),
          prefixIcon: const Icon(Icons.search, size: 20),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 38,
            minHeight: 32,
          ),
          suffixIcon: query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 32,
                  ),
                  onPressed: _clear,
                  tooltip: 'Clear',
                ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.12),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.12),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.45),
              width: 1.25,
            ),
          ),
        ),
      ),
    );
  }
}

class _SuggestionsPanel extends StatelessWidget {
  const _SuggestionsPanel({
    required this.suggestions,
    required this.maxHeight,
    required this.onTap,
  });

  final List<RosterMember> suggestions;
  final double maxHeight;
  final void Function(RosterMember member) onTap;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Text(
          'No members match that name',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12.5,
              ),
        ),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          thickness: 1,
          color: AppColors.primary.withValues(alpha: 0.06),
        ),
        itemBuilder: (context, index) {
          final member = suggestions[index];
          return InkWell(
            onTap: () => onTap(member),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                children: [
                  MemberAvatar(avatarAsset: member.avatarAsset, size: 36),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    height: 1.2,
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.home_outlined,
                              size: 13,
                              color: AppColors.textSecondary
                                  .withValues(alpha: 0.85),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                member.parishMunicipality,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 11,
                                      height: 1.2,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
