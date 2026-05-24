---
name: dashboard-tokens
description: Generate a token usage dashboard as a static HTML file with Chart.js visualisations. Three panels — spend per feature, context load trend, estimate vs actual accuracy. Exports to email-friendly HTML summary and CSV. Use when user runs /dashboard-tokens, or called automatically at the end of /context-health.
---

# Dashboard Tokens

Generate a self-contained HTML dashboard visualising token usage across the current project.
Writes to `docs/dashboard/`. Opens `index.html` in the browser after generation.

---

## Output Files

```
docs/dashboard/
  index.html     ← main dashboard (Chart.js, three panels)
  summary.html   ← email-friendly tables, no JS dependencies
  data.csv       ← raw data export
```

---

## Data Sources

### 1. Token spend — `docs/tokens/[feature].md`

For each file in `docs/tokens/` (excluding `_template.md`):

Extract from the **Feature Summary** table:
- Feature name: from `# Token Record: [Feature Name]` header
- Per-phase totals: Total column (parse `~Nk` → N × 1000)
- Grand total: `**Total**` row
- Pre-build estimate band: `**Pre-build estimate:** S/M/L/XL`
- Actual band: `**Actual:** ~Nk (S/M/L/XL)`
- Calibration: `**Calibration:**` line

Band midpoints (for estimate vs actual chart):
| Band | Midpoint |
|------|---------|
| S | 15,000 |
| M | 50,000 |
| L | 140,000 |
| XL | 250,000 |

### 2. Context load trend — `docs/context-health-report.md`

Extract from the **Trend** table:
- Date, Auto-load tokens, On-demand tokens, Total, Status (Green/Amber/Red)

If the trend table has only one row (first run), render a single point rather than a line.

### 3. Project metadata — `~/.claude/registry.md`

Extract project name and PROJ-NNN for the dashboard title.

---

## Phase 1 — Parse Data

Read all source files silently. Build three data objects:

```javascript
// Panel 1: Spend per feature
const spendData = [
  { feature: "Feature Name", total: 85000, band: "M", phases: { idea: 5000, build: 60000, ... } },
  ...
];

// Panel 2: Context load trend
const trendData = [
  { date: "2026-05-24", autoLoad: 5850, onDemand: 18000, total: 23850, status: "green" },
  ...
];

// Panel 3: Estimate vs actual
const calibrationData = [
  { feature: "Feature Name", estimateBand: "M", estimateTokens: 50000, actual: 85000, actualBand: "L", over: true },
  ...
];
```

---

## Phase 2 — Generate `docs/dashboard/index.html`

