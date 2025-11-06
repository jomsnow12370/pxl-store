# MRHY PXL Store - Neobrutalism Design System

## Overview
This document outlines the unified design system implemented across the MRHY PXL Store application, following neobrutalism design principles with mobile-first approach.

## Design Tokens

### Typography Scale (`NeoBrutalTypography`)
Consistent text sizing across all screens:

- **Display (Headings)**
  - `displayLarge: 16.0` - Screen titles (AppBar, main headers)
  - `displayMedium: 14.0` - Section headers
  - `displaySmall: 12.0` - Card titles, subsection headers

- **Body (Content)**
  - `bodyLarge: 11.0` - Primary content
  - `bodyMedium: 10.0` - Secondary content
  - `bodySmall: 9.0` - Tertiary content

- **Label (UI Elements)**
  - `labelLarge: 10.0` - Button text
  - `labelMedium: 9.0` - Input labels, form fields
  - `labelSmall: 8.0` - Badges, chips, micro-text

**Note:** Minimum font size is 8px for readability.

### Spacing System (`NeoSpacing`)
Based on 8px grid for consistent layout:

- `xxs: 4.0` - Micro spacing (tight gaps)
- `xs: 8.0` - Tight spacing
- `sm: 12.0` - Compact spacing
- `md: 16.0` - Default spacing (most common)
- `lg: 24.0` - Comfortable spacing (section gaps)
- `xl: 32.0` - Loose spacing
- `xxl: 48.0` - Section breaks

**Standard Padding:**
- `cardPadding: 16.0` - Default card padding
- `cardPaddingLarge: 20.0` - Large card padding
- `screenPadding: 16.0` - Screen edge padding

### Color Palette (`NeoBrutalColors`)

#### Primary Colors
- `primary: #111111` - Black (text, borders)
- `accent: #F9D74B` - Punchy Yellow (CTAs, highlights)

#### Surfaces
- `surface: #F5F5F5` - Light gray background
- `surfaceCard: #FFFFFF` - White cards
- `surfaceAlt: #E8E8E8` - Alternative background

#### Semantic Colors
- `success: #4CAF50` - Green (positive actions)
- `successDark: #27AE60` - Dark green
- `info: #2196F3` - Blue (informational)
- `infoDark: #2980B9` - Dark blue
- `warning: #FF9800` - Orange (warnings)
- `warningLight: #FFA726` - Light orange
- `error: #E74C3C` - Red (errors, destructive)
- `errorDark: #F44336` - Dark red

#### Background Colors (Semantic)
- `bgSuccess: #E8F5E9` - Light green background
- `bgInfo: #E3F2FD` - Light blue background
- `bgWarning: #FFF3E0` - Light orange background
- `bgError: #FFEBEE` - Light red background
- `bgNeutral: #F8F9FA` - Light neutral background

#### Text Colors
- `textPrimary: #000000` - Black text
- `textSecondary: #616161` - Gray text
- `textTertiary: #9E9E9E` - Light gray text

#### Borders
- `border: #000000` - Black borders (primary)
- `borderSubtle: #9E9E9E` - Gray borders (subtle)

### Component Standards (`NeoComponents`)

#### Border Radius (Neobrutalism = Sharp Edges)
- `sharp: BorderRadius.zero` - **Primary style** (no rounding)
- `slightRound: 4px` - Minimal rounding (rare use)
- `dialogRound: 12px` - Dialog corners (exceptions only)

#### Border Widths
- `borderThick: 3.0` - Primary borders (cards, buttons)
- `borderMedium: 2.0` - Secondary borders (chips, badges)
- `borderThin: 1.0` - Subtle borders (dividers)

#### Shadows (Hard Shadows)
- `shadowSmall: Offset(4, 4), blur: 0` - Standard card shadow
- `shadowMedium: Offset(6, 6), blur: 0` - Larger elements

**Note:** Neobrutalism uses hard shadows with NO blur.

#### Touch Targets
- `minTouchTarget: 44.0` - Minimum touch area (accessibility)
- `buttonHeight: 48.0` - Standard button height
- `buttonPadding: (20, 14)` - Horizontal, vertical padding
- `inputPadding: (16, 16)` - Input field padding

### Responsive Breakpoints (`NeoResponsive`)

- `mobile: 600` - Below 600px
- `tablet: 900` - 600px to 900px
- `desktop: 1200` - 1200px and above

**Grid Columns:**
- Mobile: 2 columns
- Tablet: 3 columns
- Desktop: 4 columns

## Implementation Summary

### ✅ Completed Updates

#### 1. **Theme Configuration**
- Updated `MaterialApp` theme to use all design tokens
- Standardized `AppBarTheme`, `CardTheme`, `ElevatedButtonTheme`, `OutlinedButtonTheme`
- Consistent `InputDecorationTheme` with sharp borders

