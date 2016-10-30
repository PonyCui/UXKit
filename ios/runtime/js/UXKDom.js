(function ($) {
    var domHelper = {
        kVisualDOMNames: ["BODY", "NAV", "VIEW", "IMAGEVIEW", "LABEL", "TEXTFIELD", "MODAL"],
        guid: function () {
            function s4() {
                return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
            }
            return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
        },
        assignKeys: function (node) {
            var childNodes = node.childNodes;
            for (var i = 0; i < childNodes.length; i++) {
                var childNode = childNodes[i];
                if (this.kVisualDOMNames.indexOf(childNode.nodeName) < 0 &&
                    window._UXK_Components.contents[childNode.nodeName] === undefined) {
                    continue;
                }
                if (!childNode.hasAttribute("_UXK_vKey")) {
                    childNode.setAttribute("_UXK_vKey", this.guid());
                }
                this.assignKeys(childNode);
            }
        },
        createTree: function (node, updatePropsOnly) {
            if (this.kVisualDOMNames.indexOf(node.nodeName) < 0 &&
                window._UXK_Components.contents[node.nodeName] === undefined) {
                return undefined;
            }
            var tree = {
                name: window._UXK_Components.contents[node.nodeName] !== undefined ? "VIEW" : node.nodeName,
                updatePropsOnly: updatePropsOnly,
                vKey: node.getAttribute("_UXK_vKey"),
                props: {},
                subviews: [],
            };
            for (var i = 0; i < node.attributes.length; i++) {
                var attr = node.attributes[i];
                tree.props[attr.name] = attr.value;
            }
            if (node.nodeName === "LABEL" && tree.props.text === undefined) {
                tree.props["text"] = node.innerHTML.trim();
            }
            if (updatePropsOnly === true) {
                delete tree.subviews;
                return tree;
            }
            var childNodes = node.childNodes;
            for (var i = 0; i < childNodes.length; i++) {
                var childNode = childNodes[i];
                var branch = this.createTree(childNode);
                if (branch !== undefined) {
                    tree.subviews.push(branch);
                }
            }
            return tree;
        },
        commitTree: function (node, updatePropsOnly, callback) {
            try {
                var args = this.createTree(node, updatePropsOnly);
                if (typeof callback === "function") {
                    args.callbackID = window.ux.createCallback(callback);
                }
                webkit.messageHandlers.UXK_ViewUpdater.postMessage(JSON.stringify(args));
            } catch (err) {
                console.log("UXK_ViewUpdater not ready.");
            }
        },
        updateComponents: function (node) {
            if (window._UXK_Components.contents[node.nodeName] !== undefined) {
                if (node.innerHTML.indexOf('<!--Rended-->') < 0) {
                    node.innerHTML = window._UXK_Components.rendComponent(node.nodeName, {}, node.innerHTML);
                    if (typeof window._UXK_Components[node.nodeName].onLoad === "function") {
                        setTimeout(function(){
                            window._UXK_Components[node.nodeName].onLoad(node);
                        }, 0);
                    }
                }
                if (node.getAttribute("_UXK_cKey") !== "_") {
                    node.setAttribute("_UXK_cKey", "_");
                    var attributes = {};
                    for (var i = 0; i < node.attributes.length; i++) {
                        var element = node.attributes[i];
                        attributes[element.name] = element.value;
                    }
                    if (typeof window._UXK_Components[node.nodeName].setProps === "function") {
                        window._UXK_Components[node.nodeName].setProps(node, attributes);
                    }
                }
                else {
                    var attributes = {};
                    for (var i = 0; i < node.attributes.length; i++) {
                        var element = node.attributes[i];
                        attributes[element.name] = element.value;
                    }
                    if (typeof window._UXK_Components[node.nodeName].setProps === "function") {
                        window._UXK_Components[node.nodeName].setProps(node, attributes);
                    }
                }
            }
            var childNodes = node.childNodes;
            for (var i = 0; i < childNodes.length; i++) {
                this.updateComponents(childNodes[i]);
            }
        },
    };

    // Update
    $.createIMP('update', '*', function(updatePropsOnly_Callback, callback){
        if (typeof updatePropsOnly_Callback === "function") {
            callback = updatePropsOnly_Callback;
            updatePropsOnly_Callback = false;
        }
        if (updatePropsOnly_Callback === true) {
            domHelper.commitTree(this.get(0), true, callback);
        }
        else {
            domHelper.updateComponents(this.get(0));
            domHelper.assignKeys(this.get(0));
            domHelper.commitTree(this.get(0), false, callback);
        }
    });

    // Layout
    $.createIMP('onLayout', '*', function(callback){
        $(this).attr('_UXK_LayoutCallbackID', window.ux.createCallback(callback));
        $(this).update(true);
    });

    // Modal
    $.createIMP('show', 'MODAL', function(callback){
        $(this).value('show', callback);
    });
    $.createIMP('hide', 'MODAL', function(callback){
        $(this).value('hide', callback);
    });

})(jQuery);
