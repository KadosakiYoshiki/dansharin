import { Application } from "@hotwired/stimulus"

const application = Application.start()
const { StreamActions } = Turbo

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

StreamActions.redirect = function () {
  setTimeout(() => {
    Turbo.visit(this.getAttribute("url"));
  }, 2000);
};
