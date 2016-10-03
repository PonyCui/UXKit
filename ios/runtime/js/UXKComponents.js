window._UXK_Components = {
    contents: {},
    rendComponent: function(name, props, innerHTML) {
        return '<!--Rended-->' + this.contents[name].replace('<innerHTML/>', innerHTML);
    },
    createJSComponent: function (name, contents) {
        this.contents[name] = decodeURIComponent(atob(contents));
    },
    createNativeComponent: function (name, attrs) {
        if (window._UXK_VisualDOMNames.indexOf(name.toUpperCase()) >= 0) {
            return;
        }
        window._UXK_VisualDOMNames.push(name.toUpperCase());
        for (var i = 0; i < attrs.length; i++) {
            var attr = attrs[i];
            if (window._UXK_VisualDOMAttrs.indexOf(attr) >= 0) {
                continue;
            }
            window._UXK_VisualDOMAttrs.push(attr);
        }
    },
};