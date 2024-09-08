// app/javascript/controllers/flash_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // 4秒後にフェードアウトを開始
    setTimeout(() => {
      this.fadeOut();
    }, 4000);
  }

  fadeOut() {
    // フェードアウトのアニメーションを追加
    this.element.style.transition = 'opacity 1s ease';
    this.element.style.opacity = '0';

    // アニメーション終了後に要素を完全に削除
    setTimeout(() => {
      this.element.innerHTML = '';
    }, 1000); // フェードアウトに1秒かかる
  }
}
