window._UXK_Components.TEST = {
    setProps: function(dom, props) {
        if (props.on === "true") {
            dom.querySelector("[vKey='a']").setAttribute("backgroundColor", "#ffff00");
        }
        else {
            dom.querySelector("[vKey='a']").setAttribute("backgroundColor", "#ff0000");
        }        
    },
}
