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
    property var childrenData: []
    property int count: children.length
    property bool loaded: false

    property var data: { return {} }

    signal childChanged(var doc)

    onChildChanged: {
        print("Child changed:", doc.docId)
        if (parent) {
            parent.childrenData[document.docId] = save()
            parent.childChanged(document)
        }

        for (var i = 0; i < childDocs.length; i++) {
            if (childDocs[i] !== doc && childDocs[i].docId === doc.docId)
                childDocs[i].loadFromParent()
        }
    }

    property var childDocs: []

    onLoadedChanged: {
        print("Parent is loaded: ", name)
        if (loaded && childDocs) {
            for (var i = 0; i < childDocs.length; i++) {
                print("A child exists, loading that:", i)
                childDocs[i].loadFromParent()
            }
        }
    }

    onParentChanged: loadFromParent()
    onDocIdChanged: loadFromParent()
    onDataChanged: {
        if (loaded) return
        loadFromParent()
    }

    property bool loading

    function loadFromParent() {
        if (loading)
            return
        print(name)

        if (parent && (!parent.childDocs || parent.childDocs.indexOf(document) === -1)) {
            if (!parent.childDocs)
                parent.childDocs = []
            parent.childDocs.push(document)
        }

        if (parent && parent.loaded && docId !== -1 && data) {
            print("Loading " + name + " (" + docId + ") from parent...")
            print(JSON.stringify(parent.children))
            print(JSON.stringify(parent.childrenData))
            print(parent.children.indexOf(docId))
            if (parent.children.indexOf(docId) !== -1) {
                if (parent.childrenData && parent.childrenData.hasOwnProperty(docId)) {
                    print(name + " exists, loading")
                    load(parent.childrenData[docId])
                } else {
                    print("ERROR")
                }
            } else {
                print(name + " is a new document")
                if (!parent.childrenData)
                    parent.childrenData = []

                parent.childrenData[docId] = save()
                parent.children.push(docId)
                parent.nextDocId = docId + 1

                parent.childChanged(document)

                loaded = true
            }
        }
    }

    function get(name, def) {
        return data.hasOwnProperty(name) ? data[name] : def
    }

    function set(name, value) {
        data[name] = value
        if (parent) {
            parent.childrenData[document.docId] = save()
            parent.childChanged(document)
        }
    }

    function sync(name, value) {
        set(name, value)
        return Qt.binding(function() { return get(name) })
    }

    function newDoc(json) {
        print("Adding a new doc", JSON.stringify(json))
        var docId = nextDocId
        nextDocId++
        childrenData[docId] = json
        children.push(docId)
        children = children
        if (parent) {
            parent.childrenData[document.docId] = save()
            parent.childChanged(document)
        }
    }

    function load(json) {
        print("Loading...")
        loading = true
        var list = data
        for (var prop in json) {
            if (prop !== "children" && prop !== "nextDocId")
                list[prop] = json[prop]
        }
        if (json.hasOwnProperty("nextDocId"))
            nextDocId = json["nextDocId"]

        if (json && json.hasOwnProperty("children")) {
            childrenData = json.children
            print("Children data: ", JSON.stringify(childrenData))
            children = []
            for (var i = 0; i < childrenData.length; i++) {
                print("Checking childrenData", i, childrenData[i])
                if (childrenData[i] !== null)
                    children.push(i)
            }
            children = children
        }

        data = list

        loaded = true
        loading = false
    }

    function save() {
        var json = JSON.parse(JSON.stringify(data))
        json.nextDocId = nextDocId
        json.children = JSON.parse(JSON.stringify(childrenData))
        print("Saving: " + JSON.stringify(json))
        return json
    }
}
