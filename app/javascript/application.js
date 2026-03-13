// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Custom Confirmation Dialog for Turbo
document.addEventListener("turbo:load", () => {
  if (window.Turbo) {
    window.Turbo.setConfirmMethod((message, element) => {
      return new Promise((resolve, reject) => {
        const dialogId = "turbo-confirm-dialog";
        let dialog = document.getElementById(dialogId);
        if (dialog) { dialog.remove(); }
        
        dialog = document.createElement("div");
        dialog.id = dialogId;
        dialog.className = "custom-confirm-backdrop";
        
        dialog.innerHTML = `
          <div class="custom-confirm-modal">
            <div class="modal-icon">
              <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-alert-triangle"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>
            </div>
            <p>${message}</p>
            <div class="custom-confirm-actions">
              <button id="turbo-confirm-cancel" class="btn btn-secondary">Cancel</button>
              <button id="turbo-confirm-accept" class="btn btn-danger">Confirm</button>
            </div>
          </div>
        `;
        
        document.body.appendChild(dialog);
        
        document.getElementById("turbo-confirm-accept").addEventListener("click", () => {
          dialog.remove();
          resolve(true);
        });
        
        document.getElementById("turbo-confirm-cancel").addEventListener("click", () => {
          dialog.remove();
          resolve(false);
        });
      });
    });
  }
});
