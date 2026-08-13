/* ------------------------------------------------------------------
   The Log — tiny vanilla-JS renderer.
   Loads entries from entries.json and renders a searchable, filterable
   timeline. No frameworks, no build step.
------------------------------------------------------------------- */
(function () {
  "use strict";

  const els = {
    list:    document.getElementById("entries"),
    empty:   document.getElementById("empty"),
    search:  document.getElementById("search"),
    filters: document.getElementById("tag-filters"),
    toggle:  document.getElementById("theme-toggle"),
    root:    document.documentElement,
  };

  let allEntries = [];
  let activeTag = null;
  let query = "";

  /* ---------- Theme ---------- */
  function initTheme() {
    const saved = localStorage.getItem("log-theme");
    if (saved === "dark" || saved === "light") {
      els.root.setAttribute("data-theme", saved);
    }
    els.toggle.addEventListener("click", () => {
      const isDark =
        els.root.getAttribute("data-theme") === "dark" ||
        (!els.root.hasAttribute("data-theme") &&
          window.matchMedia("(prefers-color-scheme: dark)").matches);
      const next = isDark ? "light" : "dark";
      els.root.setAttribute("data-theme", next);
      localStorage.setItem("log-theme", next);
    });
  }

  /* ---------- Helpers ---------- */
  function formatDate(iso) {
    const d = new Date(iso + "T00:00:00");
    if (isNaN(d)) return iso;
    return d.toLocaleDateString(undefined, {
      year: "numeric", month: "short", day: "numeric",
    });
  }

  // Minimal, safe formatting: escape HTML, then allow **bold**, *italic*,
  // [text](url) links, and split paragraphs on blank lines.
  function escapeHtml(s) {
    return s.replace(/[&<>"']/g, (c) => ({
      "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;",
    }[c]));
  }
  function renderBody(text) {
    return text
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

  /* ---------- Rendering ---------- */
  function matchesFilters(entry) {
    if (activeTag && !(entry.tags || []).includes(activeTag)) return false;
    if (query) {
      const hay = (
        entry.title + " " + entry.body + " " + (entry.tags || []).join(" ")
      ).toLowerCase();
      if (!hay.includes(query)) return false;
    }
    return true;
  }

  function render() {
    const visible = allEntries.filter(matchesFilters);
    els.list.innerHTML = "";
    els.empty.hidden = visible.length !== 0;

    for (const entry of visible) {
      const li = document.createElement("li");
      li.className = "entry";

      const tags = (entry.tags || [])
        .map((t) => `<span class="entry-tag">${escapeHtml(t)}</span>`)
        .join("");

      li.innerHTML = `
        <article class="entry-card">
          <div class="entry-meta">
            <time class="entry-date" datetime="${escapeHtml(entry.date)}">
              ${formatDate(entry.date)}
            </time>
          </div>
          <h2 class="entry-title">${escapeHtml(entry.title)}</h2>
          <div class="entry-body">${renderBody(entry.body || "")}</div>
          ${tags ? `<div class="entry-tags">${tags}</div>` : ""}
        </article>`;
      els.list.appendChild(li);
    }
  }

  function buildTagFilters() {
    const counts = {};
    for (const e of allEntries) {
      for (const t of e.tags || []) counts[t] = (counts[t] || 0) + 1;
    }
    const tags = Object.keys(counts).sort((a, b) => counts[b] - counts[a]);

    els.filters.innerHTML = "";
    for (const tag of tags) {
      const btn = document.createElement("button");
      btn.type = "button";
      btn.className = "tag-chip";
      btn.textContent = tag;
      btn.setAttribute("aria-pressed", "false");
      btn.addEventListener("click", () => {
        activeTag = activeTag === tag ? null : tag;
        for (const chip of els.filters.children) {
          chip.setAttribute(
            "aria-pressed",
            chip.textContent === activeTag ? "true" : "false"
          );
        }
        render();
      });
      els.filters.appendChild(btn);
    }
  }

  function initSearch() {
    els.search.addEventListener("input", (e) => {
      query = e.target.value.trim().toLowerCase();
      render();
    });
  }

  /* ---------- Boot ---------- */
  function sortByDateDesc(a, b) {
    return (a.date < b.date ? 1 : a.date > b.date ? -1 : 0);
  }

  async function boot() {
    initTheme();
    initSearch();
    try {
      const res = await fetch("entries.json", { cache: "no-cache" });
      if (!res.ok) throw new Error("HTTP " + res.status);
      const data = await res.json();
      allEntries = (Array.isArray(data) ? data : data.entries || []).sort(
        sortByDateDesc
      );
    } catch (err) {
      els.list.innerHTML =
        '<li class="entry"><div class="entry-card"><p class="entry-body">' +
        "Couldn’t load entries. If you’re opening this file directly, run it " +
        "through a local server (see README) — browsers block fetch() on " +
        "file:// URLs.</p></div></li>";
      console.error(err);
      return;
    }
    buildTagFilters();
    render();
  }

  boot();
})();
