import QtQuick
import QtQuick.Controls
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
            value: 50
            from: 0
            to: 100
        }


        LinearSlider{
            id:pression
            width: 473
            height: 86
            radius: 18
            x:698
            y:208
            value: 50
            from: 0
            to: 100
        }

        Image {
            id: icon_ventilator
            source: "qrc:/assets/images/exhaust-pipe.svg"
            x:537
            y:37
            width: 70
            height: 70
        }

        Text{
            id:textVentilator
            text:"Ventilateur"
            font.pointSize: 20
            font.bold: true
            color: darkest
            x: icon_ventilator.x - 35
            y: icon_ventilator.y + icon_ventilator.height + 15
        }

        Image {
            id: icon_pression
            source: "qrc:/assets/images/resilience.svg"
            x:537
            y:200
            width: 70
            height: 70
        }

        Text{
            id:textPressoion
            text:"Pression"
            font.pointSize: 20
            font.bold: true
            color: darkest
            x: icon_pression.x - 15
            y: icon_pression.y + icon_pression.height + 5
        }

        Image {
            id: icon_3dprint
            source: "qrc:/assets/images/3d-print.svg"
            x:89
            y:251
            width: 252
            height: 252
        }

        // E1 and E2 page switch button
        Button {
            id:pageSwitchButton
            x:190
            y:570
            width: 51 +10
            height: 40 +10
            background: dark
            onClicked: console.log("presses")

            Label{
                id:e1ButtonText
                text: "E1"
                font.pixelSize: pageSwitchButton.height
                font.bold: true
                color: darkest
            }

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
