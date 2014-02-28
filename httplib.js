/***************************************************************************
 * Whatsoever ye do in word or deed, do all in the name of the             *
 * Lord Jesus, giving thanks to God and the Father by him.                 *
 * - Colossians 3:17                                                       *
 *                                                                         *
 * Click App Store - An app for viewing the available Ubuntu Touch apps    *
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
.pragma library

function post(path, options, callback, args, body) {
    return request(path, "POST", options, callback, args, body)
}

function put(path, options, callback, args) {
    return request(path, "PUT", options, callback, args)
}

//function delete(path, options, callback, args) {
//    request(path, "DELETE", options, callback, args)
//}

function get(path, options, callback, args) {
    return request(path, "GET", options, callback, args)
}

function request(path, call, options, callback, args, body) {
    var address = path

    if (options === undefined)
        options = []

    if (options.length > 0)
        address += "?" + options.join("&").replace(" ", "+")

    print(call, address)

    var doc = new XMLHttpRequest();
    doc.timeout = 4000;
    doc.onreadystatechange = function() {
        if (doc.readyState === XMLHttpRequest.DONE) {
            print(doc.getResponseHeader("X-RateLimit-Remaining"))
            print(doc.responseText)
            print("Status:",doc.status)
            if (callback !== undefined) {
                if (doc.status == 200)
                    callback(doc.responseText, doc.statusargs)
                else
                    callback(-1, doc.status, args)
            }
        }
     }
    doc.ontimeout = function () {
        callback(-1, 0, args)
    }

    doc.open(call, address, true);
    if (body)
        doc.send(body)
    else
        doc.send();

    return doc
}
