---
name: dashboard
description: Design and review dashboards that are informative, honest, accessible, and visually polished, independent of any tool. Use when planning, building, critiquing, or simplifying a dashboard, KPI page, monitoring board, wallboard, or report with charts.
user_invocable: true
---

# Dashboard

A dashboard is a decision tool, not a collection of charts. Stephen Few defines
it as "a visual display of the most important information needed to achieve one
or more objectives, consolidated and arranged on a single screen so the
information can be monitored at a glance." Work backward from the decisions the
dashboard supports. Encode the most important data with the most accurate
channels. Show context and uncertainty honestly. A dashboard looks good when it
is restrained and consistent, not when it is decorated.

## Start with purpose, not data

- Write down the audience, the decisions they make, how often they look, and
  the device or setting (desk, phone, wall TV).
- Ask users: what do you need to know, what will you do with it, and which
  decisions depend on it? Never design a dashboard without talking to the
  people who will use it.
- Pick the genre first, because each one follows different rules:
  - **Static or executive**: single screen, no interaction, glanceable.
  - **Analytic**: faceted views, filters, drill-down. Avoid scrolling, because
    it makes comparison harder.
  - **Operational or monitoring**: real time, built around how the system
    behaves, and paired with alerts.
  - **Magazine or public**: narrative text, annotations, and a guided story.
- Only build a dashboard for high-priority indicators that are updated often
  and revisited. A one-off question is better answered with a report or a
  single chart.

## Choose metrics deliberately

- For every metric, ask: "What would I do differently if this went up or
  down?" If the answer is nothing, remove the metric.
- Prefer actionable metrics over vanity totals. Pair lagging outcomes
  (revenue, churn) with leading indicators (pipeline, engagement).
