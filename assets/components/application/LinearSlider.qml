import QtQuick
import QtQuick.Controls

Rectangle{
    id:root
    implicitWidth: 473
    implicitHeight: 86
    radius: 18
    color:dark

    property real value
    property real to
    property real from

    Slider {
        id: slider1
        value: root.value
        from: root.from
        to: root.to
        leftPadding: 12
        topPadding: 5
        bottomPadding: 5


        background: Rectangle {
            id: progressBackground
            x: slider1.leftPadding
            y: slider1.topPadding + slider1.availableHeight / 2 - height / 2
            implicitWidth: root.width - 120
            implicitHeight: root.height * 0.80
            width: slider1.availableWidth
            height: implicitHeight
            color: dark

            Rectangle {
                id: progressForeground
                width: slider1.visualPosition * parent.width
                height: parent.height
                color: darkest
                radius: 18
            }
        }

        handle: Rectangle {
            x: slider1.leftPadding + slider1.visualPosition * (slider1.availableWidth - width)
            y: slider1.topPadding + slider1.availableHeight / 2 - height / 2
            implicitWidth: 36
            implicitHeight:root.height * 76/86
            radius: width/2
            color: darkest
            border.color: darkest
        }

    }
    //separater rectangle
    Rectangle{
        id:separater
        width: 10
        radius: 18
        x: slider1.width + 5
        y: slider1.topPadding + slider1.availableHeight / 2 - height / 2
        height: parent.height * 0.75
        color: light
    }

    Label{
        id: label1
        text: Math.round(slider1.value) + "%"
        font.pointSize: 24
        topPadding: root.height / 4 + 3
        anchors.right: root.right
        anchors.rightMargin: 20

        color: light
    }

}
