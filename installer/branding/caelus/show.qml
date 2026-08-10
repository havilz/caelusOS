import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    Timer {
        interval: 8000
        running: true
        repeat: true
        onTriggered: presentation.nextSlide()
    }

    Slide {
        Text {
            anchors.centerIn: parent
            text: "Welcome to CaelusOS\nThe Ultimate Dedicated Developer Operating System"
            font.pixelSize: 22
            font.bold: true
            color: "#00d2ff"
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Slide {
        Text {
            anchors.centerIn: parent
            text: "Pre-Packed Container & Database Suite\nDocker Engine, Podman, LazyDocker, PostgreSQL, and Redis out-of-the-box"
            font.pixelSize: 20
            color: "#e2e8f0"
            horizontalAlignment: Text.AlignHCenter
        }
    }

    Slide {
        Text {
            anchors.centerIn: parent
            text: "Caelus Developer Toolbox (caelus-toolbox)\n1-Click On-Demand Compiler & SDK Auto-Installer from your Terminal"
            font.pixelSize: 20
            color: "#7928ca"
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
