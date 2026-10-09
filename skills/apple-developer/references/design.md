# Native design, accessibility, and localization

## Design the platform, not just the screen size

| Concern | iPhone | iPad | Mac |
|---|---|---|---|
| Navigation | Compact hierarchy/tabs | Adaptive tabs/sidebar/split views | Sidebar, windows, menus |
| Input | Touch first | Touch, pointer, keyboard, Pencil as needed | Keyboard and pointer first |
| Space | Compact presentation | Resizable/multitasking environments | Resizable windows and displays |
| Commands | Visible controls and context menus | Controls, shortcuts, supported menus | Menu bar, toolbar, shortcuts |
| Documents | Pick/open/share clearly | Multiple documents and drag/drop | Open/save, windows, undo |

Adapt to the actual OS and window environment. A device name is not a
layout size. Newer iPad windowing and menu features do not remove the
need for touch-friendly interaction. Do not build a stretched phone
screen and call it an iPad or Mac design.[^platforms]

Choose navigation from the content hierarchy. Keep selected items,
back navigation, deep links, and restored state coherent as a split view
collapses or expands. Use progressive disclosure instead of putting
every command on the first screen.[^navigation]

## Use the system's visual language

Start with system typography, semantic colors, standard controls, and
consistent spacing. Use hierarchy and content before decorative effects.
Test dark appearance and increased contrast rather than checking only
the design canvas.[^visual]

Where supported, Liquid Glass belongs mainly to navigation and controls,
not every content card. Prefer standard components and inspect the result
when changing SDKs. Avoid stacking custom blur and glass effects that
reduce content contrast. Respect Reduce Transparency and Reduce Motion.
Do not assume a material makes an interface accessible.[^materials]

Use clear labels for actions and concise, actionable errors. Distinguish
initial loading, empty content, filtered-out content, partial results,
offline content, and failure. Preserve user input when an operation
fails. Do not present stale content as freshly saved or synchronized.

## Make input complete

For touch interfaces, use at least a 44-by-44-point hit region as the
normal starting requirement, not necessarily a 44-point icon. Do not
apply that number blindly to desktop pointer controls.[^buttons]

Use standard command meanings and shortcuts. Provide keyboard access to
important actions, visible focus, and predictable selection. On iPad,
system Full Keyboard Access handles standard controls; do not replace
it with custom focus traversal. Custom content still needs appropriate
focus and selection behavior.[^input]

Use undo/redo for reversible editing. Support expected drag/drop and
clipboard workflows when the content benefits from them, with accessible
alternatives. Avoid gesture-only or hover-only essential actions.
Do not replace standard undo gestures with unrelated actions.[^editing]

On macOS, use native Settings and menu/toolbar integration where
appropriate. A menu-bar utility should not silently become an unwanted
login service. If login launch is a requirement, use supported service
management with visible user control.[^mac]

## Accessibility is a functional test

Standard controls supply useful semantics, but labels, custom content,
reading order, and real workflows still need review.[^accessibility]

Check:

- VoiceOver names, roles, values, actions, grouping, and reading order.
- Meaningful image descriptions; decorative images excluded.
- Dynamic Type and the largest relevant accessibility text sizes.
- Text expansion without clipping critical actions or content.
- Contrast with Accessibility Inspector, including selected and disabled
  states; information must not depend on color alone.
- Keyboard-only use, Voice Control, and Switch Control for relevant flows.
- Reduced motion/transparency and increased contrast.
- Accessible progress, validation errors, and state changes.

Use Apple's current contrast guidance and automated audits, then test
the actual workflow with assistive technology. An audit result alone
does not prove a task can be completed.[^accessibility]

## Localize meaning, not fragments

Use String Catalogs where the project supports them. Localize complete
messages, supply translator context, and use plural rules rather than
adding English suffixes or concatenating translated fragments. Format
dates, numbers, currency, and measurements with locale-aware APIs.
Do not use locale-formatted strings as persistence or wire formats.[^i18n]

Test pseudolocalization, long text, right-to-left layout, and relevant
locale/calendar/time-zone boundaries. Prefer directional layout
concepts to hardcoded left/right. Do not mirror symbols or media that
have an inherent direction without checking their meaning.[^rtl]

## Review deliverable

For a UI change, identify the changed flow and inspect it in a running
app when possible. Cover the relevant compact/expanded window states,
input methods, appearance modes, and accessibility settings. State what
could not be inspected; do not infer visual quality from compilation.

[^platforms]: [Windows](https://developer.apple.com/design/human-interface-guidelines/windows); [Multitasking](https://developer.apple.com/design/human-interface-guidelines/multitasking); [Menu bar](https://developer.apple.com/design/human-interface-guidelines/the-menu-bar).
[^navigation]: [Split views](https://developer.apple.com/design/human-interface-guidelines/split-views); [Sidebars](https://developer.apple.com/design/human-interface-guidelines/sidebars); [Layout](https://developer.apple.com/design/human-interface-guidelines/layout).
[^visual]: [Typography](https://developer.apple.com/design/human-interface-guidelines/typography); [Color](https://developer.apple.com/design/human-interface-guidelines/color); [Dark Mode](https://developer.apple.com/design/human-interface-guidelines/dark-mode).
[^materials]: [Materials](https://developer.apple.com/design/human-interface-guidelines/materials); [Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/liquid-glass); [Motion](https://developer.apple.com/design/human-interface-guidelines/motion).
[^buttons]: [Buttons](https://developer.apple.com/design/human-interface-guidelines/buttons).
[^input]: [Keyboards](https://developer.apple.com/design/human-interface-guidelines/keyboards); [Pointing devices](https://developer.apple.com/design/human-interface-guidelines/pointing-devices); [Focus and selection](https://developer.apple.com/design/human-interface-guidelines/focus-and-selection).
[^editing]: [Undo and redo](https://developer.apple.com/design/human-interface-guidelines/undo-and-redo); [Drag and drop](https://developer.apple.com/design/human-interface-guidelines/drag-and-drop).
[^mac]: [Settings](https://developer.apple.com/documentation/swiftui/settings); [MenuBarExtra](https://developer.apple.com/documentation/swiftui/menubarextra); [SMAppService](https://developer.apple.com/documentation/servicemanagement/smappservice).
[^accessibility]: [Accessibility HIG](https://developer.apple.com/design/human-interface-guidelines/accessibility); [VoiceOver](https://developer.apple.com/design/human-interface-guidelines/voiceover); [Accessibility Inspector](https://developer.apple.com/documentation/accessibility/accessibility-inspector).
[^i18n]: [String Catalogs](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog); [Plurals](https://developer.apple.com/documentation/xcode/localizing-strings-that-contain-plurals); [Formatters](https://developer.apple.com/documentation/xcode/preparing-dates-numbers-with-formatters).
[^rtl]: [Right to left](https://developer.apple.com/design/human-interface-guidelines/right-to-left); [Testing localizations](https://developer.apple.com/documentation/xcode/testing-localizations-when-running-your-app).
