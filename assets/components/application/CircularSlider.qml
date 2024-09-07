import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import QtQml

Rectangle {
    id: root
    color: "transparent"

    // This property holds the width of the track arc.
    property int trackWidth: 30

    // This property holds the width of the progress arc.
    property int progressWidth: 30

    // This property holds the width of the default slider handle.
    property int handleWidth: 36

    /*!
        \qmlproperty real CircularSlider::handleHeight
        This property holds the height of the default slider handle.
    */
    property int handleHeight: 60

    /*!
        \qmlproperty real CircularSlider::handleRadius
        This property holds the corner radius used to draw a rounded rectangle for the slider handle.
    */
    property int handleRadius: 11

    /*!
        \qmlproperty CircularSlider::handleVerticalOffset
        This property defines the offset in which the handle should be placed.
     */
    property int handleVerticalOffset: 0

    /*!
        \qmlproperty real CircularSlider::startAngle
        This property holds the start angle of the slider.
        The range is from \c 0 degrees to \c 360 degrees.
    */
    property real startAngle: -120

    /*!
        \qmlproperty real CircularSlider::endAngle
        This property holds the end angle of the slider.
        The range is from \c 0 degrees to \c 360 degrees.
    */
    property real endAngle: 120

    /*!
        \qmlproperty real CircularSlider::minimumValue
        This property holds the minimum value of the slider.
        The default value is \c{0.0}.
    */
    property real minValue: 0

    /*!
        \qmlproperty real CircularSlider::maximumValue
        This property holds the minimum value of the slider.
        The default value is \c{1.0}.
    */
    property real maxValue: 300

    /*!
        \qmlproperty real CircularSlider::value
        This property holds the current value of the slider.
        The default value is \c{0.0}.
    */
    property real value: 150

    /*!
        \qmlproperty real CircularSlider::angle
        \readonly
        This property holds the angle of the handle.
        The range is from \c -180 degrees to \c 180 degrees.
    */
    readonly property real angle: internal.normalizeAngle(internal.angle)

    /*!
        \qmlproperty enumeration CircularSlider::capStyle
        This property defines how the end points of lines are drawn. The default value is Qt.RoundCap.
     */
    property int capStyle: Qt.RoundCap

    /*!
        \qmlproperty real CircularSlider::trackColor
        This property holds the fill color for the track.
    */
    property color trackColor: dark

    /*!
        \qmlproperty real CircularSlider::progressColor
        This property holds the fill color for the progress.
    */
    property color progressColor: darkest

    /*!
        \qmlproperty real CircularSlider::handleColor
        This property holds the fill color for the handle.
    */
    property color handleColor: darkest

    /*!
        \qmlproperty real CircularSlider::warningColor
        This property holds the color for the progress bar when it's in warning state.
    */
    property color warningColor: "red"

    /*!
        \qmlproperty real CircularSlider::stepSize
        This property holds the step size. The default value is 0.0
        The step size determines the amount by which the slider's value is increased and decreased when interacted.
        The step size is only respected when snap is set to value true
    */
    property real stepSize: 1

    /*!
        \qmlproperty CircularSlider::snap
        This property holds whether the value should be snapped or not.
        The default value is false.
    */
    property bool snap: false

    /*!
        \qmlproperty real CircularSlider::handle
        This property holds the custom handle of the dial.
    */
    property Component handle: null

    /*!
        \qmlproperty bool CircularSlider::pressed
        \readonly
        This property indicates whether the slider handle is being pressed.
    */
    readonly property alias pressed: trackMouse.pressed

    /*!
        \qmlproperty CircularSlider::hideTrack
        This property holds whether the track should be shown or not.
        The default value is false.
    */
    property bool hideTrack: false

    /*!
        \qmlproperty CircularSlider::hideProgress
        This property holds whether the progress should be shown or not.
        The default value is false.
    */
    property bool hideProgress: false

    /*!
        \qmlproperty CircularSlider::interactive
        This property describes whether the user can interact with the Flickable.
        A user cannot drag the handle or click on the slider that is not interactive.
        Slider can be used as a progress indicator by setting interactive to false.
        The default value is true.
    */
    property bool interactive: true

    /*!
        \qmlproperty CircularSlider::interactive
        This property holds the cursor shape for this mouse area.
        On platforms that do not display a mouse cursor this may have no effect.
        The default value is Qt.ArrowCursor.
    */
    property alias cursorShape: trackMouse.cursorShape

    // hardcoded value for the progress bar
    property real hardcodedProgress: 100

    implicitWidth: 300
    implicitHeight: 300

    property real targetValue

    Binding {
        target: root
        property: "value"
        value: root.snap ? internal.snappedValue : internal.mapFromValue(startAngle, endAngle, minValue, maxValue, internal.angleProxy)
        when: internal.setUpdatedValue
        restoreMode: Binding.RestoreBinding
    }

    QtObject {
        id: internal

        property var centerPt: Qt.point(root.width / 2, root.height / 2)
        property real baseRadius: Math.min(root.width, root.height) / 2 - Math.max(root.trackWidth, root.progressWidth) / 2
        property real actualSpanAngle: root.endAngle - root.startAngle
        property color transparentColor: "transparent"
        property color trackColor: root.trackColor
        property bool setUpdatedValue: false
        property real angleProxy: root.startAngle
        property real snappedValue: 0.0

        readonly property real angle: normalizeAngle(mapFromValue(root.minValue, root.maxValue, root.startAngle, root.endAngle, root.value))

        function mapFromValue(inMin, inMax, outMin, outMax, inValue) {
            return (inValue - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
        }

        function mapAngleToValue(angleVal) {
            return mapFromValue(root.startAngle, root.endAngle, root.minValue, root.maxValue, normalizeAngle(angleVal));
        }

        function normalizeAngle(angle) {
            while (angle < -180) angle += 360;
            while (angle > 180) angle -= 360;
            return angle;
        }

        function updateAngle(angleVal) {
            var normalizedAngle = normalizeAngle(angleVal);
            if (normalizedAngle >= root.startAngle && normalizedAngle <= root.endAngle) {
                internal.setUpdatedValue = true;
                internal.angleProxy = Qt.binding(function() { return normalizedAngle; });
                if (root.snap) {
                    var mappedValue = mapAngleToValue(normalizedAngle);
                    var actualVal = root.stepSize * Math.round(mappedValue / root.stepSize);
                    internal.snappedValue = actualVal;
                }
                internal.setUpdatedValue = false;
            }
        }
    }

    // Track Shapes
    Shape {
        id: trackShape

        width: root.width
        height: root.height
        layer.enabled: true
        layer.samples: 8
        visible: !root.hideTrack

        ShapePath {
            id: trackShapePath

            strokeColor: root.trackColor
            fillColor: internal.transparentColor
            strokeWidth: root.trackWidth
            capStyle: root.capStyle

            PathAngleArc {
                radiusX: internal.baseRadius
                radiusY: internal.baseRadius
                centerX: root.width / 2
                centerY: root.height / 2
                startAngle: root.startAngle - 90
                sweepAngle: internal.actualSpanAngle
            }
        }
    }

    // Progress Shape
    Shape {
        id: progressShape

        width: root.width
        height: root.height
        layer.enabled: true
        layer.samples: 8
        visible: !root.hideProgress

        ShapePath {
            id: progressShapePath

            strokeColor: root.progressColor
            fillColor: internal.transparentColor
            strokeWidth: root.progressWidth
            capStyle: root.capStyle

            PathAngleArc {
                radiusX: internal.baseRadius
                radiusY: internal.baseRadius
                centerX: root.width / 2
                centerY: root.height / 2
                startAngle: root.startAngle - 90
                sweepAngle: internal.mapFromValue(root.minValue, root.maxValue, 0, 240, root.targetValue )
            }
        }
    }

    // Animation for progress bar
    NumberAnimation {
        id: returnAnimation
        target: progressShapePath
        property: "sweepAngle"
        duration: 5000
        easing.type: Easing.InOutQuad
        to: root.angle - root.startAngle
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.interactive
        onClicked: {
            var outerRadius = Math.min(root.width, root.height) / 2;
            var innerRadius = outerRadius - Math.max(root.trackWidth, 20);
            var clickedDistance = (mouseX - internal.centerPt.x) * (mouseX - internal.centerPt.x) + (mouseY - internal.centerPt.y) * (mouseY - internal.centerPt.y);
            var innerRadius2 = (innerRadius * innerRadius);
            var outerRadius2 = (outerRadius * outerRadius);
            var isOutOfInnerRadius = clickedDistance > innerRadius2;
            var inInSideOuterRadius = clickedDistance <= outerRadius2;
            if (inInSideOuterRadius && isOutOfInnerRadius) {
                var angleDeg = Math.atan2(mouseY - internal.centerPt.y, mouseX - internal.centerPt.x) * 180 / Math.PI + 90;
                root.targetValue = internal.mapAngleToValue(root.startAngle, root.endAngle, 0, 100, angleDeg);
                internal.updateAngle(angleDeg);
                returnAnimation.to = root.targetValue;  // Set the target value for the animation
                returnAnimation.start();  // Start the animation
            }
        }
    }

    // Handle Item
    Item {
        id: handleItem
        visible: root.interactive

        x: root.width / 2 - width / 2
        y: root.height / 2 - height / 2
        // make sure that the slider handle is always on top as we can set custom track or progress items
        z: 2
        width: root.handleWidth
        height: root.handleHeight
        antialiasing: true
        transform: [
            Translate {
                y: -(Math.min(root.width, root.height) / 2) + Math.max(root.trackWidth, root.progressWidth) / 2 + root.handleVerticalOffset
            },
            Rotation {
                angle: root.angle
                origin.x: handleItem.width / 2
                origin.y: handleItem.height / 2
            }
        ]

        MouseArea {
            id: trackMouse
            enabled: root.interactive

            function getVal() {
                var handlePoint = mapToItem(root, trackMouse.mouseX, trackMouse.mouseY);
                // angle in degrees
                var angleDeg = Math.atan2(handlePoint.y - internal.centerPt.y, handlePoint.x - internal.centerPt.x) * 180 / Math.PI + 90;
                // root.targetValue = internal.mapFromValue(root.startAngle, root.endAngle, root.minValue, root.maxValue, angleDeg);
                internal.updateAngle(angleDeg);
            }

            anchors.fill: parent
            onPositionChanged: getVal()
            onClicked: getVal()
            cursorShape: Qt.ArrowCursor
        }

        Loader {
            id: handleLoader

            sourceComponent: root.handle ? handle : handleComponent
        }
    }

    /// Default handle component
    Component {
        id: handleComponent

        Rectangle {
            width: root.handleWidth
            height: root.handleHeight
            color: root.handleColor
            radius: root.handleRadius
            antialiasing: true
        }
    }

    // Minimum degrees
    Label {
        id: minDegreeValue
        text: root.minValue + "°C"
        anchors.bottom: root.bottom
        anchors.left: root.left
        leftPadding: 20
        bottomPadding: 35
        color: darkest
        font.bold: true
        font.pointSize: 14
    }

    // Maximum degrees
    Label {
        id: maxDegreeValue
        text: root.maxValue + "°C"
        anchors.bottom: root.bottom
        anchors.right: root.right
        rightPadding: 15
        bottomPadding: 35
        color: darkest
        font.bold: true
        font.pointSize: 14
    }

    // Progress temperature
    Label {
        id: centerProgressValue
        text: Math.round(root.targetValue) + "°C"
        anchors.centerIn: root
        bottomPadding: 20
        color: darkest
        font.bold: true
        font.pointSize: 40


    }

    // Set handle temperature
    Label {
        id: centerHandleValue
        text: Math.round(root.value) + "°C"
        anchors.centerIn: root
        anchors.topMargin: 20
        topPadding: 80
        color: darkest
        font.bold: true
        font.pointSize: 28

        // Watch for changes in the targetValue and update color accordingly
        onTextChanged: {
            centerProgressValue.color = Math.abs(root.value - root.targetValue) > 5 ? "red" : darkest;
        }
    }
}
