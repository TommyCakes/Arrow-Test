# The Log — static site

A minimal, framework-free log/blog. Pure **HTML + CSS + JS**. No build step,
no subscription, no backend. Entries live in a single JSON file.

```
log-site/
├── index.html      # page structure
├── styles.css      # all styling (light + dark)
├── app.js          # loads & renders entries.json
├── entries.json    # ← your content lives here
└── README.md
```

## Adding a new entry

Open `entries.json` and add a block at the top of the list:

```json
{
  "date": "2026-08-20",
  "title": "Your headline",
  "body": "Write anything here. Blank lines start new paragraphs.\n\nYou can use **bold**, *italic*, and [links](https://example.com).",
  "tags": ["notes", "site"]
}
```

- `date` — use `YYYY-MM-DD`. Entries sort newest-first automatically, so order in the file doesn't matter.
- `tags` — optional; they become clickable filter chips.
- Commit and push — the live site updates within a minute.

## Previewing locally

Because the page loads `entries.json` with `fetch()`, opening `index.html`
directly (a `file://` URL) is blocked by browsers. Run a tiny local server:

```bash
cd log-site
python3 -m http.server 8000
# then open http://localhost:8000
```

## Publishing free on GitHub Pages

1. Push this repo to GitHub (already done if you're reading this there).
2. Repo **Settings → Pages**.
3. Under **Build and deployment**, set **Source: Deploy from a branch**.
4. Pick your branch and folder **`/log-site`** (or move these files to the repo root and pick `/`), then **Save**.
5. Wait ~1 minute — your site is live at `https://<username>.github.io/<repo>/`.

### Custom domain (optional, ~£10/yr for the domain only)

In **Settings → Pages → Custom domain**, enter your domain and follow the DNS
instructions. Hosting stays free; you only pay a registrar for the domain.

## Customising

- **Colours / fonts:** the design tokens at the top of `styles.css` (the
  `:root { … }` block) control everything — accent colour, background, radius.
- **Title & tagline:** edit the `.brand` block in `index.html`.
- **Font:** currently uses Raleway (loaded from Google Fonts). Swap the
  `<link>` in `index.html` and the `--serif` token in `styles.css` to change it.
