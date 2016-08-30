(function (global, factory) {
    if (typeof define === "function" && define.amd) {
        define([
            "exports",
            "react"
        ], factory);
    } else if (typeof exports !== "undefined") {
        factory(exports, require("react"));
    } else {
        var mod = {
                exports: {}
            };

        factory(mod.exports, global.uis);
        global.componentEs6 = mod.exports;
    }
})(this, function (exports, react) {
    "use strict" Object.defineProperty(exports, "__esModule", {
        value: true
    });
    var React = react;


    /* Imported components */
    var _mergeAttributes = function (a, b) {
            var res = (b || []).reduce(function (r, v) {
                    if (v) {
                        var k = v.name;

                        if (k === "style") {
                            r[k] = r[k] || {};
                            Object.assign(r[k], v.value);
                        } else if (v.add) {
                            r[k] = r[k] ? r[k] + " " + v.value : v.value;
                        } else {
                            r[k] = v.value;
                        }
                    }

                    return r;
                }, a || {});

            console.log("RES", res);

            return res;
        };

    var _parseStyle = function (style) {
            var n = document.createElement("div");

            n.setAttribute("style", style);
            var res = {};

            for (var i = 0; i < n.style.length; i ++) {
                var k = n.style[i];

                var p = k.split("-").map(function (v, i) {
                        return i == 0 ? v : v[0].toUpperCase() + v.substring(1)
                    }).join("");

                res[p] = n.style[k];
            }

            return res;
        };

    var STYLES = {};


    /* View */
    exports.View = function (data, component) {
        var state = data;

        return (React.createElement("button", null, (this.state.label)))
    };
});
