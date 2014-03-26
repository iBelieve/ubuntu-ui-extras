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
import U1db 1.0 as U1db

Object {
    id: root

    property alias path: db.path

    function get(name, def) {
        return doc.get(name, def)
    }

    function set(name, value) {
        return doc.set(name, value)
    }

    U1db.Database {
        id: db;
    }

    property alias document: doc

    Document {
        id: doc

        onLoaded: root.loaded()
        onSave: root.save()
    }

    signal loaded()
    signal save()

    Timer {
        interval: 5 * 60 * 1000
        repeat: true
        running: true
        onTriggered: {
            //if (storage.dbChanged) {
                storage.save()
            //    storage.dbChanged = false
            //}
        }
    }

    U1db.Document {
        id: storage

        database: db
        docId: 'storage'
        create: true

        property bool loaded
        property bool dbChanged

        onContentsChanged: {
            if (!loaded) {
                //print(JSON.stringify(storage.contents))
                if (contents && contents.hasOwnProperty("contents")) {
                    doc.fromJSON(contents["contents"])
                }

                loaded = true
            }
        }

        Component.onDestruction: save()

        function save() {
            var start = new Date()
            var json = {}
            //json = storage.contents
            json["contents"] = doc.toJSON()
            //print(JSON.stringify(json.contents))
            storage.contents = json

            var end = new Date()

            print("Saving completed in " + (end - start) + " milliseconds")
        }
    }
}
