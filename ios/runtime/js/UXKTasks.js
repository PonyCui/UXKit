
window.ux = {
    ani: window._UXK_Animation,
    router: window._UXK_Router,
    ready: window.ux_ready,
}

jQuery(document.body).update();

if (typeof window.ux.ready === "function") {
    window.ux.ready.call(this);
}
