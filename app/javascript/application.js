import "@hotwired/turbo-rails"
import "./controllers"
import "video.js";
import "./tactics_overlay";
import videojs from "video.js";

const QUIZ_LOADING_SUBMIT_SELECTOR = 'button[type="submit"], input[type="submit"]';
const QUIZ_LOADING_TEXT = '🤖 AI解説を生成中...';

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

// ✅ クイズローディング機能の統一版
function initQuizLoadingFeature() {
  cleanupQuizLoadingUI();

  const forms = document.querySelectorAll('form');

  forms.forEach(form => {
    if (form.dataset.quizLoadingInitialized) return;

    form.addEventListener('submit', function() {
      const choiceInput = form.querySelector('input[name="choice_id"]:checked');
      if (choiceInput) {
        const submitButton = form.querySelector(QUIZ_LOADING_SUBMIT_SELECTOR);
        if (submitButton) {
          setQuizLoadingButtonState(submitButton, true);
          showQuizLoadingIndicator(form);
        }
      }
    });

    form.dataset.quizLoadingInitialized = 'true';
  });
}

function setQuizLoadingButtonState(button, isLoading) {
  const isButtonTag = button.tagName === "BUTTON";
  const defaultKey = isButtonTag ? "quizLoadingDefaultHtml" : "quizLoadingDefaultValue";

  if (!button.dataset[defaultKey]) {
    button.dataset[defaultKey] = isButtonTag ? button.innerHTML : button.value;
  }

  if (isLoading) {
    if (isButtonTag) {
      button.innerHTML = QUIZ_LOADING_TEXT;
    } else {
      button.value = QUIZ_LOADING_TEXT;
    }
    button.disabled = true;
    button.setAttribute("aria-busy", "true");
    return;
  }

  const originalText = button.dataset[defaultKey];
  if (originalText !== undefined) {
    if (isButtonTag) {
      button.innerHTML = originalText;
    } else {
      button.value = originalText;
    }
  }
  button.disabled = false;
  button.removeAttribute("aria-busy");
}

function cleanupQuizLoadingUI() {
  const existingLoader = document.getElementById('quiz-ai-loading');
  if (existingLoader) {
    existingLoader.remove();
  }

  document.querySelectorAll('form[data-quiz-loading-initialized]').forEach(form => {
    const submitButton = form.querySelector(QUIZ_LOADING_SUBMIT_SELECTOR);
    if (submitButton) {
      setQuizLoadingButtonState(submitButton, false);
    }
  });
}

function showQuizLoadingIndicator(form) {
  // 既存のローディング表示があれば削除
  const existingLoader = document.getElementById('quiz-ai-loading');
  if (existingLoader) {
    existingLoader.remove();
  }

  // 新しいローディング表示を作成
  const loader = document.createElement('div');
  loader.id = 'quiz-ai-loading';
  loader.innerHTML = `
    <div style="
      text-align: center; 
      margin: 20px 0; 
      padding: 25px; 
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border-radius: 15px; 
      box-shadow: 0 8px 25px rgba(0,0,0,0.15);
      animation: pulse 2s infinite;
      position: relative;
      overflow: hidden;
    ">
      <!-- バスケットボールアイコン -->
      <div style="font-size: 32px; margin-bottom: 15px; animation: bounce 1s infinite;">🏀</div>

      <!-- メインメッセージ -->
      <p style="margin: 0; font-weight: bold; font-size: 18px; margin-bottom: 8px;">
        AI戦術アナリストが解説を生成中
      </p>

      <!-- サブメッセージ -->
      <p style="margin: 0; font-size: 14px; opacity: 0.9; margin-bottom: 20px;">
        バスケット戦術を詳しく分析しています...
      </p>

      <!-- プログレスバー -->
      <div style="
        width: 100%; 
        height: 6px; 
        background: rgba(255,255,255,0.3); 
        border-radius: 3px; 
        margin-bottom: 15px;
        overflow: hidden;
      ">
        <div style="
          width: 100%; 
          height: 100%; 
          background: rgba(255,255,255,0.9); 
          border-radius: 3px;
          animation: loading-bar 3s ease-in-out infinite;
        "></div>
      </div>

      <!-- 予想時間 -->
      <p style="margin: 0; font-size: 12px; opacity: 0.8;">
        通常5-10秒程度でお待ちください
      </p>

      <!-- 背景装飾 -->
      <div style="
        position: absolute;
        top: -50%;
        left: -50%;
        width: 200%;
        height: 200%;
        background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
        animation: rotate 10s linear infinite;
        pointer-events: none;
      "></div>
    </div>

    <style>
      @keyframes pulse {
        0%, 100% { transform: scale(1); }
        50% { transform: scale(1.02); }
      }

      @keyframes bounce {
        0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
        40% { transform: translateY(-10px); }
        60% { transform: translateY(-5px); }
      }

      @keyframes loading-bar {
        0% { transform: translateX(-100%); }
        50% { transform: translateX(0%); }
        100% { transform: translateX(100%); }
      }

      @keyframes rotate {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }
    </style>
  `;

  // フォームの後に挿入
  if (form && form.parentNode) {
    form.parentNode.insertBefore(loader, form.nextSibling);
  }
}

document.addEventListener('turbo:before-cache', cleanupQuizLoadingUI);
document.addEventListener('DOMContentLoaded', initQuizLoadingFeature);
document.addEventListener("turbo:load", initQuizLoadingFeature);
