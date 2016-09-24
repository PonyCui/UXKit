window._UXK_Components.TEST = {
    setProps: function(dom, props) {
        if (props.on === "true") {
            dom.querySelector("[vKey='a']").setAttribute("backgroundColor", "#ffff00");
            dom.querySelector("[vKey='a']").setAttribute("frame", "20,20,160,160");
        }
        else {
            dom.querySelector("[vKey='a']").setAttribute("backgroundColor", "#ff0000");
            dom.querySelector("[vKey='a']").setAttribute("frame", "20,20,80,80");
        }        
    },
}
