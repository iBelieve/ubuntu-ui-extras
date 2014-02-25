/***************************************************************************
 * Whatsoever ye do in word or deed, do all in the name of the             *
 * Lord Jesus, giving thanks to God and the Father by him.                 *
 * - Colossians 3:17                                                       *
 *                                                                         *
 * Ubuntu UI Extras - A collection of QML widgets not available            *
 *                    in the default Ubuntu UI Toolkit                     *
 * Copyright (C) 2013 Michael Spencer <sonrisesoftware@gmail.com>          *
 *                                                                         *
 * This program is free software: you can redistribute it and/or modify    *
 * it under the terms of the GNU General Public License as published by    *
 * the Free Software Foundation, either version 2 of the License, or       *
 * (at your option) any later version.                                     *
 *                                                                         *
 * This program is distributed in the hope that it will be useful,         *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the            *
 * GNU General Public License for more details.                            *
 *                                                                         *
 * You should have received a copy of the GNU General Public License       *
 * along with this program. If not, see <http://www.gnu.org/licenses/>.    *
 ***************************************************************************/
import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import "listutils.js" as List

import U1db 1.0 as U1db

Object {
    id: document

    property int docId: -1
    property int nextDocId: 0
    property string name: ""

    property Object parent
    property var children: []
    property var childrenData: { return {} }
    property int count: children.length
    property bool loaded: false

    property var data: { return {} }

    signal childChanged(var docId)

    onChildChanged: {
        print("Child changed:", docId)
        if (parent)
            parent.childChanged(document.docId)
    }

    __defaultPropertyFix: [
        Connections {
            target: document.parent
            onChildChanged: loadFromParent()
        },

        Connections {
            target: document.parent
            onLoadedChanged: {
                print("Parent is loaded!")
                if (loaded) {
                    loadFromParent()
                }
            }
        }
    ]

    onParentChanged: loadFromParent()
    onDocIdChanged: loadFromParent()
    onDataChanged: loadFromParent()

    function loadFromParent() {
        print(name)
        if (parent /*&& parent.loaded*/ && docId !== -1 && data) {
            print("Loading from parent...")
            print(JSON.stringify(parent.children))
            print(JSON.stringify(parent.childrenData))
            if (parent.children.indexOf(docId) !== -1) {
                if (parent.childrenData && parent.childrenData.hasOwnProperty(docId))
                    load(parent.childrenData[docId])
            } else {
                if (!parent.childrenData)
                    parent.childrenData = {}

                if (!data)
                    data = {}

                parent.childrenData[docId] = data
                parent.children.push(docId)

                parent.childChanged(document.docId)

                loaded = true
            }
        }
    }

    function get(name) {
        return data[name]
    }

    function set(name, value) {
        data[name] = value
        parent.childrenData[docId] = data
        parent.childChanged(docId)
    }

    function sync(name, value) {
        set(name, value)
        return Qt.binding(function() { return get(name) })
    }

    function newDoc(json) {
        var docId = nextDocId++
        childrenData[docId] = json
        children.push(docId)
        children = children
    }

    function load(json) {
        for (var prop in json) {
            if (prop !== "children")
                data[prop] = json[prop]
        }

        if (json.hasOwnProperty("children")) {
            childrenData = json.children
            children = List.objectKeys(childrenData)
        }

        loaded = true
    }

    function save() {
        var json = JSON.parse(JSON.stringify(data))
        json.children = childrenData
    }
}
