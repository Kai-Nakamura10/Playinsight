import videojs from "video.js";

document.addEventListener("turbo:load", initTacticsOverlay);
document.addEventListener("DOMContentLoaded", initTacticsOverlay);

function initTacticsOverlay() {
  const overlay = document.getElementById("tactic-overlay");
  if (!overlay || overlay.dataset.tacticsInited) return;
  overlay.dataset.tacticsInited = "1";

  const videoId = overlay.dataset.videoId;
  const videoEl = document.getElementById(`player-${videoId}`);
  if (!videoEl) return;

  // Use the imported videojs directly; no global dependency
  const player = (videoEl.player && videoEl.player.on) ? videoEl.player : videojs(videoEl);
  // Read tactics data from data attribute if provided, else use example data
  // Expected shape: [{ display_time: Number (seconds), tactic_name: String }, ...]
  let tacticsData = [];
  try {
    if (overlay.dataset.tactics) {
      tacticsData = JSON.parse(overlay.dataset.tactics);
    } else if (window.tacticsData && Array.isArray(window.tacticsData)) {
      tacticsData = window.tacticsData;
    } else {
      // Fallback example to make the feature demonstrable
      tacticsData = [
        { display_time: 300, tactic_name: "ピック＆ロール" },
        { display_time: 480, tactic_name: "スクリーン" },
        { display_time: 720, tactic_name: "ファストブレイク" },
      ];
    }
  } catch (e) {
    console.warn("Invalid tactics data; skipping tactics overlay.", e);
    return;
  }

  // Sort ascending for natural forward traversal
  tacticsData.sort((a, b) => Number(a.display_time) - Number(b.display_time));

  // Track shown items; show each only once per page load
  const fired = new Set();
  const keyOf = (t) => `${t.display_time}:${t.tactic_name}`;

  // Toast element for display
  const toastId = `tactic-toast-${videoId}`;
  let toast = document.getElementById(toastId);
  if (!toast) {
    toast = document.createElement("div");
    toast.id = toastId;
    toast.className = [
      "absolute", "max-w-[80%]",
      "bg-white/90", "backdrop-blur-sm", "text-gray-900",
      "text-sm", "md:text-base", "font-semibold",
      "rounded-md", "px-3", "py-2",
      "shadow-xl", "ring-1", "ring-black/10",
      "hidden"
    ].join(" ");
    toast.style.right = "12px";
    toast.style.top = "12px";
    overlay.appendChild(toast);
  }

  let hideTimer = null;
  function showTactic(t) {
    toast.textContent = String(t.tactic_name || "戦術");
    toast.classList.remove("hidden");
    if (hideTimer) clearTimeout(hideTimer);
    hideTimer = setTimeout(() => {
      toast.classList.add("hidden");
    }, 3000);
  }

  let prev = 0;

  player.on("loadedmetadata", () => {
    try {
      prev = Number(player.currentTime?.() || 0) || 0;
    } catch (_) {
      prev = 0;
    }
  });

  player.on("timeupdate", () => {
    let now = 0;
    try {
      now = Number(player.currentTime?.() || 0) || 0;
    } catch (_) {
      return;
    }

    const forward = now >= prev;

    if (forward) {
      // Forward: check from small -> large
      tacticsData.forEach((t) => {
        if (fired.has(keyOf(t))) return;
        const m = Number(t.display_time) || 0;
        // Crossing condition (forward): prev < m <= now
        if (prev < m && m <= now) {
          showTactic(t);
          fired.add(keyOf(t));
        }
      });
    } else {
      // Rewind: check from large -> small for natural order
      tacticsData.slice().reverse().forEach((t) => {
        if (fired.has(keyOf(t))) return;
        const m = Number(t.display_time) || 0;
        // Crossing condition (rewind): now <= m < prev
        if (now <= m && m < prev) {
          showTactic(t);
          fired.add(keyOf(t));
        }
      });
    }

    prev = now; // Important: update at the end
  });
}
