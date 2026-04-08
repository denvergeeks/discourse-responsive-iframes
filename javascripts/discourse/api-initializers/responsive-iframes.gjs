import { apiInitializer } from "discourse/lib/api";

export default apiInitializer((api) => {
  api.decorateCookedElement(
    (cooked) => {
      cooked.querySelectorAll("iframe").forEach((iframe) => {
        if (iframe.closest(".responsive-iframe-wrap")) {
          return;
        }

        if (iframe.closest(".fk-d-tooltip__inner-content")) {
          iframe.classList.add("responsive-iframe");
          return;
        }

        const wrapper = document.createElement("div");
        wrapper.className = "responsive-iframe-wrap";

        const width = parseFloat(iframe.getAttribute("width"));
        const height = parseFloat(iframe.getAttribute("height"));

        if (width > 0 && height > 0) {
          wrapper.style.setProperty("--iframe-ratio", `${width} / ${height}`);
        } else {
          wrapper.style.setProperty("--iframe-ratio", "16 / 9");
        }

        iframe.parentNode.insertBefore(wrapper, iframe);
        wrapper.appendChild(iframe);
        iframe.classList.add("responsive-iframe");
        iframe.removeAttribute("width");
        iframe.removeAttribute("height");
      });
    },
    { id: "responsive-iframes", onlyStream: true }
  );
});
