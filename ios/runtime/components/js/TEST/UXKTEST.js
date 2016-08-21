window._UXK_Components.TEST = {
    setProps: function(dom, props) {
        if (props.on === "true") {
            dom.getElementsByClassName("a")[0].setAttribute("backgroundColor", "#ffff00");
        }
        else {
            dom.getElementsByClassName("a")[0].setAttribute("backgroundColor", "#ff0000");
        }        
    },
}
