window.uxQueryHelper = {
    kVisualDOMNames: ["BODY", "VIEW"],
    kVisualDOMAttrs: ["frame",
        "userInteractionEnabled",
        "transform",
        "clipsToBounds",
        "backgroundColor",
        "alpha",
        "hidden",
        "cornerRadius",
        "borderWidth",
        "borderColor",
    ],
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
            vKey: node.getAttribute("_UXK_vKey"),
            props: {},
            subviews: [],
        };
        for (var i = 0; i < this.kVisualDOMAttrs.length; i++) {
            var attr = this.kVisualDOMAttrs[i];
            if (node.hasAttribute(attr)) {
                tree.props[attr] = node.getAttribute(attr);
            }
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
    commitTree: function (node, updatePropsOnly) {
        try {
            webkit.messageHandlers.UXK_ViewUpdater.postMessage(JSON.stringify(this.createTree(node, updatePropsOnly)));
        } catch (err) {
            console.log("UXK_ViewUpdater not ready.");
        }
    },
    updateComponents: function (node) {
        var childNodes = node.childNodes;
        for (var i = 0; i < childNodes.length; i++) {
            var childNode = childNodes[i];
            if (window._UXK_Components.contents[childNode.nodeName] !== undefined) {
                if (childNode.getAttribute("_UXK_cKey") !== "_") {
                    childNode.innerHTML = window._UXK_Components.rendComponent(childNode.nodeName, {});
                    childNode.setAttribute("_UXK_cKey", "_");
                    var attributes = {};
                    for (var i = 0; i < childNode.attributes.length; i++) {
                        var element = childNode.attributes[i];
                        attributes[element.name] = element.value;
                    }
                    window._UXK_Components[childNode.nodeName].setProps(childNode, attributes);
                }
                else {
                    var attributes = {};
                    for (var i = 0; i < childNode.attributes.length; i++) {
                        var element = childNode.attributes[i];
                        attributes[element.name] = element.value;
                    }
                    window._UXK_Components[childNode.nodeName].setProps(childNode, attributes);
                }
            }
            this.updateComponents(childNode);
        }
    },
}

window.uxQuery = function (selector) {
    var node = typeof selector === "string" ? document.querySelector(selector) : selector;
    if (node === null || node === undefined) {
        return null;
    }
    return {
        update: function (updatePropsOnly) {
            if (updatePropsOnly === true) {
                uxQueryHelper.commitTree(node, true);
            }
            else {
                uxQueryHelper.updateComponents(node);
                uxQueryHelper.assignKeys(node);
                uxQueryHelper.commitTree(node);
            }
        },
        spring: function () {

        },
        timing: function () {

        },
        decay: function () {

        },
    }
}

if (window.$ === undefined) {
    window.$ = window.uxQuery;
}
else {
    window.$$ = window.uxQuery;
}