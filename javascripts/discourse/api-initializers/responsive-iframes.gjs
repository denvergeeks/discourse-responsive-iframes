import { apiInitializer } from "discourse/lib/api";

function getIframeRatio(iframe) {
  const width = parseFloat(iframe.getAttribute("width"));
  const height = parseFloat(iframe.getAttribute("height"));

  if (width > 0 && height > 0) {
    return `${width} / ${height}`;
  }

  return "16 / 9";
}

export default apiInitializer((api) => {
  api.decorateCookedElement(
    (cooked) => {
      cooked.querySelectorAll("iframe").forEach((iframe) => {
        if (
          iframe.classList.contains("autoscale-iframe") ||
          iframe.closest(".autoscale-iframe-wrap")
        ) {
          return;
        }

        if (iframe.closest(".responsive-iframe-wrap")) {
          iframe.classList.add("responsive-iframe");
          return;
        }

        if (iframe.closest(".fk-d-tooltip__inner-content")) {
          iframe.classList.add("responsive-iframe");
          iframe.removeAttribute("width");
          iframe.removeAttribute("height");
          return;
        }

        const wrapper = document.createElement("div");
        wrapper.className = "responsive-iframe-wrap";
        wrapper.style.setProperty("--iframe-ratio", getIframeRatio(iframe));

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
