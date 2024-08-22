import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"
const { StreamActions } = Turbo

export default class extends Controller {
  static targets = ["list"]

  connect() {
    this.notificationPageFlag = location.pathname === '/notifications';
    if (this.notificationPageFlag) {
      this.boundCheckIfInView = this.checkIfInView.bind(this);
      this.checkIfInView(); // 初回実行
      window.addEventListener('scroll', this.boundCheckIfInView);
      window.addEventListener('resize', this.boundCheckIfInView);
    }
  }

  disconnect() {
    if (this.notificationPageFlag && this.boundCheckIfInView) {
      window.removeEventListener('scroll', this.boundCheckIfInView);
      window.removeEventListener('resize', this.boundCheckIfInView);
    }
  }

  checkIfInView() {
    const notifications = this.listTarget.querySelectorAll('.unread');

    notifications.forEach(notification => {
      const rect = notification.getBoundingClientRect();
      const isInView = (
        rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
        rect.right <= (window.innerWidth || document.documentElement.clientWidth)
      );

      if (isInView) {
        this.sendReadRequest(notification);
      }
    });
  }

  sendReadRequest(notificationElement) {
    const link = notificationElement.querySelector('a[data-turbo-method="put"]');
    if (link) {
      fetch(link.href, {
        method: 'PUT',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content'),
          'Accept': 'text/vnd.turbo-stream.html' // Turbo Stream形式のレスポンスを期待
        }
      })
      .then(response => {
        if (response.ok) {
          response.text().then(html => {
            Turbo.renderStreamMessage(html); // Turbo Streamレスポンスを処理
            notificationElement.classList.remove('unread');
          });
        }
      });
    }
  }
}
