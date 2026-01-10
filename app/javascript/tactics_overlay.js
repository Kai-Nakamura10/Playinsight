import videojs from "video.js";

document.addEventListener("turbo:load", initTacticsOverlay);
document.addEventListener("DOMContentLoaded", initTacticsOverlay);

function initTacticsOverlay() {
  const overlay = document.getElementById("tactic-overlay");
  if (!overlay || overlay.dataset.tacticsInited) return;

  const videoId = overlay.dataset.videoId;
  const videoEl = document.getElementById(`player-${videoId}`);
  if (!videoEl) return;

  // Initialize or reuse the player and store it on the element
  const player = videoEl.player && videoEl.player.on ? videoEl.player : videojs(videoEl);
  videoEl.player = player;
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

  const keyOf = (t) => `${t.display_time}:${t.tactic_name}`;

  // Toast element for display
  const toastId = `tactic-toast-${videoId}`;
  let toast = document.getElementById(toastId);
  const playerRoot = player.el?.() || videoEl.parentElement || overlay;
  if (!toast) {
    toast = document.createElement("div");
    toast.id = toastId;
    toast.className = [
      "absolute", "max-w-[80%]",
      "bg-white/90", "backdrop-blur-sm", "text-gray-900",
      "text-sm", "md:text-base", "font-semibold",
      "rounded-md", "px-3", "py-2",
      "shadow-xl", "ring-1", "ring-black/10",
      "z-[100]", "pointer-events-none",
      "hidden"
    ].join(" ");
    toast.style.right = "12px";
    toast.style.top = "12px";
    playerRoot.appendChild(toast);
  }

  let activeKey = null;
  function showTactic(t) {
    toast.textContent = String(t.tactic_name || "戦術");
    toast.classList.remove("hidden");
  }

  function hideTactic() {
    toast.classList.add("hidden");
    activeKey = null;
  }

  let prev = 0;

  // Defer event binding until the player is ready
  player.ready(() => {
    overlay.dataset.tacticsInited = "1";

    try {
      prev = Number(player.currentTime?.() || 0) || 0;
    } catch (_) {
      prev = 0;
    }

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

      if (Math.abs(now - prev) >= 1) {
        prev = now;
        return;
      }

      const match = tacticsData.find((t) => {
        const start = Number(t.display_time) || 0;
        return now >= start && now <= start + 2;
      });

      if (match) {
        const nextKey = keyOf(match);
        if (activeKey !== nextKey) {
          showTactic(match);
          activeKey = nextKey;
        }
      } else if (!toast.classList.contains("hidden")) {
        hideTactic();
      }

      prev = now;
    });
  });
}
