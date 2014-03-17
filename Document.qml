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

    property string docId: ""

    property Object parent
    property var children: []
    property var childrenData: { return {} }
    property int count: children.length
    property bool loaded: false

    property var data: { return {} }

    signal childChanged(var doc)

    onChildChanged: {
        //print("Child changed:", doc.docId, parent)
        //print("Data is", JSON.stringify(save()))
        if (parent && parent.hasOwnProperty("childrenData")) {
            //print("Saving to parent")
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
        //print("Parent is loaded: ", name)
        if (loaded && childDocs) {
            for (var i = 0; i < childDocs.length; i++) {
                //print("A child exists, loading that:", i)
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

    Component.onCompleted: loadFromParent()

    property bool loading

    function loadFromParent() {
        if (loading)
            return
        //print("Attempting to load from parent:", docId)

        if (parent && (!parent.childDocs || parent.childDocs.indexOf(document) === -1)) {
            if (!parent.childDocs)
                parent.childDocs = []
            parent.childDocs.push(document)
        }

        if (parent && parent.loaded && docId !== "" && data) {
            //print("Loading " + docId + " from parent...")
            //print(JSON.stringify(parent.children))
            //print(JSON.stringify(parent.childrenData))
            //print(parent.children.indexOf(docId))
            if (parent.children.indexOf(docId) !== -1) {
                if (parent.childrenData && parent.childrenData.hasOwnProperty(docId)) {
                    //print(name + " exists, loading")
                    load(parent.childrenData[docId])
                } else {
                    //print("ERROR")
                }
            } else {
                //print(docId + " is a new document")
                if (!parent.childrenData)
                    parent.childrenData = {}

                //print("Parent before adding:",JSON.stringify(parent.childrenData))
                parent.childrenData[docId] = save()
                parent.children.push(docId)
                //print("Parent after adding:",JSON.stringify(parent.childrenData))

                parent.childChanged(document)

                loaded = true
            }
        }
    }

    function  get(name, def) {
        return data.hasOwnProperty(name) ? data[name] : def
    }

    function  getOrInit(name, def) {
        if (loaded) {
            if (data.hasOwnProperty(name)) {
                return data[name]
            } else {
                set(name, def)
                return def
            }
        } else {
            return data.hasOwnProperty(name) ? data[name] : def
        }
    }

    function set(name, value) {
        if (data == undefined)
            date = {}
        data[name] = value
        data = data
        if (parent && parent.childrenData) {
            parent.childrenData[document.docId] = save()
            parent.childChanged(document)
        }
    }

    function sync(name, value) {
        set(name, value)
        return Qt.binding(function() { return get(name) })
    }

    function newDoc(docId, json) {
        //print("Adding a new doc", JSON.stringify(json))
        childrenData[docId] = json
        children.push(docId)
        children = children
        childrenData = childrenData
        if (parent) {
            parent.childrenData[document.docId] = save()
            parent.childChanged(document)
        }
    }

    function hasChild(docId) {
        return children.indexOf(docId) !== -1
    }

    function filteredChildren(filter) {
        var list = []
        for (var docId in childrenData) {
            if (filter(childrenData[docId]))
                list.push(docId)
        }

        return list
    }

    function getChild(docId) {
        return newObject(Qt.resolvedUrl("Document.qml"), { docId: docId, parent: document })
    }

    function newObject(type, args) {
        var component = Qt.createComponent(type);
        return component.createObject(document, args);
    }

    function load(json) {
        //print("Loading...")
        loading = true
        var list = {}
        for (var prop in json) {
            if (prop !== "children")
                list[prop] = json[prop]
        }

        if (json && json.hasOwnProperty("children")) {
            childrenData = json.children
            //print("Children data: ", JSON.stringify(childrenData))
            children = []
            for (var docId in childrenData) {
                //print("Checking childrenData", i, childrenData[i])
                children.push(docId)
            }
            children = children
        }

        data = list

        loaded = true
        loading = false
    }

    function remove() {
        var oldDocId = docId
        docId = ""
        if (parent)
            parent.removeDoc(oldDocId)
    }

    function removeDoc(docId) {
        delete childrenData[docId]
        childrenData = childrenData
        //print(JSON.stringify(childrenData))
        children.splice(children.indexOf(docId), 1)
        children = children
        if (parent) {
            parent.childrenData[document.docId] = save()
            parent.childChanged(document)
        }
    }

    function removeChildren() {
        while (children.length > 0)
            removeDoc(children[0])
    }

    function save() {
        if (data === undefined)
            throw "Error: undefined data for: " + docId + " " + JSON.stringify(children)
        var json = JSON.parse(JSON.stringify(data))
        json.children = JSON.parse(JSON.stringify(childrenData))
        //print("Saving: " + JSON.stringify(json))
        return json
    }
}