#### 2. **Login Screen**
- Updated padding to use `NeoSpacing.lg` and `NeoSpacing.cardPaddingLarge`
- Font sizes use typography scale
- Button height standardized to `NeoComponents.buttonHeight` (48px)
- Error messages use semantic colors

#### 3. **Dashboard Screen**
- Headers use `displayMedium` and `displaySmall`
- Section spacing uses `NeoSpacing.lg` (24px)
- Card shadows standardized to `Offset(4, 4)`
- Semantic background colors for stat cards
- Consistent padding throughout

#### 4. **POS Screen**
- **Fixed rounded corners** → All sharp borders (`BorderRadius.zero`)
- Payment dialog uses sharp borders
- Quick amount buttons use design tokens
- Search bar uses sharp borders with proper focus states
- Loading indicator uses consistent styling

#### 5. **Config Screen**
- Color chips use `bgInfo` with sharp borders
- Size chips use `bgWarning` with sharp borders
- Headers use typography scale
- Info box uses `bgNeutral` with proper spacing

#### 6. **Inventory Screen**
- Product cards use consistent padding
- Shadows standardized
- Typography scale applied throughout

## Key Improvements

### 🎨 Design Consistency
- **Typography:** Reduced from 15+ font sizes to 9 standardized sizes
- **Spacing:** Unified from 10+ values to 7 standard increments
- **Colors:** Consolidated from scattered values to semantic palette
- **Borders:** All primary borders are 3px, sharp edges (neobrutalism)

### 📱 Mobile-First
- Touch targets minimum 44px
- Button heights standardized to 48px
- Responsive grid system (2/3/4 columns)
- Font sizes optimized for readability (minimum 8px)

### ♿ Accessibility
- Proper touch target sizes
- Consistent color contrast
- Clear visual hierarchy
- Semantic color usage

### 🔧 Maintainability
- All magic numbers replaced with named constants
- Easy to update entire app by changing token values
- Clear documentation in code comments
- Consistent naming conventions

## Usage Guidelines

### When to Use Each Token

**Typography:**
- Use `displayLarge` for screen titles in AppBar
- Use `displayMedium` for main section headers
- Use `displaySmall` for card titles
- Use `bodyMedium` for most content
- Use `labelLarge` for buttons
- Use `labelSmall` for badges and chips

**Spacing:**
- Use `md` (16px) as default padding
- Use `lg` (24px) for section gaps
- Use `xs` (8px) for tight spacing between related items
- Use `sm` (12px) for compact layouts

**Colors:**
- Use semantic colors (`success`, `error`, `warning`, `info`) for actions
- Use background colors (`bgSuccess`, `bgError`, etc.) for card backgrounds
- Always use `border` for primary borders
- Use `textSecondary` for less important text

**Components:**
- Always use `sharp` for borders (neobrutalism)
- Use `borderThick` (3px) for primary elements
- Use `borderMedium` (2px) for secondary elements
- Use `shadowSmall` for standard cards

## Before & After Comparison

### Typography
- **Before:** 6px, 7px, 8px, 9px, 10px, 11px, 12px, 14px, 16px, 18px, 20px (11 sizes)
- **After:** 8px, 9px, 10px, 11px, 12px, 14px, 16px (7 sizes)

### Spacing
- **Before:** 2px, 4px, 6px, 8px, 12px, 16px, 20px, 24px, 32px (9 values)
- **After:** 4px, 8px, 12px, 16px, 24px, 32px, 48px (7 values)

### Borders
- **Before:** Mixed rounded corners (0px, 4px, 8px, 12px, 16px)
- **After:** Sharp borders (`BorderRadius.zero`) for neobrutalism

### Button Heights
- **Before:** 50px, 52px, varying heights
- **After:** Standardized 48px (`NeoComponents.buttonHeight`)

## Future Enhancements

1. **Animation Tokens** - Standardize transition durations
2. **Elevation System** - Define z-index hierarchy
3. **Icon Sizes** - Standardize icon dimensions
4. **Loading States** - Consistent loading indicators
5. **Empty States** - Unified empty state designs

## Testing Checklist

- [ ] All screens render correctly on mobile (< 600px)
- [ ] All screens render correctly on tablet (600-900px)
- [ ] All screens render correctly on desktop (> 900px)
- [ ] Touch targets are minimum 44px
- [ ] Font sizes are minimum 8px
- [ ] All borders are sharp (no rounded corners except dialogs)
- [ ] Colors follow semantic meaning
- [ ] Spacing is consistent throughout

---

**Last Updated:** November 6, 2025  
**Version:** 1.0.0  
**Maintained by:** Development Team
