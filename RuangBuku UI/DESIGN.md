---
name: Literary Hearth
colors:
  surface: '#faf9f8'
  surface-dim: '#dadad9'
  surface-bright: '#faf9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f4f3f2'
  surface-container: '#eeeeed'
  surface-container-high: '#e9e8e7'
  surface-container-highest: '#e3e2e1'
  on-surface: '#1a1c1c'
  on-surface-variant: '#44474d'
  inverse-surface: '#2f3130'
  inverse-on-surface: '#f1f0f0'
  outline: '#75777e'
  outline-variant: '#c5c6ce'
  surface-tint: '#4e5f7e'
  primary: '#031632'
  on-primary: '#ffffff'
  primary-container: '#1a2b48'
  on-primary-container: '#8293b5'
  inverse-primary: '#b6c7eb'
  secondary: '#904d00'
  on-secondary: '#ffffff'
  secondary-container: '#ffa454'
  on-secondary-container: '#713b00'
  tertiary: '#001c0d'
  on-tertiary: '#ffffff'
  tertiary-container: '#00331c'
  on-tertiary-container: '#43a470'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d7e2ff'
  primary-fixed-dim: '#b6c7eb'
  on-primary-fixed: '#081b38'
  on-primary-fixed-variant: '#374765'
  secondary-fixed: '#ffdcc3'
  secondary-fixed-dim: '#ffb77d'
  on-secondary-fixed: '#2f1500'
  on-secondary-fixed-variant: '#6e3900'
  tertiary-fixed: '#95f7bb'
  tertiary-fixed-dim: '#7adaa1'
  on-tertiary-fixed: '#002110'
  on-tertiary-fixed-variant: '#005230'
  background: '#faf9f8'
  on-background: '#1a1c1c'
  surface-variant: '#e3e2e1'
typography:
  display-lg:
    fontFamily: Literata
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Literata
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-sm:
    fontFamily: Literata
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-bold:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  display-lg-mobile:
    fontFamily: Literata
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  margin-mobile: 20px
  gutter: 16px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 24px
---

## Brand & Style
The design system is centered on the concept of a "digital reading room"—a space that feels as warm and inviting as a physical library while maintaining the efficiency of a modern mobile application. The target audience includes avid readers, local community organizers, and students who value both the intellectual weight of books and the social warmth of sharing them.

The style is a blend of **Modern Minimalism** and **Tactile warmth**. It avoids the clinical coldness of typical SaaS products by using soft edges, generous whitespace, and a palette that evokes paper, ink, and natural light. The goal is to create a trustworthy environment where users feel safe lending their personal property.

## Colors
The palette is grounded in **Deep Navy (#1A2B48)**, representing the stability and authority of a classic library. This is used for primary actions and core typography to ensure high contrast and trust.

**Warm Orange (#F2994A)** serves as the primary accent, used sparingly for calls-to-action (CTAs) and interactive highlights to inject energy and a "hearth-like" warmth into the UI. **Soft Sage (#6FCF97)** is reserved for success states, "available" book statuses, and community growth indicators. The background is not a pure white but a very faint, paper-like off-white (#FDFCFB) to reduce eye strain during long browsing sessions.

## Typography
To bridge the gap between "modern" and "literary," this design system employs a pairing of **Literata** for headings and **Inter** for UI elements and body text. 

Literata brings a scholarly, authoritative, and sophisticated feel to book titles and section headers. Inter provides the functional clarity required for a mobile app, ensuring that labels, metadata, and instructions remain highly legible at small sizes. Line heights are purposefully generous to maintain a breathable, relaxed reading experience.

## Layout & Spacing
The design system utilizes a **fluid grid** for mobile, centered on a 4px baseline shift to ensure mathematical harmony. A standard **20px side margin** is maintained on mobile devices to prevent content from feeling cramped against the screen edges.

Vertical rhythm is driven by the "Stack" concept: 8px for related elements (title + author), 16px for distinct components within a section, and 24px+ for separating major layout blocks. Book listings should use a 2-column grid on mobile to balance visual density with clear tap targets.

## Elevation & Depth
Depth is created through **Tonal Layers** supplemented by **Ambient Shadows**. Instead of harsh black shadows, this design system uses soft, diffused shadows tinted with the primary Navy color at very low opacity (5-8%). 

- **Level 0 (Base):** The off-white background.
- **Level 1 (Cards):** Slightly elevated with a 4px blur shadow. These house book listings and community posts.
- **Level 2 (Modals/Overlays):** Highly elevated with a 12px blur shadow to draw focus.
Floating Action Buttons (FABs) for "Add Book" use the highest elevation to signal priority.

## Shapes
The shape language is overtly **rounded** to reinforce the "friendly" and "approachable" brand personality. A base radius of **16px** (rounded-lg) is the standard for cards and input fields. 

Small elements like tags or status chips should use a fully rounded "pill" shape to contrast against the more structural cards. Book cover images within the UI should have a subtle 8px radius to soften their appearance while maintaining the rectangular proportions of physical books.

## Components
- **Buttons:** Primary CTAs use a solid Deep Navy background with white text. "Warmth" actions (like 'Borrow' or 'Request') use the Warm Orange. Secondary buttons should be outlined with a 1.5px stroke.
- **Cards:** Book cards feature a vertical layout: the book cover image on top (with 8px radius), followed by the title in Literata and status chips. Cards must have a white background to pop against the off-white base.
- **Status Chips:** Use Soft Sage for "Available" and a neutral grey for "On Loan." Text inside chips is set in `label-bold`.
- **Input Fields:** Large, 16px rounded corners with a light navy border (10% opacity). On focus, the border transitions to a 2px Deep Navy stroke.
- **Progressive Disclosure:** Use bottom sheets instead of full-screen modals for book details to maintain the user's context within the community feed.
- **Search Bar:** A prominent, rounded-pill search bar at the top of the home screen, utilizing a "Search books or neighbors" placeholder to emphasize the community aspect.