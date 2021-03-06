/*
 *   Copyright 2012 Arthur Taborda <arthur.hvt@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick 1.0
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.qtextracomponents 0.1 as QtExtras

import "plasmapackage:/code/logic.js" as Logic

Item {
    property alias running: timer.running
    
    property string stopButtonImage: "media-playback-stop"
    property string playButtonImage: "media-playback-start"
    property string pauseButtonImage: "media-playback-pause"
    
    property string timeText: Qt.formatTime(new Date(0,0,0,0,0, seconds), "mm:ss")
    
    property int seconds
    property int totalSeconds
    
    property int taskId
    
    signal stoped()
    signal breakEnded()
    signal pomodoroEnded()
    
    onTotalSecondsChanged: {
        console.log("changed!")
        seconds = totalSeconds;
    } 
    
    function progressBarSize() {
        var pct = progressBarSize / seconds;
        var width = barBorder.width
        
    }
    
    Row {
        id: buttons
        spacing: 3
        visible: tomatoid.inPomodoro
        
        PlasmaComponents.Button {
            id: playPauseButton
            iconSource: pauseButtonImage
            
            onClicked: {
                if(timer.running) {
                    iconSource = playButtonImage;
                } else {
                    iconSource = pauseButtonImage;
                }
                
                timer.running = !timer.running
            }
        }
        
        PlasmaComponents.Button {
            id: stopButton
            iconSource: stopButtonImage
            
            onClicked: stoped()
        }
    }
    
    PlasmaComponents.ProgressBar {
        id: progressBar
        minimumValue: 0
        maximumValue: 1
        value: seconds / totalSeconds
        anchors {
            margins: 4
            left: {
                if(buttons.visible)
                    return buttons.right
                    else 
                        return parent.left
            }
            right: parent.right
            bottom: parent.bottom
            top: parent.top
        }
        
        Rectangle {
            radius: 5
            width: 48
            height: 18
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }            
        }
        
        PlasmaComponents.Label {
            text: timeText
            font.bold: true
            font.pointSize: 13
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
        }
    }
    
    
    Timer {
        id: timer
        interval: 1000
        running: false
        repeat: true
        
        onTriggered: {
            console.log(seconds)
            if(seconds > 1) {
                seconds -= 1;
            } else {
                totalSeconds = 0;
                if(tomatoid.inPomodoro)
                    pomodoroEnded()
                    else
                        breakEnded()
            }
        }
    }
}