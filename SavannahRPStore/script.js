/* Savannah RP — site scripts. Small, no dependencies. */
(function () {
  "use strict";

  /* ---- mobile nav ---- */
  var btn = document.getElementById("menuBtn");
  var links = document.getElementById("navLinks");
  if (btn && links) {
    btn.addEventListener("click", function () { links.classList.toggle("open"); });
    links.querySelectorAll("a").forEach(function (a) {
      a.addEventListener("click", function () { links.classList.remove("open"); });
    });
  }

  /* ---- live server status --------------------------------------------------
     Drop your public Cfx.re join code between the quotes and status goes live.
     Example: cfx.re/join/abcd12  ->  SERVER_CODE = "abcd12"
  ------------------------------------------------------------------------- */
  var SERVER_CODE = "";

  function paint(statusText, players, state) {
    document.querySelectorAll("[data-server-status]").forEach(function (el) {
      el.textContent = statusText;
      var dot = el.previousElementSibling || el.querySelector("i");
    });
    document.querySelectorAll("[data-player-count]").forEach(function (el) {
      el.textContent = players;
    });
    document.querySelectorAll(".pill.js-status, .nav-status").forEach(function (el) {
      el.classList.remove("on", "off");
      if (state === true) el.classList.add("on");
      if (state === false) el.classList.add("off");
    });
  }

  function loadStatus() {
    if (!SERVER_CODE) { paint("COMING SOON", "— / —", null); return; }
    fetch("https://servers-frontend.fivem.net/api/servers/single/" + encodeURIComponent(SERVER_CODE), { cache: "no-store" })
      .then(function (r) { if (!r.ok) throw 0; return r.json(); })
      .then(function (j) {
        var d = j && j.Data;
        if (!d) throw 0;
        paint("ONLINE", (d.clients || 0) + " / " + (d.sv_maxclients || d.svMaxclients || "?"), true);
      })
      .catch(function () { paint("OFFLINE", "— / —", false); });
  }
  loadStatus();
  if (SERVER_CODE) setInterval(loadStatus, 60000);

  /* ---- reveal on scroll ---- */
  if (!window.matchMedia("(prefers-reduced-motion: reduce)").matches && "IntersectionObserver" in window) {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) { e.target.style.opacity = 1; e.target.style.transform = "none"; io.unobserve(e.target); }
      });
    }, { threshold: 0.08 });
    document.querySelectorAll(".section, .card").forEach(function (el) {
      el.style.opacity = 0; el.style.transform = "translateY(14px)";
      el.style.transition = "opacity .5s ease, transform .5s ease";
      io.observe(el);
    });
  }
})();

/* ---- application form generator (apply.html only) ---- */
function savApplyInit() {
  var roleSel = document.getElementById("appRole");
  var fields = document.getElementById("appFields");
  var out = document.getElementById("appOut");
  if (!roleSel || !fields || !out) return;

  var COMMON = [
    ["discord", "Your Discord username"],
    ["age", "Your age (must be 18+)"],
    ["timezone", "Timezone / country"],
    ["char", "Character name"],
    ["rpxp", "Roleplay experience"]
  ];
  var ROLES = {
    "Police Department": [["why", "Why do you want to join the LSPD?"], ["scenario", "How would you handle a non-compliant suspect during a stop?"], ["prior", "Any prior LEO / PD roleplay?"]],
    "EMS / Fire": [["why", "Why do you want to join EMS/Fire?"], ["scenario", "Walk through how you'd handle a multi-patient scene."], ["prior", "Any medical / EMS roleplay experience?"]],
    "Mechanic": [["shop", "Which shop, or open to any?"], ["skills", "What can you offer (tuning, bodywork, towing, custom builds)?"], ["hours", "Rough weekly availability"]],
    "Business Owner": [["biz", "Business concept"], ["loc", "Preferred location / MLO"], ["plan", "How will it create roleplay for others?"], ["funds", "Starting funds / plan to fund it"]],
    "Gang / Organization": [["name", "Crew / org name"], ["theme", "Theme and backstory (keep it grounded)"], ["members", "Current members (Discord names)"], ["goals", "In-city goals — legal and illegal"]],
    "Tattoo Artist": [["portfolio", "Link a portfolio or describe your style"], ["shop", "Work from a shop or freelance?"], ["hours", "Rough weekly availability"]],
    "Staff": [["why", "Why do you want to be staff?"], ["exp", "Prior staff / moderation experience"], ["hours", "Weekly hours you can commit"], ["conflict", "How do you handle a report against a friend?"]]
  };

  function render() {
    var role = roleSel.value;
    var list = COMMON.concat(ROLES[role] || []);
    fields.innerHTML = list.map(function (f) {
      return '<div class="form-field"><label>' + f[1] + '</label><textarea data-k="' + f[0] + '" data-q="' + f[1].replace(/"/g, "&quot;") + '"></textarea></div>';
    }).join("");
    fields.querySelectorAll("textarea").forEach(function (t) { t.addEventListener("input", build); });
    build();
  }
  function build() {
    var role = roleSel.value;
    var lines = ["=== SAVANNAH RP APPLICATION ===", "ROLE: " + role, ""];
    fields.querySelectorAll("textarea").forEach(function (t) {
      lines.push(t.dataset.q + ":");
      lines.push((t.value || "").trim() || "(not answered)");
      lines.push("");
    });
    lines.push("I confirm this application is truthful and I have read the Savannah RP rules.");
    out.textContent = lines.join("\n");
  }

  roleSel.addEventListener("change", render);
  var copyBtn = document.getElementById("appCopy");
  if (copyBtn) copyBtn.addEventListener("click", function () {
    navigator.clipboard.writeText(out.textContent).then(function () {
      copyBtn.textContent = "COPIED — PASTE IT IN YOUR DISCORD TICKET";
      setTimeout(function () { copyBtn.textContent = "COPY APPLICATION"; }, 2500);
    });
  });
  render();
}
document.addEventListener("DOMContentLoaded", savApplyInit);
