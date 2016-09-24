
window.ux = {
    ani: window._UXK_Animation,
    ready: window.ux_ready,
}

jQuery(document.body).update();

if (typeof window.ux.ready === "function") {
    window.ux.ready.call(this);
}