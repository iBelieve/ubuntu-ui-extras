import QtQuick 2.0
import Ubuntu.Components.Themes.Ambiance 0.1

TextFieldStyle {

    color: (styledItem.focus || styledItem.highlighted) ? Theme.palette.normal.overlayText : Theme.palette.normal.baseText
    backgroundColor: (styledItem.focus || styledItem.highlighted) ? Theme.palette.selected.field : Qt.rgba(0.5,0.5,0.5,0.4)
}
