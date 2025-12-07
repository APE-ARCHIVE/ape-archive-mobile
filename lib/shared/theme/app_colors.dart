import 'package:flutter/material.dart';

/// Modern Professional Color Palette - Dark Squared Grid Theme
/// Orange accent with dark background and grid lines
class AppColors {
  AppColors._();

  // Primary Colors - Vibrant Orange
  static const Color primary = Color(0xFFFF3B30); // Vibrant Orange-Red
  static const Color primaryLight = Color(0xFFFF6259); // Light Orange
  static const Color primaryDark = Color(0xFFE6261A); // Dark Orange
  static const Color primaryContainer = Color(0xFF2A1A19); // Dark orange tint

  // Secondary Colors - Slate Blue (Supporting accent)
  static const Color secondary = Color(0xFF64748B); // Slate-500
  static const Color secondaryLight = Color(0xFF94A3B8); // Slate-400
  static const Color secondaryDark = Color(0xFF475569); // Slate-600
  static const Color secondaryContainer = Color(0xFFF1F5F9); // Slate-100

  // Light Theme - Minimal for contrast
  static const Color background = Color(0xFFF5F5F5); // Light grey
  static const Color surface = Color(0xFFFFFFFF); // White cards
  static const Color surfaceVariant = Color(0xFFFAFAFA); // Off-white
  static const Color surfaceTint = Color(0xFFFFF5F5); // Light orange tint
  
  // Dark Theme - Squared Grid Background
  static const Color backgroundDark = Color(0xFF121212); // Near black
  static const Color surfaceDark = Color(0xFF1E1E1E); // Dark grey cards
  static const Color surfaceVariantDark = Color(0xFF2A2A2A); // Medium dark
  static const Color surfaceTintDark = Color(0xFF2A1A19); // Dark orange tint

  // Grid Lines (Squared notebook pattern)
  static const Color gridLight = Color(0xFFE0E0E0); // Light grid
  static const Color gridDark = Color(0xFF333333); // Dark grid lines

  // Text Colors - Light Theme (Ink on paper)
  static const Color textPrimary = Color(0xFF0F172A); // Slate-900 (Deep ink)
  static const Color textSecondary = Color(0xFF475569); // Slate-600
  static const Color textTertiary = Color(0xFF94A3B8); // Slate-400
  static const Color textDisabled = Color(0xFFCBD5E1); // Slate-300

  // Text Colors - Dark Theme
  static const Color textPrimaryDark = Color(0xFFF8FAFC); // Slate-50
  static const Color textSecondaryDark = Color(0xFFCBD5E1); // Slate-300
  static const Color textTertiaryDark = Color(0xFF64748B); // Slate-500
  static const Color textDisabledDark = Color(0xFF475569); // Slate-600

  // Semantic Colors (Refined and professional)
  static const Color success = Color(0xFF059669); // Emerald-600
  static const Color successLight = Color(0xFF10B981); // Emerald-500
  static const Color warning = Color(0xFFD97706); // Amber-600
  static const Color warningLight = Color(0xFFF59E0B); // Amber-500
  static const Color error = Color(0xFFDC2626); // Red-600
  static const Color errorLight = Color(0xFFEF4444); // Red-500
  static const Color info = Color(0xFF2563EB); // Blue-600
  static const Color infoLight = Color(0xFF3B82F6); // Blue-500

  // Border Colors (Notebook ruled lines)
  static const Color border = Color(0xFFE2E8F0); // Slate-200
  static const Color borderStrong = Color(0xFFCBD5E1); // Slate-300
  static const Color borderDark = Color(0xFF334155); // Slate-700
  static const Color borderStrongDark = Color(0xFF475569); // Slate-600

  // Shadow Colors (Paper depth)
  static const Color shadow = Color(0x14000000); // Subtle shadow
  static const Color shadowMedium = Color(0x1F000000);
  static const Color shadowStrong = Color(0x3D000000);
  static const Color shadowDark = Color(0x4D000000);

  // Role Colors (Academic hierarchy)
  static const Color admin = Color(0xFF7C3AED); // Violet-600 (Authority)
  static const Color teacher = Color(0xFF0891B2); // Cyan-600 (Guidance)
  static const Color student = Color(0xFF059669); // Emerald-600 (Growth)
  static const Color guest = Color(0xFF64748B); // Slate-500 (Neutral)

  // Accent Colors for variety
  static const Color accentRose = Color(0xFFE11D48); // Rose-600
  static const Color accentOrange = Color(0xFFEA580C); // Orange-600
  static const Color accentTeal = Color(0xFF0D9488); // Teal-600
  static const Color accentPurple = Color(0xFF9333EA); // Purple-600
}
