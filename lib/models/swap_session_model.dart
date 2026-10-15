// =========================================================================
// 📄 FILE: swap_session_model.dart
// ROLE: Transaction Lifecycle & State Management Model for Bedal Swap Sessions
// =========================================================================

enum SwapStatus { initial, chatting, review }

class SwapSession {
  final String sessionId;
  final String peerName;
  final String peerAvatarUrl;
  final String targetSkill;
  final double durationHours;
  final SwapStatus activeStatus;

  const SwapSession({
    required this.sessionId,
    required this.peerName,
    required this.peerAvatarUrl,
    required this.targetSkill,
    this.durationHours = 1.0,
    this.activeStatus = SwapStatus.initial,
  });

  SwapSession copyWith({
    String? sessionId,
    String? peerName,
    String? peerAvatarUrl,
    String? targetSkill,
    double? durationHours,
    SwapStatus? activeStatus,
  }) {
    return SwapSession(
      sessionId: sessionId ?? this.sessionId,
      peerName: peerName ?? this.peerName,
      peerAvatarUrl: peerAvatarUrl ?? this.peerAvatarUrl,
      targetSkill: targetSkill ?? this.targetSkill,
      durationHours: durationHours ?? this.durationHours,
      activeStatus: activeStatus ?? this.activeStatus,
    );
  }
}
