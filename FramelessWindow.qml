import QtQuick 2.7
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

Window {
    id: window
//    default property alias container: contentview
    property alias contentView: contentview
    property alias windowBorder: windowborder
    property alias mouseArea: mousearea
    property bool enableResize: true
    property bool enableShadow: true
    width: 640
    height: 480
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.Window
    title: qsTr("Hello World")

    onEnableShadowChanged: {
        windowborder.visible = enableShadow
    }

    property variant showAnimation: ParallelAnimation {
        running: visible
        NumberAnimation {
            target: window
            property: "opacity"
            duration: 300
            from: 0; to: 1
        }
        SequentialAnimation {
            ScriptAction { script: windowBorder.visible = false }
            NumberAnimation {
                target: contentView
                property: "scale"
                duration: 300
                from: 0.9; to: 1
            }
            ScriptAction { script: windowBorder.visible = true }
        }
    }

    Rectangle {
        id: windowborder
        color: "transparent"
        anchors.fill: parent
        anchors.margins: enableShadow ? 20 : 0
        radius: 8
        border { width: 1; color: "gray" }
        layer.enabled: enableShadow
        layer.effect: RectangularGlow {
            id: effect
            anchors.fill: windowborder
            glowRadius: 5
            spread: 0
            color: "black"
            cornerRadius: windowborder.radius + glowRadius
        }
    }

    Item {
        id: contentview
        width: windowborder.width; height: windowborder.height
        anchors.centerIn: parent
        MouseArea {
            id: mousearea
            hoverEnabled: true
            property variant pressPoint: Qt.point(0, 0)
            property int borderWidth: 5
            property string hitType: "center"
            cursorShape: {
                if (!enableResize) return Qt.ArrowCursor
                switch (hitType) {
                case "top-left":
                    break
                case "bottom-left":
                    break
                case "left":
                    break
                case "top":
                    break
                case "bottom":
                    return Qt.SizeVerCursor
                case "center":
                    break
                case "top-right":
                    break
                case "bottom-right":
                    return Qt.SizeFDiagCursor
                case "right":
                    return Qt.SizeHorCursor
                }
                return Qt.ArrowCursor
            }

            function checkHitType () {
                if (!enableResize) return "center"
                if (mouseX < borderWidth) {
                    return mouseY < borderWidth
                            ? "top-left"
                            : mouseY > height - borderWidth
                              ? "bottom-left"
                              : "left"
                }
                else if (mouseX < width - borderWidth) {
                    return mouseY < borderWidth
                            ? "top"
                            : mouseY > height - borderWidth
                              ? "bottom"
                              : "center"
                }
                else if (mouseX > width - borderWidth) {
                    return mouseY < borderWidth
                            ? "top-right"
                            : mouseY > height - borderWidth
                              ? "bottom-right"
                              : "right"
                }
                return "center"
            }

            anchors.fill: parent
            onPressed: {
                pressPoint.x = mouseX
                pressPoint.y = mouseY
                hitType = checkHitType()
            }
            onPositionChanged:  {
                if (!pressed) {
                    hitType = checkHitType()
                    return
                }

                switch (hitType) {
                case "top-left":
                    break
                case "bottom-left":
                    break
                case "left":
                    break
                case "top":
                    break
                case "bottom":
                    var temp = window.height + mouseY - pressPoint.y
                    if (temp < maximumHeight && temp > minimumHeight) {
                        window.height = temp
                        pressPoint.y = mouseY
                    }
                    else if (temp > maximumHeight) {
                        window.height = maximumHeight
                    }
                    else {
                        window.height = minimumHeight
                    }
                    break
                case "top-right":
                    break
                case "bottom-right": {
                    var temp = window.width + mouseX - pressPoint.x
                    if (temp < maximumWidth && temp > minimumWidth) {
                        window.width = temp
                        pressPoint.x = mouseX
                    }
                    else if (temp > maximumWidth) {
                        window.width = maximumWidth
                    }
                    else {
                        window.width = minimumWidth
                    }
                    temp = window.height + mouseY - pressPoint.y
                    if (temp < maximumHeight && temp > minimumHeight) {
                        window.height = temp
                        pressPoint.y = mouseY
                    }
                    else if (temp > maximumHeight) {
                        window.height = maximumHeight
                    }
                    else {
                        window.height = minimumHeight
                    }
                }
                    break
                case "right":
                    var temp = window.width + mouseX - pressPoint.x
                    if (temp < maximumWidth && temp > minimumWidth) {
                        window.width = temp
                        pressPoint.x = mouseX
                    }
                    else if (temp > maximumWidth) {
                        window.width = maximumWidth
                    }
                    else {
                        window.width = minimumWidth
                    }
                    break
                case "center":
                    window.x += mouseX - pressPoint.x
                    window.y += mouseY - pressPoint.y
                    break
                }
            }
        }
    }
}
