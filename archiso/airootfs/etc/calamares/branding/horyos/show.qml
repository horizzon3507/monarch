/* HoryOS Calamares slideshow — single minimal card */

import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    Timer {
        interval: 20000
        running: presentation.currentSlide >= 0
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#11131a"
            Column {
                anchors.centerIn: parent
                spacing: 16
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "HoryOS"
                    color: "#8ab4f8"
                    font.pixelSize: 64
                    font.weight: Font.Bold
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Arch-based · Hyprland · rolling"
                    color: "#cdd6f4"
                    font.pixelSize: 20
                }
            }
        }
    }
}
