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

PageStack {
    id: pageStack

    function internalPush(page, properties) {
        PageStack.push(pageStack, page, properties)
//        if (internal.stack.size() > 0) internal.stack.top().active = false;
//        __
//        internal.stack.push(internal.createWrapper(page, properties));
//        internal.stack.top().active = true;
//        internal.stackUpdated();
    }

    function internalPop() {
        if (internal.stack.size() < 1) {
            print("WARNING: Trying to pop an empty PageStack. Ignoring.");
            return;
        }
        internal.stack.top().active = false;
        if (internal.stack.top().canDestroy) internal.stack.top().destroyObject();
        internal.stack.pop();
        internal.stackUpdated();

        if (internal.stack.size() > 0) internal.stack.top().active = true;
    }

    function pop() {
        currentPage.first = false
        internalPop()

        while (!currentPage.show) {
            internalPop()
            currentPage.first = false
            internalPop()
        }

        currentPage.first = true
    }

    function push(page) {
        if (currentPage != null)
            currentPage.first = false
        page.first = true

        if (page.show)
            internalPush(page)
    }
}
