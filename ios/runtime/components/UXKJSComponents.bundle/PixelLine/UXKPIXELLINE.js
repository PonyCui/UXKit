window._UXK_Components.PIXELLINE = {
    scale: 2.0,
    setProps: function (dom, props) {
        $(dom).attr('frame', $(dom).attr('frame').replace('_', (1.0 / this.scale)));
        $(dom).attr('backgroundColor', $(dom).attr('color') || "#dcdcdc");
    },
}