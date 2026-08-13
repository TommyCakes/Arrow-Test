# Green Farm Logs — website

A minimal, framework-free site for the farm. Pure **HTML + CSS + JS**, plus
**Netlify Forms** for the booking & contact forms, and a spot ready for
**Stripe** deposit payments when you want them.

```
log-site/
├── index.html      # page structure (hero, log, booking form, contact)
├── styles.css      # all styling — light + dark, farm palette
├── app.js          # renders the log + handles the forms
├── entries.json    # ← your log entries live here
├── netlify.toml    # Netlify deploy config
└── README.md
```

## Adding a log entry

Open `entries.json` and add a block. Newest date sorts to the top automatically:

```json
{
  "date": "2026-08-20",
  "title": "Wheat harvest started",
  "field": "Long Acre",
  "weather": "Dry, 27°C",
  "body": "First pass done. Moisture looking good.\n\nUse **bold**, *italic*, and [links](https://example.com). Blank lines make new paragraphs.",
  "tags": ["harvest", "wheat"]
}
```

- `field` and `weather` are optional — they show as little badges on the entry.
- `tags` become clickable filter chips.

## Previewing locally

`index.html` loads `entries.json` with `fetch()`, which browsers block on
`file://`. Run a tiny local server:

```bash
cd log-site
python3 -m http.server 8000   # then open http://localhost:8000
```

> Note: the **forms** only work once the site is live on Netlify — locally
> they'll show a friendly "deploy first" message. That's expected.

## Deploying free on Netlify

1. Push this repo to GitHub (done if you're reading this there).
2. Go to [app.netlify.com](https://app.netlify.com) → **Add new site → Import an existing project** → pick this repo.
3. Netlify reads `netlify.toml` automatically:
   - **Publish directory:** `log-site`
   - **Build command:** *(none)*
4. Deploy. Your site is live at `https://<name>.netlify.app` — rename it in **Site settings**, and add a custom domain there for ~£10/yr (hosting stays free).

### Where form submissions go

Both forms (**booking** and **contact**) appear in your Netlify dashboard under
**Forms**. Turn on email notifications in **Site settings → Forms → Form
notifications** so each submission lands in your inbox. Free tier: 100
submissions/month.

## Adding Stripe deposits (when you're ready)

Two options, easiest first:

### Option A — Payment Link (no code, fixed amount)

Best for a set deposit like "£20 to hold a group booking".

1. In the [Stripe Dashboard](https://dashboard.stripe.com) → **Payment Links** → create a link for your deposit amount.
2. Copy the link (looks like `https://buy.stripe.com/…`).
3. In `index.html`, find the deposit button and paste it into `data-stripe-link`:
   ```html
   <a class="btn btn-ghost" id="deposit-btn" data-stripe-link="https://buy.stripe.com/XXXX" ...>
   ```
   (or set `STRIPE_DEPOSIT_LINK` near the bottom of `app.js`).
4. The button activates itself — no keys, nothing secret in the site. ✅

### Option B — Stripe Checkout (dynamic amounts)

For variable totals (e.g. deposit scales with party size) you need a tiny
serverless function so your **secret key stays on the server**:

1. Uncomment the `[functions]` block in `netlify.toml`.
2. Create `log-site/netlify/functions/create-checkout.js` that calls
   `stripe.checkout.sessions.create(...)` with your secret key.
3. Add the secret key in **Netlify → Site settings → Environment variables**
   (never commit it).
4. Point the button at that function instead of a Payment Link.

Ask and I can scaffold Option B for you.

## Customising

- **Colours / fonts:** the `:root { … }` tokens at the top of `styles.css`
  (accent green, backgrounds, radius). Dark theme mirrors them below.
- **Title / hero text:** the `.brand` and `.hero` blocks in `index.html`.
- **Contact details:** the three `.contact-card` blocks — add your real email,
  address and opening hours.
- **Font:** currently Raleway via Google Fonts — swap the `<link>` in
  `index.html` and the `--head` token in `styles.css` to change it.
