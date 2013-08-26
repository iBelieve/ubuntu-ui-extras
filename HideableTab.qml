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
 * the Free Software Foundation, either version 3 of the License, or       *
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
import Ubuntu.Components.ListItems 0.1

Tab {
    id: root

    property bool show: true

    onShowChanged: {
        parent.tabList = customUpdateTabList(parent)
    }

    Connections {
        target: root.parent
        onChildrenChanged: customUpdateTabList(parent)
    }

    function customUpdateTabList(tabsModel) {
        var list = [];
        for (var i=0; i < tabsModel.children.length; i++) {
            if (isTab(tabsModel.children[i])) list.push(tabsModel.children[i]);
        }
        return list
    }

    function isTab(item) {
        if (item && item.hasOwnProperty("__isPageTreeNode")
                && item.__isPageTreeNode && item.hasOwnProperty("title")
                && item.hasOwnProperty("page")
                && (item.hasOwnProperty("show") ? item.show : true)) {
            return true;
        } else {
            return false;
        }
    }
}
