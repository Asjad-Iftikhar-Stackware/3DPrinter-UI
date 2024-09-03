import QtQuick 2.15

// Main body of the joystick
Rectangle {
    id: joystick
    implicitWidth: 211
    implicitHeight: 543

    property real minValue: -100
    property real maxValue: 100

    // Signal definitions
    signal plusAreaActivated()
    signal minusAreaActivated()
    radius: 21
    color: light
    border.color: dark
    border.width: 7

    // Line in the middle of joystick
    Rectangle {
        id: joystickCenterLine
        width: parent.width
        height: 7
        anchors.centerIn: parent
        color: dark
        border.color: dark
        border.width: 7
    }

    // Joystick handle
    Rectangle {
        id: joystickHandle
        width: 157
        height: 106
        radius: 15
        y:parent.height/2 - height/2
        x:parent.width/2 - width/2
        color: dark
        border.color: darkest
        border.width: 7

        Drag.active: dragArea.drag.active
        Drag.hotSpot.x: 10
        Drag.hotSpot.y: 10

        // Mouse area for dragging
        MouseArea {
            id: dragArea
            anchors.fill: joystickHandle
            drag.target: joystickHandle
            drag.axis: Drag.YAxis

            onReleased: {
                // Transition back to center
                returnAnimation.start()
            }

            onPositionChanged: {
                // Ensure handle stays within joystick bounds
                if (joystickHandle.y < 0) {
                    joystickHandle.y = 0
                } else if (joystickHandle.y > joystick.height - joystickHandle.height) {
                    joystickHandle.y = joystick.height - joystickHandle.height
                }

                // Calculate joystick value based on handle position
                var handleRange = joystick.height - joystickHandle.height
                var newValue = Math.round((joystickHandle.y / handleRange) * (maxValue - minValue) + minValue)
                // You can now use `newValue` to update something if needed

                // Emit signals based on handle position
                if (joystickHandle.y < joystick.height / 4)
                {
                    plusAreaActivated();
                    console.log("plusarea");
                }
                else if (joystickHandle.y > 3 * joystick.height / 4)
                {
                    minusAreaActivated();
                    console.log("minusarea");
                }
            }
        }

        // Animation for smooth transition back to center
        NumberAnimation {
            id: returnAnimation
            target: joystickHandle
            property: "y"
            duration: 200
            easing.type: Easing.InOutQuad
            to: joystick.height / 2 - joystickHandle.height / 2
        }
    }

    //Plus and Minus areas for button feedback
    Rectangle {
        id: plusArea
        width: joystick.width
        height: joystick.height / 4
        color: "transparent"
        anchors.top: joystick.top
        anchors.left: joystick.left
        anchors.right: joystick.right

        MouseArea {
            anchors.fill: parent
            preventStealing: true
            onClicked: {
                plusAreaActivated()
                console.log("plus")
            }
        }
    }

    Rectangle {
        id: minusArea
        width: joystick.width
        height: joystick.height / 4
        color: "transparent"
        anchors.bottom: joystick.bottom
        anchors.left: joystick.left
        anchors.right: joystick.right

        MouseArea {
            anchors.fill: parent
            preventStealing: true
            onClicked: {
                minusAreaActivated()
                console.log("minus")
            }
        }
    }
}
