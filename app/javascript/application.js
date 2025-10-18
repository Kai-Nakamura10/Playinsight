import "@hotwired/turbo-rails"
import "./controllers"
import "video.js/dist/video-js.css";
import "video.js";
import "./timelines_overlay";
import videojs from "video.js";

function initVideoJS() {
  document.querySelectorAll("video.video-js").forEach((el) => {
    if (!el.player) {
      el.player = videojs(el, {
        controls: true,
        preload: "auto",
        fluid: true,
        responsive: true,
      });
    }
  });
}
document.addEventListener("turbo:load", initVideoJS);
document.addEventListener("DOMContentLoaded", initVideoJS);
