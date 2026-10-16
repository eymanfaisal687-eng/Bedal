// =========================================================================
// FILE: swap_session_model.dart
// ROLE: Transaction Lifecycle & State Management Model for Skill Swap Sessions
// =========================================================================

/// Status enumeration for skill swap session lifecycle stages.
enum SwapStatus { initial, chatting, review }

/// Model managing state for an active skill swap transaction.
class SwapSession {
  final String sessionId; // Unique session ID
  final String peerName; // Peer display name
  final String peerAvatarUrl; // Peer avatar asset or URL
  final String targetSkill; // Target skill being swapped
  final double durationHours; // Duration in Bedal Hours
  final SwapStatus activeStatus; // Active lifecycle stage

  const SwapSession({
    required this.sessionId,
    required this.peerName,
    required this.peerAvatarUrl,
    required this.targetSkill,
    this.durationHours = 1.0,
    this.activeStatus = SwapStatus.initial,
  });

  /// Creates a copy of [SwapSession] with modified properties.
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
