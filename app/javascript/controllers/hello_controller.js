import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }
}

window.jumpToPage = function() {
  const path = location.pathname;
  const pageNo = document.getElementById('page').value;
  if (!!pageNo) {
    window.location.href = path + "?page=" + pageNo;
  } else {
    window.location.href = path;
  }
};