Write a self-contained HTML file using the template below. Inject the parsed data objects
directly into the `<script>` block. Use Chart.js from CDN — no local dependencies.

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Token Dashboard — [Project Name]</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4/dist/chart.umd.min.js"></script>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
           background: #f5f5f5; color: #333; padding: 24px; }
    h1 { font-size: 1.4rem; margin-bottom: 4px; }
    .meta { font-size: 0.85rem; color: #666; margin-bottom: 24px; }
    .panels { display: grid; grid-template-columns: repeat(auto-fit, minmax(480px, 1fr));
              gap: 24px; }
    .panel { background: #fff; border-radius: 8px; padding: 20px;
             box-shadow: 0 1px 4px rgba(0,0,0,.1); }
    .panel h2 { font-size: 1rem; margin-bottom: 16px; color: #444; }
    .panel canvas { max-height: 300px; }
    .exports { margin-top: 24px; display: flex; gap: 12px; }
    .btn { padding: 8px 16px; border: 1px solid #ccc; border-radius: 4px;
           background: #fff; cursor: pointer; font-size: 0.85rem; }
    .btn:hover { background: #f0f0f0; }
    .status-green { color: #2e7d32; font-weight: 600; }
    .status-amber { color: #e65100; font-weight: 600; }
    .status-red   { color: #c62828; font-weight: 600; }
  </style>
</head>
<body>
  <h1>Token Usage Dashboard — [Project Name]</h1>
  <p class="meta">Generated: [YYYY-MM-DD HH:MM] &nbsp;|&nbsp; Project: [PROJ-NNN]
    &nbsp;|&nbsp; Session budget status:
    <span class="status-[green|amber|red]">[✅ Green / ⚠️ Amber / 🔴 Red]</span>
  </p>

  <div class="panels">

    <!-- Panel 1: Spend per Feature -->
    <div class="panel">
      <h2>Token Spend by Feature</h2>
      <canvas id="spendChart"></canvas>
    </div>

    <!-- Panel 2: Context Load Trend -->
    <div class="panel">
      <h2>Context Load Trend (weekly)</h2>
      <canvas id="trendChart"></canvas>
    </div>

    <!-- Panel 3: Estimate vs Actual -->
    <div class="panel">
      <h2>Estimate vs Actual</h2>
      <canvas id="estimateChart"></canvas>
    </div>

  </div>

  <div class="exports">
    <button class="btn" onclick="exportCSV()">⬇ Export CSV</button>
    <button class="btn" onclick="window.open('summary.html')">✉ Email Summary</button>
  </div>

  <script>
    // --- Injected data ---
    const spendData = [/* parsed spend objects */];
    const trendData = [/* parsed trend objects */];
    const calibrationData = [/* parsed calibration objects */];

    // Band colours
    const bandColour = { S: '#2e7d32', M: '#1565c0', L: '#e65100', XL: '#c62828' };
    const statusColour = { green: '#2e7d32', amber: '#e65100', red: '#c62828' };

    // Panel 1 — Spend per Feature (horizontal bar, coloured by band)
    new Chart(document.getElementById('spendChart'), {
      type: 'bar',
      data: {
        labels: spendData.map(d => d.feature),
        datasets: [{
          label: 'Total tokens',
          data: spendData.map(d => d.total),
          backgroundColor: spendData.map(d => bandColour[d.band] + 'cc'),
          borderColor: spendData.map(d => bandColour[d.band]),
          borderWidth: 1
        }]
      },
      options: {
        indexAxis: 'y',
        responsive: true,
        plugins: {
          legend: { display: false },
          tooltip: {
            callbacks: {
              label: ctx => `${(ctx.raw/1000).toFixed(0)}k tokens (${spendData[ctx.dataIndex].band})`
            }
          }
        },
        scales: { x: { title: { display: true, text: 'Tokens' } } }
      }
    });

    // Panel 2 — Context Load Trend (line with threshold bands)
    new Chart(document.getElementById('trendChart'), {
      type: 'line',
      data: {
        labels: trendData.map(d => d.date),
        datasets: [
          {
            label: 'Total session load',
            data: trendData.map(d => d.total),
            borderColor: '#1565c0', backgroundColor: '#1565c022',
            fill: true, tension: 0.3
          },
          {
            label: 'Auto-loaded',
            data: trendData.map(d => d.autoLoad),
            borderColor: '#2e7d32', borderDash: [4,4], fill: false
          },
          {
            label: 'On-demand',
            data: trendData.map(d => d.onDemand),
            borderColor: '#e65100', borderDash: [4,4], fill: false
          }
        ]
      },
      options: {
        responsive: true,
        plugins: {
          annotation: {
            annotations: {
              amber: { type: 'line', yMin: 30000, yMax: 30000,
                        borderColor: '#e65100', borderDash: [6,3],
                        label: { content: 'Amber (30k)', display: true } },
              red:   { type: 'line', yMin: 60000, yMax: 60000,
                        borderColor: '#c62828', borderDash: [6,3],
                        label: { content: 'Red (60k)', display: true } }
            }
          }
        },
        scales: { y: { title: { display: true, text: 'Tokens' }, min: 0 } }
      }
    });

    // Panel 3 — Estimate vs Actual (grouped bar)
    new Chart(document.getElementById('estimateChart'), {
      type: 'bar',
      data: {
        labels: calibrationData.map(d => d.feature),
        datasets: [
          {
            label: 'Estimate (band midpoint)',
            data: calibrationData.map(d => d.estimateTokens),
            backgroundColor: '#1565c099'
          },
          {
            label: 'Actual',
            data: calibrationData.map(d => d.actual),
            backgroundColor: calibrationData.map(d =>
              d.over ? '#c6282899' : '#2e7d3299')
          }
        ]
      },
      options: {
        responsive: true,
        plugins: {
          tooltip: {
            callbacks: {
              label: ctx => {
                const val = (ctx.raw/1000).toFixed(0);
                const d = calibrationData[ctx.dataIndex];
                return ctx.datasetIndex === 0
                  ? `Estimate: ~${val}k (${d.estimateBand})`
                  : `Actual: ~${val}k (${d.actualBand}) ${d.over ? '⚠️ over' : '✅'}`;
              }
            }
          }
        },
        scales: { y: { title: { display: true, text: 'Tokens' } } }
      }
    });

    // CSV export
    function exportCSV() {
      const rows = [
        ['Feature','Total Tokens','Band','Estimate Band','Calibration'],
        ...spendData.map((d,i) => [
          d.feature, d.total, d.band,
          calibrationData[i]?.estimateBand ?? '—',
          calibrationData[i]?.over ? 'Over' : 'On/Under'
        ])
      ];
      const csv = rows.map(r => r.join(',')).join('\n');
      const a = document.createElement('a');
      a.href = 'data:text/csv,' + encodeURIComponent(csv);
      a.download = 'token-data.csv';
      a.click();
    }
  </script>
</body>
</html>
```

---

## Phase 3 — Generate `docs/dashboard/summary.html`

Email-friendly version — tables only, no JavaScript, inline styles, renders in any email client.

```html
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Token Summary</title></head>
<body style="font-family:Arial,sans-serif;max-width:600px;margin:0 auto;padding:16px;color:#333">
  <h2 style="font-size:1.1rem">Token Usage Summary — [Project Name]</h2>
  <p style="color:#666;font-size:0.85rem">Generated [YYYY-MM-DD] | [PROJ-NNN]</p>

  <h3 style="font-size:0.95rem;margin-top:16px">Spend by Feature</h3>
  <table style="width:100%;border-collapse:collapse;font-size:0.85rem">
    <tr style="background:#f0f0f0">
      <th style="text-align:left;padding:6px">Feature</th>
      <th style="padding:6px">Total</th>
      <th style="padding:6px">Band</th>
      <th style="padding:6px">Calibration</th>
    </tr>
    <!-- one row per feature -->
  </table>

  <h3 style="font-size:0.95rem;margin-top:16px">Context Load (latest)</h3>
  <table style="width:100%;border-collapse:collapse;font-size:0.85rem">
    <tr style="background:#f0f0f0">
      <th style="text-align:left;padding:6px">Layer</th>
      <th style="padding:6px">Tokens</th>
      <th style="padding:6px">% of 100k</th>
    </tr>
    <!-- auto-load, on-demand, total rows -->
  </table>
</body>
</html>
```

---

## Phase 4 — Generate `docs/dashboard/data.csv`

```csv
feature,total_tokens,band,estimate_band,calibration,phase_idea,phase_build,phase_qa
[Feature Name],85000,L,M,Over,5000,60000,8000
```

---

## Phase 5 — Open Dashboard

After writing all three files, open `docs/dashboard/index.html` in the default browser:

```bash
open docs/dashboard/index.html        # macOS
xdg-open docs/dashboard/index.html   # Linux
start docs/dashboard/index.html       # Windows
```

Confirm to the user:
```
✅ Dashboard generated → docs/dashboard/index.html
   Export options: summary.html (email) | data.csv
   Next scheduled context health: [date + 7 days]
```

---

## Failure Modes

| Condition | Behaviour |
|-----------|-----------|
| No token files found | Generate dashboard with empty panels, note "No token data yet — run a feature through /build to start tracking" |
| No context-health-report.md | Omit trend panel, note "Run /context-health to populate the trend chart" |
| Single context-health data point | Render trend panel as a single point with label "First check — run weekly to build trend" |
| docs/dashboard/ doesn't exist | Create it before writing |

---

## Rules

- Never modify source files — read only from `docs/tokens/`, `docs/context-health-report.md`, registry
- Always overwrite previous dashboard files — they are generated artifacts, not source
- `data.csv` downloads client-side via JS — do not write it to disk separately unless the user explicitly saves it
- Chart.js loaded from CDN — note if the user is offline and the charts won't render
