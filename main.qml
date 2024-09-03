import QtQuick
import "qrc:/assets/components/application"

Window {
    width: 1600
    height: 800
    visible: true

    property color darkest: "#0E3E45"
    property color dark: "#33676B"
    property color light: "#B6D7D3"
    property color lightest: "#FFFFFF"

    Rectangle{
        id:mainBackground
        width: 1562
        height: 777
        anchors.fill: parent
        color: light
        radius: 80
        anchors.margins: 10



        LinearSlider{
            id:ventilator
            width: 473
            height: 86
            x:698
            y:62
        }


        Rectangle{
            id:pression
            width: 473
            height: 86
            radius: 18
            x:698
            y:208
            color: dark
        }

        Image {
            id: icon_ventilator
            source: "qrc:/assets/images/exhaust-pipe.svg"
            x:537
            y:37
            width: 70
            height: 70
        }

        Image {
            id: icon_pression
            source: "qrc:/assets/images/resilience.svg"
            x:537
            y:200
            width: 70
            height: 70
        }

        Image {
            id: icon_3dprint
            source: "qrc:/assets/images/3d-print.svg"
            x:89
            y:251
            width: 252
            height: 252
        }

        Image {
            id: icon_temp1
            source: "qrc:/assets/images/temperature.svg"
            x:449
            y:670
            width: 76
            height: 76
        }

        Image {
            id: icon_temp2
            source: "qrc:/assets/images/temperature.svg"
            x:842
            y:670
            width: 76
            height: 76
        }

        Rectangle{
            id:e1_pageIndicator
            width: 22
            height: 22
            x: 185
            y: 536
            color: darkest
            radius: 12
        }

        Rectangle{
            id:e2_pageIndicator
            width: 22
            height: 22
            x: 226
            y: 536
            color: dark
            radius: 12
        }
    }

    CircularSlider {

    }

    Joystick {
        x: 1293
        y: 114
    }
}
