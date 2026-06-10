---
name: "dashboard-tokens"
description: "Generate a comprehensive project health dashboard as a static HTML file with Chart.js visualisations. Five sections — Token & Cost, Quality, Pipeline & Velocity, Knowledge Base, Health. Exports to email-friendly HTML summary and CSV. Use when user runs $dashboard-tokens, or called automatically at the end of $context-health."
metadata:
  category: metrics
  origin: Adapted from Glen Sanders (Forge / https://github.com/glensanders-gdev/Forge)
---

# Dashboard

Generate a self-contained HTML dashboard visualising project health across all tracked Forge metrics.
Writes to `docs/dashboard/`. Opens `index.html` in the browser after generation.

---

## Output Files

```
docs/dashboard/
  index.html     ← main dashboard (Chart.js, five sections)
  summary.html   ← email-friendly tables, no JS dependencies
  data.csv       ← raw data export
```

---

## Data Sources

| Source | Used by |
|--------|---------|
| `docs/tokens/[feature].md` | Token spend, estimate vs actual |
| `docs/context-health-report.md` | Context load trend |
| `docs/metrics/metrics-log.md` | Critic trend, diagnose rate, lookup activity, sprint velocity |
| `docs/tech-debt.md` | Debt tier distribution |
| `docs/feature-flags.md` | Flag age distribution |
| `docs/security/assessment-*.md` | Security findings per assessment |
| `~/.codex/forge/registry.md` | Project name, PROJ-NNN |
| `~/.codex/forge/companies/[active_company]/config.md` | `token_cost_per_1k` (optional) |

If a source file is missing, skip those panels gracefully — note the missing source in the panel.

---

## Phase 1 — Parse All Data Sources (silent)

Read all source files and build data objects for injection into the HTML.

### 1a. Token data — `docs/tokens/[feature].md`

For each feature file (excluding `_template.md`):

- `feature`: from `# Token Record: [Feature Name]` header
- `total`: grand total tokens (parse `~Nk` → N × 1000)
- `band`: actual band (S/M/L/XL)
- `estimateBand`: pre-build estimate band
- `phases`: per-phase token map `{ idea, research, build, qa, ... }`
- `over`: boolean, actual band > estimate band

Band midpoints: S=15000, M=50000, L=140000, XL=250000

### 1b. Context load trend — `docs/context-health-report.md`

Extract from the Trend table: `{ date, autoLoad, onDemand, total, status }`

### 1c. Metrics log — `docs/metrics/metrics-log.md`

Parse each section as a separate data array:

**Critic Sessions table → `criticData[]`**
```
{ date, subject, p1, p2, p3, total }
```

**Diagnose Events table → `diagnoseData[]`**
```
{ date, ticket, trigger, rootCause, resolution }
```

**Lookup Activity table → `lookupData[]`**
```
{ date, id, type, found }
```

**Sprint Velocity table → `sprintData[]`**
```
{ sprint, closed, pointsDone, pointsCarried, carryOverPct, goalsMet, goalsTotal, goalPct }
```

### 1d. Tech debt — `docs/tech-debt.md`

Count open items by tier: `{ high: N, medium: N, low: N }`

### 1e. Feature flags — `docs/feature-flags.md`

For each active flag: `{ name, created, removalDate, daysOld, overdue }`

Compute `daysOld` = today − created date.
`overdue` = today > removalDate.

### 1f. Security assessments — `docs/security/assessment-*.md`

For each report file, extract:
```
{ date, critical: N, high: N, medium: N, low: N, resolved: N, total: N }
```
Sort by date ascending.

### 1g. Cost data — `~/.codex/forge/companies/[active_company]/config.md`

Read `token_cost_per_1k` if present. If missing or no company configured, cost panels are omitted.

### 1h. Token efficiency trend

Requires both `sprintData` (for sprint dates) and token data.
For each sprint with a known close date, compute average tokens per completed ticket
by correlating features completed in that sprint period with their `docs/tokens/` totals.
Result: `{ sprint, avgTokensPerTicket }[]` — used in Knowledge Base section.

---

## Phase 2 — Generate `docs/dashboard/index.html`

Write a self-contained HTML file. Inject all parsed data objects directly into the `<script>` block.
Chart.js from CDN. No external dependencies beyond CDN.

### HTML Structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Forge Dashboard — [Project Name]</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4/dist/chart.umd.min.js"></script>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
           background: #f5f5f5; color: #333; }
    header { background: #1a1a2e; color: #fff; padding: 20px 24px; }
    header h1 { font-size: 1.3rem; }
    header .meta { font-size: 0.8rem; color: #aaa; margin-top: 4px; }
    nav.sections { background: #fff; border-bottom: 1px solid #e0e0e0;
                   display: flex; gap: 0; overflow-x: auto; }
    nav.sections a { padding: 12px 20px; text-decoration: none; color: #555;
                     font-size: 0.85rem; white-space: nowrap; border-bottom: 3px solid transparent; }
    nav.sections a:hover, nav.sections a.active { color: #1565c0; border-bottom-color: #1565c0; }
    section { padding: 24px; }
    section h2 { font-size: 1rem; font-weight: 600; color: #444;
                 margin-bottom: 16px; padding-bottom: 8px; border-bottom: 1px solid #e0e0e0; }
    .panels { display: grid; grid-template-columns: repeat(auto-fit, minmax(440px, 1fr)); gap: 20px; }
    .panel { background: #fff; border-radius: 8px; padding: 18px;
             box-shadow: 0 1px 4px rgba(0,0,0,.08); }
    .panel h3 { font-size: 0.9rem; color: #555; margin-bottom: 14px; }
    .panel canvas { max-height: 260px; }
    .panel .empty { font-size: 0.82rem; color: #999; padding: 32px 0; text-align: center; }
    .badge { display: inline-block; padding: 2px 8px; border-radius: 10px;
             font-size: 0.75rem; font-weight: 600; }
    .badge-green { background: #e8f5e9; color: #2e7d32; }
    .badge-amber { background: #fff3e0; color: #e65100; }
    .badge-red   { background: #ffebee; color: #c62828; }
    .exports { padding: 16px 24px; display: flex; gap: 12px; border-top: 1px solid #e0e0e0; }
    .btn { padding: 8px 14px; border: 1px solid #ccc; border-radius: 4px;
           background: #fff; cursor: pointer; font-size: 0.82rem; }
    .btn:hover { background: #f5f5f5; }
  </style>
</head>
<body>

<header>
  <h1>Forge Dashboard — [Project Name]</h1>
  <div class="meta">
    Generated: [YYYY-MM-DD HH:MM] &nbsp;|&nbsp; [PROJ-NNN] &nbsp;|&nbsp;
    Context: <span class="badge badge-[green|amber|red]">[✅ Green / ⚠️ Amber / 🔴 Red]</span>
  </div>
</header>

<nav class="sections">
  <a href="#s-tokens" class="active">Token &amp; Cost</a>
  <a href="#s-quality">Quality</a>
  <a href="#s-velocity">Pipeline &amp; Velocity</a>
  <a href="#s-kb">Knowledge Base</a>
  <a href="#s-health">Health</a>
</nav>

<!-- ═══════════════════════════════════════════════════ -->
<!-- SECTION 1: TOKEN & COST                            -->
<!-- ═══════════════════════════════════════════════════ -->
<section id="s-tokens">
  <h2>Token &amp; Cost</h2>
  <div class="panels">

    <div class="panel">
      <h3>Spend by Feature</h3>
      <!-- Horizontal bar. Y-axis: feature names. X-axis: total tokens.
           Bars coloured by band: S=green, M=blue, L=orange, XL=red.
           Tooltip: "Nk tokens (Band)" -->
      <canvas id="c-spend"></canvas>
    </div>

    <div class="panel">
      <h3>Estimate vs Actual</h3>
      <!-- Grouped bar per feature.
           Bar 1 (blue): estimate band midpoint tokens.
           Bar 2 (green if on/under, red if over): actual tokens.
           Tooltip: "Estimate: ~Nk (Band) / Actual: ~Nk (Band) ✅/⚠️" -->
      <canvas id="c-estimate"></canvas>
    </div>

    <!-- Cost per Story Point panel — only rendered if token_cost_per_1k is set -->
    <div class="panel" id="p-cost">
      <h3>Cost per Story Point</h3>
      <!-- Bar per sprint. Y: cost in $ (tokens ÷ 1000 × token_cost_per_1k ÷ points done).
           Requires sprintData with pointsDone and corresponding token totals.
           If token_cost_per_1k not configured: show empty state with note. -->
      <canvas id="c-cost"></canvas>
    </div>

  </div>
</section>

<!-- ═══════════════════════════════════════════════════ -->
<!-- SECTION 2: QUALITY                                 -->
<!-- ═══════════════════════════════════════════════════ -->
<section id="s-quality">
  <h2>Quality</h2>
  <div class="panels">

    <div class="panel">
      <h3>Critic Findings Trend</h3>
      <!-- Stacked bar per critic session (X-axis: date + subject truncated).
           Stacks: P1 (red), P2 (orange), P3 (yellow).
           Requires criticData. Empty state: "Run $critic to start tracking." -->
      <canvas id="c-critic"></canvas>
    </div>

    <div class="panel">
      <h3>Diagnose Event Rate</h3>
      <!-- Bar per sprint showing: diagnose events in that sprint period.
           Coloured: Explicit (blue), Failed-twice (orange).
           Requires diagnoseData correlated with sprintData.
           Empty state: "No diagnose events recorded yet." -->
      <canvas id="c-diagnose"></canvas>
    </div>

    <div class="panel">
      <h3>Security Findings per Assessment</h3>
      <!-- Stacked bar per assessment date.
           Stacks: Critical (red), High (orange), Medium (yellow), Low (green).
           Line overlay (secondary Y): resolved count.
           Requires securityData. Empty state: "Run $security-assessment to start tracking." -->
      <canvas id="c-security"></canvas>
    </div>

  </div>
</section>

<!-- ═══════════════════════════════════════════════════ -->
<!-- SECTION 3: PIPELINE & VELOCITY                     -->
<!-- ═══════════════════════════════════════════════════ -->
<section id="s-velocity">
  <h2>Pipeline &amp; Velocity</h2>
  <div class="panels">

    <div class="panel">
      <h3>Sprint Velocity</h3>
      <!-- Combined bar + line per sprint.
           Bar (blue): story points done.
           Line (green dashed): rolling 3-sprint average.
           Tooltip includes goal hit %.
           Requires sprintData. Empty state: "Close sprints with $sprint-end to start tracking." -->
      <canvas id="c-velocity"></canvas>
    </div>

    <div class="panel">
      <h3>Carry-Over Rate</h3>
      <!-- Line chart per sprint. Y-axis: carry-over %.
           Colour gradient: <15% green, 15–30% amber, >30% red.
           Annotated threshold lines at 15% (amber) and 30% (red).
           Requires sprintData. -->
      <canvas id="c-carryover"></canvas>
    </div>

    <div class="panel">
      <h3>Context Load Trend</h3>
      <!-- Line chart per context-health run date.
           Three lines: Total (blue fill), Auto-loaded (green dashed), On-demand (orange dashed).
           Threshold lines at 30k (amber) and 60k (red).
           Requires trendData. -->
      <canvas id="c-context"></canvas>
    </div>

  </div>
</section>

<!-- ═══════════════════════════════════════════════════ -->
<!-- SECTION 4: KNOWLEDGE BASE                          -->
<!-- ═══════════════════════════════════════════════════ -->
<section id="s-kb">
  <h2>Knowledge Base</h2>
  <div class="panels">

    <div class="panel">
      <h3>Token Efficiency Trend</h3>
      <!-- Line per sprint: average tokens per completed ticket.
           A declining trend confirms knowledge base ROI.
           Annotate direction: "↓ improving" or "↑ growing" at last point.
           Requires efficiencyData (derived from sprint + token data). -->
      <canvas id="c-efficiency"></canvas>
    </div>

    <div class="panel">
      <h3>Lookup Frequency</h3>
      <!-- Bar per sprint: total lookups. Split: Found (green) / Not Found (grey).
           High "Not Found" rate suggests KB gaps.
           Requires lookupData correlated with sprintData. -->
      <canvas id="c-lookup"></canvas>
    </div>

    <div class="panel">
      <h3>Sprint Goal Hit Rate</h3>
      <!-- Line per sprint: goal hit %.
           Threshold line at 80% (target).
           Coloured: ≥80% green, 50–79% amber, <50% red per point.
           Requires sprintData. -->
      <canvas id="c-goals"></canvas>
    </div>

  </div>
</section>

<!-- ═══════════════════════════════════════════════════ -->
<!-- SECTION 5: HEALTH                                  -->
<!-- ═══════════════════════════════════════════════════ -->
<section id="s-health">
  <h2>Health</h2>
  <div class="panels">

    <div class="panel">
      <h3>Tech Debt Distribution</h3>
      <!-- Donut chart: High (red), Medium (orange), Low (green).
           Centre label: total open items.
           Requires debtData. Empty state: "No tech debt registered — run $tech-debt add." -->
      <canvas id="c-debt"></canvas>
    </div>

    <div class="panel">
      <h3>Feature Flag Ages</h3>
      <!-- Horizontal bar per active flag, sorted by age descending.
           Bar colour: <30 days (green), 30–90 (amber), >90 (red).
           Overdue flags shown with ⚠️ suffix on label.
           Requires flagData. Empty state: "No active feature flags." -->
      <canvas id="c-flags"></canvas>
    </div>

  </div>
</section>

<div class="exports">
  <button class="btn" onclick="exportCSV()">⬇ Export CSV</button>
  <button class="btn" onclick="window.open('summary.html')">✉ Email Summary</button>
</div>

<script>
  // ── Injected data (replace placeholders with parsed values) ──
  const spendData       = [/* { feature, total, band, phases } */];
  const calibrationData = [/* { feature, estimateBand, estimateTokens, actual, actualBand, over } */];
  const trendData       = [/* { date, autoLoad, onDemand, total, status } */];
  const criticData      = [/* { date, subject, p1, p2, p3, total } */];
  const diagnoseData    = [/* { date, ticket, trigger, rootCause, resolution } */];
  const lookupData      = [/* { date, id, type, found } */];
  const sprintData      = [/* { sprint, closed, pointsDone, pointsCarried, carryOverPct, goalsMet, goalsTotal, goalPct } */];
  const securityData    = [/* { date, critical, high, medium, low, resolved, total } */];
  const debtData        = { high: 0, medium: 0, low: 0 };
  const flagData        = [/* { name, daysOld, overdue } */];
  const efficiencyData  = [/* { sprint, avgTokensPerTicket } */];
  const costPerPoint    = [/* { sprint, cost } — empty if token_cost_per_1k not set */];
  const tokenCostPer1k  = null; // set to number if configured

  // ── Colour palettes ──
  const bandColour  = { S: '#2e7d32', M: '#1565c0', L: '#e65100', XL: '#c62828' };
  const severityCol = { critical: '#c62828', high: '#e65100', medium: '#f9a825', low: '#2e7d32' };
  const green = '#2e7d32', amber = '#e65100', red = '#c62828', blue = '#1565c0';

  function colourForPct(pct, invert) {
    // invert=true: lower is better (carry-over, diagnose rate)
    if (invert) return pct < 15 ? green : pct < 30 ? amber : red;
    return pct >= 80 ? green : pct >= 50 ? amber : red;
  }

  function emptyPanel(canvasId, msg) {
    const canvas = document.getElementById(canvasId);
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    canvas.parentElement.querySelector('canvas').style.display = 'none';
    const div = document.createElement('div');
    div.className = 'empty';
    div.textContent = msg;
    canvas.parentElement.appendChild(div);
  }

  // ── Section 1: Token & Cost ──

  if (spendData.length) {
    new Chart(document.getElementById('c-spend'), {
      type: 'bar',
      data: {
        labels: spendData.map(d => d.feature),
        datasets: [{ label: 'Total tokens', data: spendData.map(d => d.total),
          backgroundColor: spendData.map(d => bandColour[d.band] + 'cc'),
          borderColor: spendData.map(d => bandColour[d.band]), borderWidth: 1 }]
      },
      options: { indexAxis: 'y', responsive: true,
        plugins: { legend: { display: false },
          tooltip: { callbacks: { label: ctx =>
            `${(ctx.raw/1000).toFixed(0)}k tokens (${spendData[ctx.dataIndex].band})` }}},
        scales: { x: { title: { display: true, text: 'Tokens' } } } }
    });
  } else { emptyPanel('c-spend', 'No token data yet — run a feature through $build to start tracking.'); }

  if (calibrationData.length) {
    new Chart(document.getElementById('c-estimate'), {
      type: 'bar',
      data: {
        labels: calibrationData.map(d => d.feature),
        datasets: [
          { label: 'Estimate', data: calibrationData.map(d => d.estimateTokens),
            backgroundColor: blue + '99' },
          { label: 'Actual',   data: calibrationData.map(d => d.actual),
            backgroundColor: calibrationData.map(d => (d.over ? red : green) + '99') }
        ]
      },
      options: { responsive: true,
        plugins: { tooltip: { callbacks: { label: ctx => {
          const d = calibrationData[ctx.dataIndex];
          return ctx.datasetIndex === 0
            ? `Estimate: ~${(ctx.raw/1000).toFixed(0)}k (${d.estimateBand})`
            : `Actual: ~${(ctx.raw/1000).toFixed(0)}k (${d.actualBand}) ${d.over ? '⚠️ over' : '✅'}`;
        }}}},
        scales: { y: { title: { display: true, text: 'Tokens' } } } }
    });
  } else { emptyPanel('c-estimate', 'No calibration data yet.'); }

  if (costPerPoint.length && tokenCostPer1k) {
    new Chart(document.getElementById('c-cost'), {
      type: 'bar',
      data: {
        labels: costPerPoint.map(d => d.sprint),
        datasets: [{ label: 'Cost / point ($)', data: costPerPoint.map(d => d.cost),
          backgroundColor: blue + 'cc', borderColor: blue, borderWidth: 1 }]
      },
      options: { responsive: true,
        plugins: { tooltip: { callbacks: { label: ctx => `$${ctx.raw.toFixed(2)} per point` }}},
        scales: { y: { title: { display: true, text: 'USD per story point' } } } }
    });
  } else {
    emptyPanel('c-cost', tokenCostPer1k
      ? 'No sprint point data yet.'
      : 'Set token_cost_per_1k in company config to enable cost tracking.');
  }

  // ── Section 2: Quality ──

  if (criticData.length) {
    new Chart(document.getElementById('c-critic'), {
      type: 'bar',
      data: {
        labels: criticData.map(d => d.date + ' ' + d.subject.slice(0, 20)),
        datasets: [
          { label: 'P1', data: criticData.map(d => d.p1), backgroundColor: red + 'cc' },
          { label: 'P2', data: criticData.map(d => d.p2), backgroundColor: amber + 'cc' },
          { label: 'P3', data: criticData.map(d => d.p3), backgroundColor: '#f9a825cc' }
        ]
      },
      options: { responsive: true, scales: {
        x: { stacked: true }, y: { stacked: true, title: { display: true, text: 'Findings' } }
      }}
    });
  } else { emptyPanel('c-critic', 'Run $critic to start tracking quality findings.'); }

  if (diagnoseData.length && sprintData.length) {
    // Bucket diagnose events by sprint period
    const bySprintD = sprintData.map(s => {
      const inSprint = diagnoseData.filter(d => d.date <= s.closed);
      return { sprint: s.sprint,
        explicit: inSprint.filter(d => d.trigger === 'Explicit').length,
        failed:   inSprint.filter(d => d.trigger === 'Failed twice').length };
    });
    new Chart(document.getElementById('c-diagnose'), {
      type: 'bar',
      data: {
        labels: bySprintD.map(d => d.sprint),
        datasets: [
          { label: 'Explicit', data: bySprintD.map(d => d.explicit), backgroundColor: blue + 'cc' },
          { label: 'Failed twice', data: bySprintD.map(d => d.failed), backgroundColor: amber + 'cc' }
        ]
      },
      options: { responsive: true, scales: {
        x: { stacked: true }, y: { stacked: true, title: { display: true, text: 'Events' } }
      }}
    });
  } else { emptyPanel('c-diagnose', 'No diagnose events recorded yet.'); }

  if (securityData.length) {
    new Chart(document.getElementById('c-security'), {
      type: 'bar',
      data: {
        labels: securityData.map(d => d.date),
        datasets: [
          { label: 'Critical', data: securityData.map(d => d.critical),
            backgroundColor: severityCol.critical + 'cc', stack: 'findings' },
          { label: 'High',     data: securityData.map(d => d.high),
            backgroundColor: severityCol.high + 'cc',     stack: 'findings' },
          { label: 'Medium',   data: securityData.map(d => d.medium),
            backgroundColor: severityCol.medium + 'cc',   stack: 'findings' },
          { label: 'Low',      data: securityData.map(d => d.low),
            backgroundColor: severityCol.low + 'cc',      stack: 'findings' },
          { label: 'Resolved', data: securityData.map(d => d.resolved),
            type: 'line', borderColor: green, fill: false,
            yAxisID: 'y2' }
        ]
      },
      options: { responsive: true, scales: {
        y:  { stacked: true, title: { display: true, text: 'Findings' } },
        y2: { position: 'right', title: { display: true, text: 'Resolved' },
              grid: { drawOnChartArea: false } }
      }}
    });
  } else { emptyPanel('c-security', 'Run $security-assessment to start tracking.'); }

  // ── Section 3: Pipeline & Velocity ──

  if (sprintData.length) {
    // Sprint velocity
    const rolling = sprintData.map((_, i, arr) => {
      const slice = arr.slice(Math.max(0, i-2), i+1);
      return slice.reduce((s, d) => s + d.pointsDone, 0) / slice.length;
    });
    new Chart(document.getElementById('c-velocity'), {
      type: 'bar',
      data: {
        labels: sprintData.map(d => d.sprint),
        datasets: [
          { label: 'Points done', data: sprintData.map(d => d.pointsDone),
            backgroundColor: blue + 'cc' },
          { label: '3-sprint avg', data: rolling,
            type: 'line', borderColor: green, borderDash: [4,4], fill: false, pointRadius: 0 }
        ]
      },
      options: { responsive: true, scales: { y: { title: { display: true, text: 'Story points' } } } }
    });

    // Carry-over rate
    new Chart(document.getElementById('c-carryover'), {
      type: 'line',
      data: {
        labels: sprintData.map(d => d.sprint),
        datasets: [{ label: 'Carry-over %', data: sprintData.map(d => d.carryOverPct),
          borderColor: blue, backgroundColor: blue + '22', fill: true, tension: 0.2,
          pointBackgroundColor: sprintData.map(d => colourForPct(d.carryOverPct, true)) }]
      },
      options: { responsive: true,
        plugins: { annotation: { annotations: {
          amber: { type: 'line', yMin: 15, yMax: 15, borderColor: amber, borderDash: [4,4] },
          red:   { type: 'line', yMin: 30, yMax: 30, borderColor: red,   borderDash: [4,4] }
        }}},
        scales: { y: { title: { display: true, text: '%' }, min: 0, max: 100 } } }
    });

    // Goal hit rate
    new Chart(document.getElementById('c-goals'), {
      type: 'line',
      data: {
        labels: sprintData.map(d => d.sprint),
        datasets: [{ label: 'Goal hit %', data: sprintData.map(d => d.goalPct),
          borderColor: blue, backgroundColor: blue + '22', fill: true, tension: 0.2,
          pointBackgroundColor: sprintData.map(d => colourForPct(d.goalPct, false)) }]
      },
      options: { responsive: true,
        plugins: { annotation: { annotations: {
          target: { type: 'line', yMin: 80, yMax: 80, borderColor: green, borderDash: [4,4],
                    label: { content: '80% target', display: true } }
        }}},
        scales: { y: { title: { display: true, text: '%' }, min: 0, max: 100 } } }
    });
  } else {
    ['c-velocity','c-carryover','c-goals'].forEach(id =>
      emptyPanel(id, 'Close sprints with $sprint-end to start tracking.'));
  }

  if (trendData.length) {
    new Chart(document.getElementById('c-context'), {
      type: 'line',
      data: {
        labels: trendData.map(d => d.date),
        datasets: [
          { label: 'Total', data: trendData.map(d => d.total),
            borderColor: blue, backgroundColor: blue + '22', fill: true, tension: 0.3 },
          { label: 'Auto-loaded', data: trendData.map(d => d.autoLoad),
            borderColor: green, borderDash: [4,4], fill: false },
          { label: 'On-demand',   data: trendData.map(d => d.onDemand),
            borderColor: amber, borderDash: [4,4], fill: false }
        ]
      },
      options: { responsive: true,
        plugins: { annotation: { annotations: {
          amber: { type: 'line', yMin: 30000, yMax: 30000, borderColor: amber, borderDash: [4,4] },
          red:   { type: 'line', yMin: 60000, yMax: 60000, borderColor: red,   borderDash: [4,4] }
        }}},
        scales: { y: { title: { display: true, text: 'Tokens' }, min: 0 } } }
    });
  } else { emptyPanel('c-context', 'Run $context-health to populate the context load trend.'); }

  // ── Section 4: Knowledge Base ──

  if (efficiencyData.length) {
    new Chart(document.getElementById('c-efficiency'), {
      type: 'line',
      data: {
        labels: efficiencyData.map(d => d.sprint),
        datasets: [{ label: 'Avg tokens / ticket',
          data: efficiencyData.map(d => d.avgTokensPerTicket),
          borderColor: blue, backgroundColor: blue + '22', fill: true, tension: 0.3 }]
      },
      options: { responsive: true,
        plugins: { tooltip: { callbacks: { label: ctx =>
          `${(ctx.raw/1000).toFixed(1)}k tokens/ticket` }}},
        scales: { y: { title: { display: true, text: 'Tokens per ticket' } } } }
    });
  } else { emptyPanel('c-efficiency', 'Token efficiency populates after 2+ sprints with token data.'); }

  if (lookupData.length && sprintData.length) {
    const bySprintL = sprintData.map(s => {
      const inSprint = lookupData.filter(d => d.date <= s.closed);
      return { sprint: s.sprint,
        found:    inSprint.filter(d => d.found === 'Yes').length,
        notFound: inSprint.filter(d => d.found === 'No').length };
    });
    new Chart(document.getElementById('c-lookup'), {
      type: 'bar',
      data: {
        labels: bySprintL.map(d => d.sprint),
        datasets: [
          { label: 'Found',     data: bySprintL.map(d => d.found),    backgroundColor: green + 'cc' },
          { label: 'Not found', data: bySprintL.map(d => d.notFound), backgroundColor: '#99999966' }
        ]
      },
      options: { responsive: true, scales: {
        x: { stacked: true }, y: { stacked: true, title: { display: true, text: 'Lookups' } }
      }}
    });
  } else { emptyPanel('c-lookup', 'Lookup activity appears after $lookup usage is recorded.'); }

  // ── Section 5: Health ──

  if (debtData.high + debtData.medium + debtData.low > 0) {
    new Chart(document.getElementById('c-debt'), {
      type: 'doughnut',
      data: {
        labels: ['High', 'Medium', 'Low'],
        datasets: [{ data: [debtData.high, debtData.medium, debtData.low],
          backgroundColor: [red + 'cc', amber + 'cc', green + 'cc'],
          borderColor: [red, amber, green], borderWidth: 1 }]
      },
      options: { responsive: true,
        plugins: { legend: { position: 'bottom' },
          tooltip: { callbacks: { label: ctx =>
            `${ctx.label}: ${ctx.raw} item${ctx.raw !== 1 ? 's' : ''}` }} } }
    });
  } else { emptyPanel('c-debt', 'No tech debt registered — use $tech-debt add to start tracking.'); }

  if (flagData.length) {
    new Chart(document.getElementById('c-flags'), {
      type: 'bar',
      data: {
        labels: flagData.map(d => d.overdue ? '⚠️ ' + d.name : d.name),
        datasets: [{ label: 'Days old', data: flagData.map(d => d.daysOld),
          backgroundColor: flagData.map(d =>
            d.overdue ? red + 'cc' : d.daysOld > 90 ? red + '99' : d.daysOld > 30 ? amber + 'cc' : green + 'cc'),
          borderColor: flagData.map(d => d.overdue ? red : d.daysOld > 30 ? amber : green),
          borderWidth: 1 }]
      },
      options: { indexAxis: 'y', responsive: true,
        plugins: { legend: { display: false },
          tooltip: { callbacks: { label: ctx =>
            `${ctx.raw} days old${flagData[ctx.dataIndex].overdue ? ' — OVERDUE' : ''}` }}},
        scales: { x: { title: { display: true, text: 'Days since created' } } } }
    });
  } else { emptyPanel('c-flags', 'No active feature flags.'); }

  // ── Section nav scroll spy ──
  const sections = document.querySelectorAll('section[id]');
  const navLinks  = document.querySelectorAll('nav.sections a');
  window.addEventListener('scroll', () => {
    let current = '';
    sections.forEach(s => { if (window.scrollY >= s.offsetTop - 80) current = s.id; });
    navLinks.forEach(a => a.classList.toggle('active', a.getAttribute('href') === '#' + current));
  });

  // ── CSV export ──
  function exportCSV() {
    const rows = [
      ['Section','Metric','Label','Value'],
      ...spendData.map(d => ['Tokens','Spend',d.feature, d.total]),
      ...calibrationData.map(d => ['Tokens','Calibration',d.feature,
        `Est:${d.estimateBand} Act:${d.actualBand} ${d.over?'Over':'On/Under'}`]),
      ...sprintData.map(d => ['Velocity','Sprint',d.sprint,
        `Done:${d.pointsDone} Carried:${d.pointsCarried} CarryOver:${d.carryOverPct}% Goals:${d.goalPct}%`]),
      ...criticData.map(d => ['Quality','Critic',d.date + ' ' + d.subject,
        `P1:${d.p1} P2:${d.p2} P3:${d.p3}`])
    ];
    const csv = rows.map(r => r.map(v => `"${v}"`).join(',')).join('\n');
    const a = document.createElement('a');
    a.href = 'data:text/csv,' + encodeURIComponent(csv);
    a.download = 'forge-dashboard.csv';
    a.click();
  }
</script>
</body>
</html>
```

---

## Phase 3 — Generate `docs/dashboard/summary.html`

Email-friendly version — tables only, no JavaScript, inline styles, renders in any email client.
Include one table per section with current-state summary (no trend charts).

**Sections to include:**
1. Token Spend — feature, total, band, calibration
2. Quality — last 3 critic sessions (P1/P2/P3), latest security assessment summary
3. Sprint Velocity — last 5 sprints (done, carried, carry-over %, goal %)
4. Knowledge Base — token efficiency (last sprint vs first sprint), lookup found/not-found ratio
5. Health — tech debt tier counts, overdue feature flags count

---

## Phase 4 — Generate `docs/dashboard/data.csv`

One CSV per logical data type, separated by blank rows and section headers.

```csv
# Token Spend
feature,total_tokens,band,estimate_band,calibration
[Feature],85000,L,M,Over

# Sprint Velocity
sprint,closed,points_done,points_carried,carry_over_pct,goals_met,goals_total,goal_pct
Sprint-13,2026-05-24,21,3,13,2,3,67

# Critic Sessions
date,subject,p1,p2,p3,total
2026-05-24,[subject],2,4,3,9

# Security Assessments
date,critical,high,medium,low,resolved,total
2026-05-24,0,3,5,2,4,10
```

---

## Phase 5 — Open Dashboard

After writing all three files:

```bash
open docs/dashboard/index.html        # macOS
xdg-open docs/dashboard/index.html   # Linux
start docs/dashboard/index.html       # Windows
```

Confirm to the user:
```
✅ Dashboard generated → docs/dashboard/index.html
   Sections: Token & Cost | Quality | Pipeline & Velocity | Knowledge Base | Health
   Exports: summary.html (email) | data.csv

   Data coverage:
   ✅ Token spend (N features)        ✅ Context load (N runs)
   ✅ Sprint velocity (N sprints)     ⚠️ Critic trend (no data yet — run $critic)
   ✅ Tech debt (N items)             ⚠️ Security (no assessments found)
   [full coverage list based on what was found]
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No data at all | Generate dashboard with all empty states, note "Fresh project — data populates as you use Forge skills." |
| `docs/metrics/metrics-log.md` missing | Quality, Velocity, KB panels show empty state with note |
| No context-health-report.md | Context Load panel empty with note |
| `docs/dashboard/` doesn't exist | Create it before writing |
| CDN unavailable (offline) | Note in confirmation: "Chart.js loaded from CDN — charts won't render offline." |

---

## Rules

- Never modify source files — read only
- Always overwrite previous dashboard files — they are generated artifacts, not source
- Sections with no data show informative empty states, not errors
- The cost per story point panel is omitted entirely (not shown as empty) if `token_cost_per_1k` is not configured
- Chart.js annotation plugin requires: `https://cdn.jsdelivr.net/npm/chartjs-plugin-annotation@3` — add to `<head>` alongside Chart.js
