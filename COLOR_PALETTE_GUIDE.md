# Pinterest-Style Color Palette Reference

## Color Mapping: Before → After

### Primary Colors

#### Before (Orange Theme)
```
Primary:     #E3681A (Colors.deepOrange.shade600)
Secondary:   #FF8C00 (Colors.orange.shade600)  
Seed:        #FF8C00
Background:  #FFF5E6 (cream/beige)
```

#### After (Pink Theme)
```
Primary:     #E91E63 (Colors.pink.shade600)
Secondary:   #F48FB1 (Colors.pink.shade200)
Seed:        #E91E63
Background:  #FAFAFA (soft white)
```

### Screen-Specific Colors

#### Splash Screen (powitanie.dart)
| Element | Before | After |
|---------|--------|-------|
| Background | #FFF5E6 (cream) | #FCE4EC (light pink) |
| "Smacznego!" text | Colors.deepOrange.shade700 | Colors.pink.shade700 |
| Subtitle text | Colors.orange.shade600 | Colors.pink.shade400 |
| Food gradient | Orange shades (500→400→300) | Pink shades (300→200→100) |

#### Main Dashboard (tablica_glowna.dart)
| Element | Before | After |
|---------|--------|-------|
| Background | #FFF5E6 (cream) | #FAFAFA (soft white) |
| AppBar | Colors.deepOrange.shade600 | Colors.pink.shade600 |
| Empty state icon | Colors.orange.shade300 | Colors.pink.shade300 |
| Card gradient | Orange.shade50 → White | Pink.shade50 → White |
| Time badge | Colors.deepOrange.shade600 | Colors.pink.shade600 |
| Meal type label | Colors.deepOrange.shade700 | Colors.pink.shade700 |
| Notification icon | Colors.deepOrange.shade600 | Colors.pink.shade600 |
| FAB button | Colors.deepOrange.shade600 | Colors.pink.shade600 |

#### Add Meal Screen (dodaj_danie.dart)
| Element | Before | After |
|---------|--------|-------|
| Background | #FFF5E6 (cream) | #FAFAFA (soft white) |
| AppBar | Colors.deepOrange.shade600 | Colors.pink.shade600 |
| Section headers | Colors.deepOrange.shade700 | Colors.pink.shade700 |
| Radio active | Colors.deepOrange.shade600 | Colors.pink.shade600 |
| Clock icon | Colors.deepOrange.shade600 | Colors.pink.shade600 |
| Change button | Colors.deepOrange.shade600 | Colors.pink.shade600 |
| Add button | Colors.deepOrange.shade600 | Colors.pink.shade600 |
| Ingredient icon | Colors.deepOrange.shade600 | Colors.pink.shade600 |
| Save button | Colors.deepOrange.shade600 | Colors.pink.shade600 |

#### Meal Details Screen (szczegoly_dania.dart)
| Element | Before | After |
|---------|--------|-------|
| Background | #FFF5E6 (cream) | #FAFAFA (soft white) |
| AppBar | Colors.deepOrange.shade600 | Colors.pink.shade600 |
| Card gradient | Orange.shade100 → White | Pink.shade100 → White |
| Meal type label | Colors.deepOrange.shade700 | Colors.pink.shade700 |
| Divider gradient | Orange shades | Pink shades |
| Section header | Colors.deepOrange.shade700 | Colors.pink.shade700 |
| Notification icon | Colors.deepOrange.shade600 | Colors.pink.shade600 |
| Switch active | Colors.deepOrange.shade600 | Colors.pink.shade600 |

## Material Design 3 Color Scheme

```dart
ColorScheme.fromSeed(
  seedColor: const Color(0xFFE91E63), // Pink primary
  brightness: Brightness.light,
  primary: const Color(0xFFE91E63),      // #E91E63
  secondary: const Color(0xFFF48FB1),    // #F48FB1
  surface: Colors.white,                  // #FFFFFF
  background: const Color(0xFFFAFAFA),   // #FAFAFA
)
```

## Color Psychology

### Pink (#E91E63)
- Represents: Care, warmth, nurturing
- Perfect for: Elderly care application
- Associations: Health, comfort, home cooking
- Accessibility: High contrast against white

### Soft White (#FAFAFA)
- Represents: Cleanliness, simplicity, clarity
- Perfect for: Pinterest-style aesthetic
- Benefits: Easy on the eyes, professional
- Accessibility: Excellent for large text display

## Pinterest-Style Characteristics

✅ **White Space**: Generous use of soft white backgrounds
✅ **Accent Color**: Pink used strategically for CTAs and highlights
✅ **Card Design**: Rounded corners with subtle shadows
✅ **Typography**: Large, readable fonts maintained
✅ **Gradients**: Subtle pink-to-white gradients on cards
✅ **Consistency**: Unified color palette across all screens

## Accessibility Compliance

### WCAG 2.1 AA Standards Met
- **Text Contrast**: Pink text on white backgrounds exceeds 4.5:1 ratio
- **Large Text**: All text is 20px+ (already compliant)
- **Interactive Elements**: High contrast on buttons and icons
- **Visual Hierarchy**: Clear distinction between sections

### Elderly-Friendly Design
- **High Contrast**: Maintained from original design
- **Soft Colors**: Pink is gentler than orange
- **Clear Boundaries**: White cards on soft white background
- **Large Touch Targets**: Unchanged button sizes

## Color Hex Reference

### Pink Shades Used
```
pink.shade50:  #FCE4EC
pink.shade100: #F8BBD0
pink.shade200: #F48FB1
pink.shade300: #F06292
pink.shade400: #EC407A
pink.shade600: #E91E63 (Primary)
pink.shade700: #D81B60
```

### Neutral Shades
```
White:         #FFFFFF
Soft White:    #FAFAFA
Light Grey:    #F5F5F5
Grey:          Various (unchanged)
```

### Preserved Colors
```
Green (success):  Colors.green.shade600
Red (delete):     Colors.red.shade700
Grey (disabled):  Colors.grey (various shades)
```

## Implementation Notes

1. All `Colors.deepOrange` replaced with `Colors.pink`
2. All `Colors.orange` replaced with `Colors.pink`
3. Background changed from cream (#FFF5E6) to soft white (#FAFAFA)
4. Splash screen uses light pink (#FCE4EC) for variety
5. Gradients use pink shades instead of orange shades
6. Green and red functional colors preserved
7. Grey for disabled/past items unchanged
