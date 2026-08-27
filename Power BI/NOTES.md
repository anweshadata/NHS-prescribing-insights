# Power BI Dashboard: Build Notes & Troubleshooting

Working notes from building the NHS Prescribing Insights Power BI dashboard (Project 3). Kept separate from the main README so the project summary stays short, this is the detail for anyone curious about what actually went wrong and how it was fixed.

## 1. Relationship direction silently broke a regional measure

`region_population` and `cleaned_nhs_prescription_data` are related many-to-one on `REGION_NAME`, with filters propagating one way only: from `region_population` (the "one" side) down to the fact table (the "many" side), not the reverse.

`Regional Per Capita Gap` needs to compare Spend per Capita between two specific regions. Two early versions of the measure filtered on `cleaned_nhs_prescription_data[REGION_NAME]` instead of `region_population[REGION_NAME]`:

- `MAXX`/`MINX` over `ALL(cleaned_nhs_prescription_data[REGION_NAME])` → returned 24.25
- `CALCULATE` naming regions directly via `cleaned_nhs_prescription_data[REGION_NAME]` → returned 12.84

Both wrong for the same reason: filtering the fact table's column only restricted the NIC (cost) side of the `Spend per Capita` division. `POPULATION` stayed summed across all 7 regions regardless, silently deflating the result. Neither version threw an error, both just looked plausible.

**Fix:** filter on `region_population[REGION_NAME]` (the "one" side), which correctly propagates down to the fact table. Confirmed correct value: £106.92 (£254.18 − £147.26, North East and Yorkshire vs London).

**Takeaway:** any measure comparing regions has to be checked against which table's column it filters on, not just whether the number looks reasonable.

## 2. A raw text field hid a spelling-variant split in cost totals

The "Top 10 Medicines: Detail" table originally ranked by the raw `GENERIC_BNF_EQUIVALENT_NAME` field. Beclometasone had two spelling variants in that field ("CFCfree" vs "CFC free"), which split its cost across two rows instead of one. The table showed roughly £120M for Beclometasone when the true combined figure was £153,827,217.

**Fix:** re-ranked by `Medicine Clean` (the cleaned column that collapses spelling variants) instead of the raw field. Total across the Top 10 confirmed correct afterward at £1,681,645,547.

**Takeaway:** every visual referencing a medicine, chart axis and any Top N filter ranking, needs to use the cleaned column, not just whichever field happens to display correctly.

## 3. A ranking measure leaked filter context from the wrong visual

`Cost per Item Rank (Min Volume)` ranks medicines by cost-per-item among those with at least 500 total items prescribed (to stop one-off prescriptions dominating the ranking, see #5). An early version used `ALL(cleaned_nhs_prescription_data[Medicine Clean])` only. In a table visual that also grouped by `BNF_CHAPTER`, that let the chapter's filter context leak in, so the measure secretly ranked medicines separately within each `BNF_CHAPTER` category instead of across the whole dataset, producing 30+ rows in a "Top 10" table instead of 10.

**Fix:** `ALL()` needed to clear both `Medicine Clean` and `BNF_CHAPTER` so the ranking stayed dataset-wide regardless of what else the visual grouped by.

## 4. Y-axis fixed minimum broke once the region slicer was added

The "Prescribing Cost Trend" line chart on the Overview page had its Y-axis minimum manually fixed at 850,000,000 to make the national-level trend line easier to read. Once the Region slicer was added and someone filtered down to a single region, per-region monthly totals fell well below that fixed floor and the line rendered off-screen, out of the visible chart area.

**Fix:** changed the Y-axis Minimum back to Auto. Same fix applied to the Items Trend chart on the Volume page, built the same way.

**Takeaway:** a fixed axis range that looks fine for the default (unfiltered) view can break silently the moment a filter changes what data is actually being plotted, worth testing charts with filters applied, not just in their default state.

## 5. An unweighted "cheapest/most expensive" ranking was meaningless

Ranking medicines by simple Cost per Item, with no minimum volume, surfaced medicines with as few as 1 total item prescribed over the whole year (e.g. Cabozantinib, Lenalidomide). The "average" cost for those is just the price of a single dispensing event, not a meaningful per-item figure.

**Fix:** added a 500-item minimum threshold via the `Cost per Item Rank (Min Volume)` measure, which returns 999999 (not `BLANK()`) for medicines below the threshold, since `BLANK()` evaluates as 0 in DAX and would have incorrectly passed a "rank <= 10" filter.

## 6. Map visual: attempted and abandoned

Wanted a choropleth/bubble map of regional spend on the Regional page. Hit two blockers:

- The classic Power BI Map visual was deprecated/removed as of the September 2025 Power BI update, replaced by "Azure Map."
- Tried ArcGIS Maps for Power BI as an alternative: hit an "Admin assistance required" prompt for SSO (needs a Fabric/Power BI admin, not available on this account), and separately, geocoding failed for most regions anyway, NHS England's 7 custom region groupings ("Midlands," "North East and Yorkshire," etc.) aren't real place names that Esri/Bing recognize. Only London geocoded correctly.

**Resolution:** replaced the planned map with a KPI card (`Widest Regional Gap: Spend per Person`) instead of pursuing a custom boundary-file workaround, which was out of scope for this project's timeframe.

## 7. Known limitation, left as-is on purpose: static text callouts

Pages 3-5 (Volume, Cost vs Volume, Regional) each have a text callout summarising a specific finding (e.g. "Mounjaro is prescribed just 3.2 million times a year, yet costs the NHS more than any other medicine"). These are static text boxes, not DAX-driven, so they don't update when the Region slicer filters the report. Their wording is only guaranteed accurate in the unfiltered, all-regions view.

This was a deliberate decision, not an oversight: the deliverable for this project is a set of static screenshots of the unfiltered dashboard, where every callout is accurate as written. Building fully dynamic DAX-driven callout text (recalculating which medicine is "10th place" etc. under any filter combination) was judged out of scope for the value it would add here. If this dashboard were ever shared as a live interactive file rather than screenshots, this is the first thing to revisit.

## Working correctly, confirmed

- Region slicer (Overview page) with Sync Slicers enabled across all 5 pages, verified end-to-end by selecting London and checking that KPI cards, charts, and tables updated correctly on every page.
- All final totals cross-checked against temporary diagnostic tables before being used in KPI cards or callouts (e.g. regional Total Cost figures, Top 10 Cost %, Mounjaro combined cost).