- Expect metrics to be gamed once they become targets (Goodhart's law). Add a
  counter-metric, such as speed paired with quality.
- Give every KPI a name, definition, calculation, source, owner, target, and
  refresh cadence. Keep definitions in one shared place so different
  dashboards don't disagree.
- Show only a few headline numbers. Working memory is limited. There is no
  magic number, so cut until every remaining tile earns its place.
- Never show a number alone. Pair it with at least one of: target, prior
  period, same period last year, forecast, benchmark, or normal range.

## Encode for accuracy

- Perceptual accuracy, from most to least accurate: position on a common
  scale > position on unaligned scales > length > slope or angle > area >
  volume > color saturation. Put the most important quantity on position or
  length.
- Use hue for categories and lightness or saturation for ordered values.
  Never use hue to show a quantity.
- Make one thing stand out with a single feature, such as one saturated color
  against grey. Readers cannot quickly find an item defined by a combination of
  two features, such as "red and square".
- Keep graphical integrity: the visual effect should match the data effect,
  never add visual dimensions the data doesn't have, and never strip the data
  of its context.

### Pick the right form

| Need | Use | Avoid |
| --- | --- | --- |
| Compare magnitudes | Bars or dots; bars start at zero | 3D bars, truncated bars |
| Trend over time | Line; sparkline for compact trend | Animation instead of small multiples |
| Progress vs. target | Bullet graph | Gauges, dials, speedometers |
| Part-to-whole | Stacked bar, or a pie with 5 or fewer slices | Many-slice pies or donuts |
| Many series or entities | Small multiples with shared scales | Spaghetti lines |
| Exact lookup, mixed units | Table | Charts that make users estimate values |
| Two measures with different units | Two aligned panels | Dual-axis charts |
| Units of very different sizes | Funnel plot with control limits | League-table rankings |

### Building blocks

- **KPI tile**: value (largest), short label, comparison, gap in absolute and
  percent terms, and a small trend. Color the gap by good or bad relative to
  the target, not by arrow direction (costs going down is good). Always pair
  color with a symbol or sign.
- **Bullet graph**: label, linear scale, a bar for the measure, a tick for the
  target, and 2–5 qualitative bands in shades of one hue.
- **Sparkline**: a word-sized trend for context. Rows with independent y-axes
  are not comparable to each other.
- **Tables**: right-align numbers and left-align text. Use consistent
  precision, tabular figures, and units stated once in the header. Use light
  dividers instead of grids, and add zebra stripes only on wide tables. Sort by
  the most meaningful column. Highlight outliers. Add in-cell bars,
  sparklines, or heatmap shading where they help.

## Layout and hierarchy

- Readers scan top-left first, then across, then down the left edge. Put the
  main message or headline KPIs top-left. Start labels with the words that
  carry the meaning.
- Order the page as overview, then trends and breakdowns, then detail
  ("overview first, zoom and filter, then details on demand"). Put secondary
  material behind tooltips, drill-downs, or extra pages.
- Group related items with proximity and whitespace before adding boxes. Use
  more space between groups than within them.
- Align everything to a grid. Panels that will be compared need the same
  scales, time ranges, and sizes.
- Manage the trade-off between screen space, abstraction, number of pages,
  and interactivity. Shrinking one forces growth in another, so decide
  deliberately.
- Minimize interaction. If something can be solved without a click, solve it
  that way.

## Color

- Match the palette to the data: sequential for ordered values, diverging
  around a meaningful midpoint, qualitative for categories, cyclic for
  wrap-around values such as hour of day.
- For continuous data, use perceptually uniform maps such as viridis or
  cividis. Never use rainbow or jet.
- Make grey the default and use one accent color for what matters. Use at
  most 5–7 categorical colors; beyond that, group categories or change the
  chart.
- The same entity gets the same color in every panel and every dashboard.
- Avoid encoding meaning with red and green alone. Blue and orange is a safer
  pair. Make colors differ in lightness, and check that the dashboard still
  works in grayscale.
- Light themes read better for detailed work. Dark themes suit wallboards in
  dim rooms. Check contrast in whichever theme you ship.

## Text and numbers

- Write takeaway titles that state the finding and suggest the action. Titles
  strongly bias how readers interpret a chart, so the data must support the
  title.
- Label lines and series directly instead of using legends.
- Use a readable sans-serif with lining, tabular figures, in sentence case.
  Use bold only for emphasis, avoid thin weights, and use uppercase sparingly.
- Abbreviate large numbers (1.2M), keep decimals consistent, avoid false
  precision, and always show units and currency.
- Prefer linear scales for general audiences. Use log scales only for expert
  readers and heavy-tailed data such as latency.

## Honesty, context, and uncertainty

- Bars start at zero. Line charts can zoom to the range that matters, but
  choose the scale based on what counts as a meaningful change.
- Don't distort the chart with inverted axes, area encoding quantity,
  stretched aspect ratios, dual axes, or cherry-picked time ranges. Most
  real-world misleading charts are technically correct charts with misleading
  framing, so check the argument as well as the axes.
- Flag or exclude incomplete current periods, or compare equal periods
  (month-to-date vs. the same days last month). A partial period always looks
  like a drop.
- Smooth noisy daily data with a rolling average, such as 7-day. A trailing
  average lags the data and a centered average does not, so label which one
  you use.
- Show uncertainty where it matters: confidence bands for forecasts and
  frequency framing for lay audiences. Putting too much emphasis on a point
  estimate makes readers ignore the uncertainty.
- For small bases, show both the percent change and the absolute change.
- Annotate events on time series: launches, deploys, incidents, and changes
  to metric definitions.

## Trust and metadata

- Always show when the data was last updated. Make stale data visibly stale.
- Show the data source, a short description, and any disclaimers or
  limitations.
- Put metric definitions in tooltips or a glossary, and make sure they match
  the shared metric layer.
- Show missing data as missing, never as zero.
- Give users a way to see or export the underlying table.

## Interaction

- The default view must answer the main question without any clicks. Most
  viewers never interact.
- Every control should serve a clear purpose (select, explore, reconfigure,
  re-encode, change detail level, filter, connect). Remove controls that
  serve none.
- Keep the applied filters, segments, and date range visible, and provide a
  reset.
- Respond within 100 ms for direct manipulation and about 1 s for queries.
  Delays of 500 ms already reduce how much users explore.
- A useful structure is a guided headline at the top that opens into free
  exploration below.

## Accessibility

- Never use color as the only way to convey information (WCAG 1.4.1). Add
  labels, symbols, patterns, or position.
- Text contrast must be at least 4.5:1, or 3:1 for large text (WCAG 1.4.3).
  Chart marks and UI parts need at least 3:1 against adjacent colors
  (WCAG 1.4.11).
- Provide text alternatives and data tables for charts (WCAG 1.1.1).
- Make filters and tooltips keyboard reachable, and test with a color-vision
  deficiency simulator.

## Making it beautiful

Looks matter. People judge visual appeal within about 50 ms, attractive
interfaces are perceived as more usable, and users put up with more friction
on visualizations they find appealing. Beauty comes from a system, not from
ornament:

- Use fixed scales for spacing (4/8 px), type (2–3 sizes and weights), color
  (neutrals plus 1–2 accents), radius, and borders. Don't mix rounded and
  square corners.
- Design in grayscale first so that hierarchy comes from size, weight,
  spacing, and contrast. Add color last.
- Remove decoration: 3D effects, heavy borders, background fills, gradients,
  dense gridlines, shadows, gauges, and redundant legends.
- Keep functional richness. Color-coded gaps, sparklines, annotations,
  meaningful icons, and size hierarchy help memory without hurting
  comprehension.
- Aim for moderate visual complexity and colorfulness. Too much hurts first
  impressions, and too little looks empty.
- Apply one style guide (color per entity, chart templates, type, spacing)
  across all dashboards.

## Operational and monitoring dashboards

- Structure the panels with an established method. For services, use the
  four golden signals (latency, traffic, errors, saturation) or RED (rate,
  errors, duration) with one row per service. For resources, use USE
  (utilization, saturation, errors).
- Build around SLOs: show the SLI, the target, and the remaining error
  budget.
- Show latency as percentiles, histograms, or heatmaps, never as an average
  alone. Short spikes disappear when averaged over long windows.
- Dashboards inform and alerts page people. Nobody should have to watch a
  screen to catch problems.
- Build a hierarchy: a service overview that drills down to components, with
  the same layout for every service. Keep dashboards as code under version
  control, and avoid copy-and-tweak sprawl.
- Wallboards should be full screen, non-interactive, and auto-refreshing,
  with large type, few panels, color used only for state, and readable in
  under 3 seconds from across the room.

## Mobile and small screens

- Stack panels vertically instead of placing them side by side. Prioritize
  and remove content that isn't essential to the message.
- Reduce width, shorten labels (January → J), aggregate when necessary, and
  fix tooltips to a stable position.
- Swapping the axes and stacking panels have costs: charts can grow too tall,
  and items are no longer visible together for comparison. Check that the
  message survives.
- Prefer linear layouts over radial ones. Prefer small multiples over
  animation for comparing trends.

## Evaluate and maintain

- Glance test: show the dashboard for 5 seconds, then ask what it says and
  whether things are OK.
- Run think-aloud sessions using real decisions as tasks, and watch *why*
  users struggle.
- Review the dashboard against visualization heuristics and an accessibility
  checklist such as Chartability.
- Give every dashboard an owner and a review date. Track usage, merge
  duplicates, and retire dashboards nobody uses. Revisit the measures when
  priorities change.

## Common pitfalls (Few's 13)

1. Exceeding the boundaries of a single screen
2. Supplying inadequate context for the data
3. Displaying excessive detail or precision
4. Expressing measures indirectly
5. Choosing inappropriate media of display
6. Introducing meaningless variety
7. Using poorly designed display media
8. Encoding quantitative data inaccurately
9. Arranging the data poorly
10. Ineffectively highlighting what's important
11. Cluttering the screen with useless decoration
12. Misusing or overusing color
13. Designing an unappealing visual display

## Review checklist

- [ ] Audience, decisions, cadence, and genre are explicit.
- [ ] Every metric is defined, actionable, and shown with context.
- [ ] The most important values use position or length. No gauges, 3D, dual
      axes, or many-slice pies. Bars start at zero.
- [ ] The key message is top-left, the page flows from overview to detail,
      items are grouped by whitespace and aligned to a grid, and compared
      panels share scales.
- [ ] Grey plus one accent, consistent entity colors, CVD-safe, and never
      color alone.
- [ ] Takeaway titles, direct labels, units shown, consistent formatting,
      and tabular figures.
- [ ] Last-updated time, source, and caveats are visible. Partial periods
      are flagged, and uncertainty and events are shown.
- [ ] The default view answers the question. Filter state is visible.
      Interactions respond in about 1 s or less.
- [ ] WCAG contrast is met and a table or text alternative exists.
- [ ] Fixed spacing, type, and color scales with no decorative chrome.
- [ ] The dashboard passes a 5-second glance test with a real user, and has an
      owner and a review date.

## References

- Stephen Few, [Common Pitfalls in Dashboard Design](https://www.perceptualedge.com/articles/Whitepapers/Common_Pitfalls.pdf) and [Bullet Graph Design Specification](https://www.perceptualedge.com/articles/misc/Bullet_Graph_Design_Spec.pdf)
- Bach et al., [Dashboard Design Patterns](https://dashboarddesignpatterns.github.io/) (IEEE TVCG 2023)
- Sarikaya et al., [What Do We Talk About When We Talk About Dashboards?](https://alper.datav.is/publications/dashboards/) (IEEE VIS 2018)
- Munzner, [Visualization Analysis & Design](https://www.cs.ubc.ca/~tmm/vadbook/)
- Wilke, [Fundamentals of Data Visualization](https://clauswilke.com/dataviz/)
- Financial Times, [Visual Vocabulary](https://github.com/Financial-Times/chart-doctor/tree/main/visual-vocabulary)
- Datawrapper, [colors](https://www.datawrapper.de/blog/colors), [colorblind readers](https://www.datawrapper.de/blog/colorblindness-part2), [fonts](https://www.datawrapper.de/blog/fonts-for-data-visualization), [tables](https://www.datawrapper.de/blog/guide-what-to-consider-when-creating-tables)
- ONS, [Data visualisation service manual](https://service-manual.ons.gov.uk/data-visualisation)
- UK Government Analysis Function, [Building and managing dashboards](https://analysisfunction.civilservice.gov.uk/policy-store/data-visualisation-building-and-managing-dashboards/)
- [Chartability](https://chartability.fizz.studio/) and [WCAG 2.2](https://www.w3.org/TR/WCAG22/)
- Google SRE, [Monitoring Distributed Systems](https://sre.google/sre-book/monitoring-distributed-systems/)
- Brendan Gregg, [The USE Method](https://www.brendangregg.com/usemethod.html)
