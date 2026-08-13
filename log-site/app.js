/* ------------------------------------------------------------------
   Green Farm Logs — vanilla JS.
   - Renders a searchable/filterable log timeline from entries.json
   - Light/dark theme toggle
   - AJAX submission for the Netlify Forms (booking + contact)
   - Optional Stripe Payment Link wiring for the deposit button
   No frameworks, no build step.
------------------------------------------------------------------- */
(function () {
  "use strict";

  const root = document.documentElement;

  /* ---------- Theme ---------- */
  (function initTheme() {
    const saved = localStorage.getItem("gfl-theme");
    if (saved === "dark" || saved === "light") root.setAttribute("data-theme", saved);
    const toggle = document.getElementById("theme-toggle");
    toggle && toggle.addEventListener("click", () => {
      const isDark =
        root.getAttribute("data-theme") === "dark" ||
        (!root.hasAttribute("data-theme") &&
          window.matchMedia("(prefers-color-scheme: dark)").matches);
      const next = isDark ? "light" : "dark";
      root.setAttribute("data-theme", next);
      localStorage.setItem("gfl-theme", next);
    });
  })();

  /* ---------- Footer year ---------- */
  const yearEl = document.getElementById("year");
  if (yearEl) yearEl.textContent = new Date().getFullYear();

  /* =================================================================
     THE LOG
  ================================================================= */
  const logEls = {
    list:    document.getElementById("entries"),
    empty:   document.getElementById("empty"),
    search:  document.getElementById("search"),
    filters: document.getElementById("tag-filters"),
  };
  let allEntries = [];
  let activeTag = null;
  let query = "";

  function formatDate(iso) {
    const d = new Date(iso + "T00:00:00");
    if (isNaN(d)) return iso;
    return d.toLocaleDateString(undefined, { year: "numeric", month: "short", day: "numeric" });
  }
  function escapeHtml(s) {
    return String(s).replace(/[&<>"']/g, (c) => ({
      "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;",
    }[c]));
  }
  // Escape first, then allow **bold**, *italic*, [text](url); blank lines = paragraphs.
  function renderBody(text) {
    return String(text || "")
      .split(/\n\s*\n/)
      .map((para) => {
        let html = escapeHtml(para.trim());
        html = html.replace(
          /\[([^\]]+)\]\((https?:\/\/[^\s)]+)\)/g,
          '<a href="$2" target="_blank" rel="noopener noreferrer">$1</a>'
        );
        html = html.replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>");
        html = html.replace(/(^|[^*])\*([^*]+)\*/g, "$1<em>$2</em>");
        return "<p>" + html.replace(/\n/g, "<br>") + "</p>";
      })
      .join("");
  }

  function matchesFilters(entry) {
    if (activeTag && !(entry.tags || []).includes(activeTag)) return false;
    if (query) {
      const hay = [
        entry.title, entry.body, entry.field, entry.weather, (entry.tags || []).join(" "),
      ].join(" ").toLowerCase();
      if (!hay.includes(query)) return false;
    }
    return true;
  }

  function render() {
    if (!logEls.list) return;
    const visible = allEntries.filter(matchesFilters);
    logEls.list.innerHTML = "";
    if (logEls.empty) logEls.empty.hidden = visible.length !== 0;

    for (const entry of visible) {
      const li = document.createElement("li");
      li.className = "entry";

      const badges = [];
      if (entry.field)   badges.push(`<span class="entry-badge">📍 ${escapeHtml(entry.field)}</span>`);
      if (entry.weather) badges.push(`<span class="entry-badge">⛅ ${escapeHtml(entry.weather)}</span>`);

      const tags = (entry.tags || [])
        .map((t) => `<span class="entry-tag">${escapeHtml(t)}</span>`).join("");

      li.innerHTML = `
        <article class="entry-card">
          <div class="entry-meta">
            <time class="entry-date" datetime="${escapeHtml(entry.date)}">${formatDate(entry.date)}</time>
            ${badges.join("")}
          </div>
          <h3 class="entry-title">${escapeHtml(entry.title)}</h3>
          <div class="entry-body">${renderBody(entry.body)}</div>
          ${tags ? `<div class="entry-tags">${tags}</div>` : ""}
        </article>`;
      logEls.list.appendChild(li);
    }
  }

  function buildTagFilters() {
    if (!logEls.filters) return;
    const counts = {};
    for (const e of allEntries) for (const t of e.tags || []) counts[t] = (counts[t] || 0) + 1;
    const tags = Object.keys(counts).sort((a, b) => counts[b] - counts[a]);

    logEls.filters.innerHTML = "";
    for (const tag of tags) {
      const btn = document.createElement("button");
      btn.type = "button";
      btn.className = "tag-chip";
      btn.textContent = tag;
      btn.setAttribute("aria-pressed", "false");
      btn.addEventListener("click", () => {
        activeTag = activeTag === tag ? null : tag;
        for (const chip of logEls.filters.children) {
          chip.setAttribute("aria-pressed", chip.textContent === activeTag ? "true" : "false");
        }
        render();
      });
      logEls.filters.appendChild(btn);
    }
  }

  logEls.search && logEls.search.addEventListener("input", (e) => {
    query = e.target.value.trim().toLowerCase();
    render();
  });

  async function loadEntries() {
    if (!logEls.list) return;
    try {
      const res = await fetch("entries.json", { cache: "no-cache" });
      if (!res.ok) throw new Error("HTTP " + res.status);
      const data = await res.json();
      allEntries = (Array.isArray(data) ? data : data.entries || [])
        .sort((a, b) => (a.date < b.date ? 1 : a.date > b.date ? -1 : 0));
    } catch (err) {
      logEls.list.innerHTML =
        '<li class="entry"><div class="entry-card"><p class="entry-body">' +
        "Couldn’t load entries. If you’re opening this file directly, run it through " +
        "a local server (see README) — browsers block fetch() on file:// URLs.</p></div></li>";
      console.error(err);
      return;
    }
    buildTagFilters();
    render();
  }

  /* =================================================================
     NETLIFY FORMS (AJAX submission with inline status)
  ================================================================= */
  function encode(data) {
    return Object.keys(data)
      .map((k) => encodeURIComponent(k) + "=" + encodeURIComponent(data[k]))
      .join("&");
  }

  function wireForm(formId, statusId, successMsg) {
    const form = document.getElementById(formId);
    const status = document.getElementById(statusId);
    if (!form) return;

    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      const btn = form.querySelector('button[type="submit"]');
      const original = btn ? btn.textContent : "";
      if (btn) { btn.disabled = true; btn.textContent = "Sending…"; }

      const data = {};
      new FormData(form).forEach((v, k) => { data[k] = v; });

      try {
        const res = await fetch("/", {
          method: "POST",
          headers: { "Content-Type": "application/x-www-form-urlencoded" },
          body: encode(data),
        });
        if (!res.ok) throw new Error("HTTP " + res.status);
        form.reset();
        if (status) { status.hidden = false; status.className = "form-status ok"; status.textContent = successMsg; }
      } catch (err) {
        if (status) {
          status.hidden = false;
          status.className = "form-status err";
          status.textContent =
            "Sorry — something went wrong. This form only works once the site is " +
            "deployed on Netlify. Please email us instead.";
        }
        console.error(err);
      } finally {
        if (btn) { btn.disabled = false; btn.textContent = original; }
      }
    });
  }

  wireForm("booking-form", "booking-status",
    "Thanks! Your booking request is in — we’ll confirm by email shortly.");
  wireForm("contact-form", "contact-status",
    "Thanks for getting in touch — we’ll reply soon.");

  /* =================================================================
     STRIPE DEPOSIT BUTTON (optional)
     Paste your Stripe Payment Link into data-stripe-link in index.html
     (or set STRIPE_DEPOSIT_LINK below) and the button activates itself.
  ================================================================= */
  (function initDeposit() {
    const STRIPE_DEPOSIT_LINK = ""; // e.g. "https://buy.stripe.com/xxxxxxxx"
    const btn = document.getElementById("deposit-btn");
    if (!btn) return;
    const link = STRIPE_DEPOSIT_LINK || btn.getAttribute("data-stripe-link");
    if (link) {
      btn.href = link;
      btn.removeAttribute("aria-disabled");
      btn.textContent = "Pay deposit";
    } else {
      btn.addEventListener("click", (e) => e.preventDefault());
    }
  })();

  /* ---------- Boot ---------- */
  loadEntries();
})();
