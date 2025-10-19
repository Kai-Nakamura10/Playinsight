import videojs from "video.js";

document.addEventListener("turbo:load", initOverlay);

function initOverlay() {
  const overlay = document.getElementById("tactic-overlay");
  if (!overlay || overlay.dataset.inited) return;
  overlay.dataset.inited = "1";

  const videoId = overlay.dataset.videoId;
  const videoEl = document.getElementById(`player-${videoId}`);
  if (!videoEl) return;

  const player = (videoEl.player && videoEl.player.on) ? videoEl.player
                : (window.videojs ? videojs(videoEl) : null);
  if (!player) return;

  const badge = document.getElementById(`tactic-badge-${videoId}`);
  if (!badge) return;

  function readTimelinesFromDOM() {
    const list = document.getElementById("timelines_list");
    if (!list) return [];

    const items = Array.from(list.querySelectorAll('[id^="timeline_"]'));
    return items.map((el) => {
      const timeText = el.querySelector(".text-sm")?.textContent || "";
      const m = timeText.match(/([\d.]+)/);
      const start = m ? parseFloat(m[1]) : 0;

      const title = el.querySelector(".text-gray-800")?.textContent?.trim() || "";
      return { id: el.id, start, end: null, title, body: "" };
    });
  }

  let timelines = readTimelinesFromDOM();

  document.addEventListener("turbo:frame-load", () => { timelines = readTimelinesFromDOM(); });
  document.addEventListener("turbo:render",     () => { timelines = readTimelinesFromDOM(); });

  const hitsAt = (t) => timelines.filter(x => {
    const end = x.end != null ? x.end : x.start;
    return x.start <= t && end >= t;
  });

  const esc = (s="") => String(s).replace(/[&<>"']/g, (c)=>({ "&":"&amp;","<":"&lt;",">":"&gt;","\"":"&quot;","'":"&#39;" }[c]));

  function showBadge(hit) {
    badge.innerHTML = `<div class="font-bold mb-0.5">${esc(hit.title || "戦術")}</div>`;
    badge.style.left = "auto";
    badge.style.right = "12px";
    badge.style.top = "12px";
    badge.style.transform = "";
    badge.classList.remove("hidden");
  }
  function hideBadge(){ badge.classList.add("hidden"); }

  let last = "";
  function renderAt(t) {
    const arr = hitsAt(t);
    const sig = arr.map(a=>a.id).join(",");
    if (sig === last) return;
    last = sig;

    if (arr.length === 0) hideBadge();
    else showBadge(arr[0]);
  }

  player.ready(() => {
    renderAt(Number(player.currentTime?.() || 0));
    player.on("timeupdate", () => renderAt(Number(player.currentTime?.() || 0)));
    console.log(player.currentTime());
  });
}
