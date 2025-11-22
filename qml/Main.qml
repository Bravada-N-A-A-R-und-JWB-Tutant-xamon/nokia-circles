/*JasonWalt Bab@'s traduccions y proyectos Team БаZa productions
* Khmelyauskas Alexander Eduardovich "Knyaz'", a.k.a JasonWalt Bab@
* Screensaver from my childhood (2012-2015) - Nokia "Dumbphone" Circles
* Main Solo
* Use, modify or do something else by feeling free
* Created with Qt 5.14 QC (Qt Creator) Windows 10 - MinGW 64-bit
* Ubuntu Touch 20.04 (OTA-9) & Ubuntu Touch 24.04
* Main.qml
*/
import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
//import Lomiri.Components 1.3 <-- We don't use this library - for avoiding the Syntax Error or App Crashing (We use only 100% Pure QML/Qt QC)

Window { //Not MainView XD
    id: root
    width: 640
    height: 480
    visible: true
    color: transparentWindow ? "transparent" : "#111"
    title: qsTr("Circles!") //Not application name XD
    property int spawnCount: spawnSlider.value
    property int minCircleSize: minSizeSlider.value
    property int maxCircleSize: maxSizeSlider.value
    property string easingMode: easingBox.currentText
    property int spawnSpeed: 20
    property bool transparentWindow: true

    // Функция для получения easing
    function getEasing() {
        switch (easingMode) {
        case "Linear": return Easing.Linear
        case "Quad":   return Easing.InOutQuad
        case "Cubic":  return Easing.InOutCubic
        }
        return Easing.Linear
    }

    Timer {
        id: timer
        interval: spawnSpeedSlider.value
        running: true
        repeat: true
        onTriggered: {
            for (let i = 0; i < spawnCount; i++) {
                circleComponent.createObject(root, {
                    "x": Math.random() * root.width,
                    "y": Math.random() * root.height,
                    "size": minCircleSize + Math.random() * (maxCircleSize - minCircleSize),
                    "color": Qt.hsla(Math.random(), 1, 0.5, 1),
                    "easingType": getEasing()
                })
            }
        }
    }

    Component {
        id: circleComponent
        Rectangle {
            id: circle
            property real size
            property var easingType

            width: size
            height: size
            radius: size / 2
            opacity: 0
            scale: 0
            transformOrigin: Item.Center

            SequentialAnimation {
                running: true

                // Плавное появление
                ParallelAnimation {
                    NumberAnimation {
                        target: circle
                        property: "scale"
                        to: 1
                        duration: 600
                        easing.type: circle.easingType
                    }
                    NumberAnimation {
                        target: circle
                        property: "opacity"
                        to: 1
                        duration: 300
                    }
                }

                PauseAnimation { duration: 300 }

                // Плавное исчезновение
                NumberAnimation {
                    target: circle
                    property: "opacity"
                    to: 0
                    duration: 500
                }

                PauseAnimation { duration: 50 }

                ScriptAction { script: circle.destroy() }
            }
        }
    }


    Column {
        spacing: 8
        padding: 10
       z: 1000
        ComboBox {
            id: easingBox
            model: [qsTr("Linear"), qsTr("Quad"), qsTr("Cubic")]
            currentIndex: 2
        }

        Text { text: qsTr("Circles Count: ") + spawnSlider.value; color: "white" }
        Slider {
            id: spawnSlider
            from: 1; to: 20
            value: 3
        }

        Text { text: qsTr("Min Size: ") + minSizeSlider.value; color: "white" }
        Slider {
            id: minSizeSlider
            from: 10; to: 150
            value: 40
        }

        Text { text: qsTr("Max Size: ") + maxSizeSlider.value; color: "white" }
        Slider {
            id: maxSizeSlider
            from: minSizeSlider.value + 5; to: 600
            value: 120
        }
        Text { text: qsTr("Spawn Speed: ") + spawnSpeedSlider.value; color: "white" }
        Slider {
            id: spawnSpeedSlider
            from: 1; to: 600
            value: spawnSpeed = value
            onValueChanged: spawnSpeed = value
        }
        Text { text: qsTr("Transparent Window"); color: "white" }
        CheckBox {
            id: twButton
            width: 60
            height: 30
            onClicked: transparentWindow = !transparentWindow
            checked: true //Fix-up
        }
    }
}