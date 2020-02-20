import QtQuick 2.10
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
Rectangle {
    id:main
    width: parent.width
    height: parent.height
    color: "#00000000"
    property int listViewMsgHeight: 0
    onVisibleChanged: {
        if(visible==false)
        {
            friendLoginPrm.text=""
            friendNamePrm.text=""
            messagesArea.text=""
            myShortCut.enabled=false
        }
        else
            myShortCut.enabled=true
    }

    Connections{
        target: appCore

        onShowIFriendInQml:{
            friendLoginPrm.text=login
            friendNamePrm.text=name
            messagesArea.text=""
            sendMsgBodyArea.text=""
            if(appCore.getCallSize()===0 & appCore.getConferenceSize()===0)
            {
                imageCall.visible=true
                imageCallOff.visible=false
                callOffArea.visible=false
                makeCallArea.visible=true
            }
            else
            {
                imageCall.visible=false
                imageCallOff.visible=true
                callOffArea.visible=true
                makeCallArea.visible=false
            }
            if(callingState==0)
            {
                callRec.height=0
                callImg.visible=true
                callRecProcess.visible=false
                hangupCallRec.visible=false
            }
            if(callingState==1)
            {
                callRec.height=200
                callImg.visible=true
                callRecProcess.visible=false
                hangupCallRec.visible=true

            }
            if(callingState==2)
            {
                callRec.height=200
                callImg.visible=false
                callRecProcess.visible=true
                hangupCallRec.visible=true
            }
        }
        onShowNewMsgInQml:{
            if(friendLoginPrm.text==sender | sender=="Вы")
            {
                if(sender=="Вы")
                {
                    messagesArea.append("<font color='green'>"+sender+":</font>")
                    sendMsgBodyArea.text=""
                }
                else
                {
                    messagesArea.append("<font color='blue'>"+sender+":</font>")
                }
                messagesArea.append(msg+
                                    "<br><font size='1' color='#655881'>"+
                                    dateTime+
                                    "</font><br>"+
                                    "<img src=qrc:/icons/line.jpg width = 110 height = 1><br>")
            }
        }
        onShowAllMessages:{
            for(var i=0;i<senders.length;i++)
            {
                if(senders[i]==="Вы")
                {
                     messagesArea.append("<font color='green'>"+senders[i]+":</font>")
                }
                else
                {
                    messagesArea.append("<font color='blue'>"+senders[i]+":</font>")
                }
                messagesArea.append(messages[i]+
                                    "<br><font size='1' color='#655881'>"+
                                    dateTimes[i]+
                                    "</font><br>"+
                                    "<img src=qrc:/icons/line.jpg width = 110 height = 1><br>")
            }
        }
        onDefaultVolume:{
            controlVolume.value=1
            controlMic.value=1
        }
    }

    Rectangle{
        id:friendControlRec
        width: parent.width-30
        height: 50
        color: "white"
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 2
        border.width: 1
        border.color: "#cfd2d8"
        Rectangle{
            id:removeFriend
            width: 30
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            color: removeFriendArea.containsMouse?"#eff2f7":"white"
            radius: 2
            MouseArea{
                id:removeFriendArea
                width: parent.width
                height: parent.height
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    appCore.removeFriend(friendLoginPrm.text)
                }

                ToolTip{
                    delay: 1000
                    visible:removeFriendArea.containsMouse?true:false
                    background: Rectangle{
                        border.width: 0
                        color: "#5f000000"
                        radius: 2
                    }
                    Text {
                        text: qsTr("Удалить из друзей")
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 8
                        color: "#e9ebee"
                    }
                }
            }
            Image {
                id: image
                width: 30
                height: 30
                source: "qrc:icons/person-remove.png"
            }
        }
        Rectangle{
            id:makeCallRec
            width: 30
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: removeFriend.left
            anchors.rightMargin: 10
            color: makeCallArea.containsMouse?"#eff2f7":"white"
            radius: 2
            MouseArea{
                id:makeCallArea
                width: parent.width
                height: parent.height
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    appCore.makeCall(friendLoginPrm.text)
                    callRec.height=200
                    imageCall.visible=false
                    imageCallOff.visible=true
                    callOffArea.visible=true
                    makeCallArea.visible=false
                    hangupCallRec.visible=true
                }
                ToolTip{
                    delay: 1000
                    visible:makeCallArea.containsMouse?true:false
                    background: Rectangle{
                        border.width: 0
                        color: "#5f000000"
                        radius: 2
                    }
                    Text {
                        text: qsTr("Позвонить")
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 8
                        color: "#e9ebee"
                    }
                }
            }
            MouseArea{
                id:callOffArea
                width: parent.width
                height: parent.height
                hoverEnabled: true
                ToolTip{
                    delay: 1000
                    visible:callOffArea.containsMouse?true:false
                    background: Rectangle{
                        border.width: 0
                        color: "#5f000000"
                        radius: 2
                    }
                    Text {
                        text: qsTr("У вас уже есть активные звонки")
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 8
                        color: "#e9ebee"
                    }
                }
            }
            Image {
                id: imageCall
                width: 30
                height: 30
                source: "qrc:icons/call.png"
            }
            Image {
                id: imageCallOff
                width: 30
                height: 30
                source: "qrc:icons/off-call.png"
                visible: false
            }
        }
        Rectangle{
            id:hangupCallRec
            width: 30
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: makeCallRec.left
            anchors.rightMargin: 10
            color: hangupCallArea.containsMouse?"#eff2f7":"white"
            radius: 2
            visible: false
            MouseArea{
                id:hangupCallArea
                width: parent.width
                height: parent.height
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    appCore.hangUpCall(friendLoginPrm.text)
                }

                ToolTip{
                    delay: 1000
                    visible:hangupCallArea.containsMouse?true:false
                    background: Rectangle{
                        border.width: 0
                        color: "#5f000000"
                        radius: 2
                    }
                    Text {
                        text: qsTr("Завершить вызов")
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 8
                        color: "#e9ebee"
                    }
                }
            }
            Image {
                id: image233
                width: 30
                height: 30
                source: "qrc:icons/hangup-call.png"
            }
        }

        Rectangle{
            id:friendParametrs
            height: parent.height-18
            width: parent.width/2
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            color: "white"
            clip: true
            Text {
                id: friendLogin
                text: qsTr("Логин:")
                renderType: Text.NativeRendering;
                font.family: "Tahoma"
                font.pointSize: 10
                color: "#655881"
            }
            Text {
                id: friendLoginPrm
                text: qsTr("")
                renderType: Text.NativeRendering;
                anchors.left: friendLogin.right
                anchors.leftMargin: 5
                font.family: "Tahoma"
                font.pointSize: 10
                color: "blue"
            }
            Text {
                id: friendName
                text: qsTr("Имя:")
                anchors.top: friendLogin.bottom
                renderType: Text.NativeRendering;
                font.family: "Tahoma"
                font.pointSize: 10
                color: "#655881"
            }
            Text {
                id: friendNamePrm
                text: qsTr("sasa")
                renderType: Text.NativeRendering;
                anchors.left: friendName.right
                anchors.leftMargin: 5
                anchors.top: friendLogin.bottom
                font.family: "Tahoma"
                font.pointSize: 10
                color: "blue"
            }
        }
    }
    Rectangle{
        id:callRec
        height:0
        anchors.top: friendControlRec.bottom
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        anchors.topMargin: 15
        anchors.right: parent.right
        anchors.left: parent.left
        radius: 2
        border.width: 1
        border.color: "#cfd2d8"

        color: "#60726293"
        clip: true

        AnimatedImage{
            id: callImg
            width: 100
            height: 100
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:icons/phone.gif"
            visible: true
        }
        Rectangle{
            id:callRecProcess
            anchors.fill: parent
            color: "#00000000"
            clip: true
            Image {
                id: personImg
                source: "qrc:icons/person.png"
                width: 100
                height: 100
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                visible: true
            }
            Text {
                id: controlVolumeTxt
                text: qsTr("Громкость:")
                renderType: Text.NativeRendering;
                anchors.horizontalCenter: controlVolume.horizontalCenter
                anchors.bottom: controlVolume.top
                font.family: "Tahoma"
                font.pointSize: 10
                color: "#f6f6f6"
            }
            Slider {
                id: controlVolume
                from: 0
                value: 1
                to:2.0
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.bottomMargin: 15
                anchors.leftMargin: 15
                handle: Rectangle {
                        x: controlVolume.leftPadding + controlVolume.visualPosition * (controlVolume.availableWidth - width)
                        y: controlVolume.topPadding + controlVolume.availableHeight / 2 - height / 2
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 13
                        color: controlVolume.pressed ? "#f0f0f0" : "#f6f6f6"
                        border.color: "#bdbebf"
                    }
                background: Rectangle {
                    x: controlVolume.leftPadding
                    y: controlVolume.topPadding + controlVolume.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 4
                    width: controlVolume.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: "#979ca9"

                    Rectangle {
                        width: controlVolume.visualPosition * parent.width
                        height: parent.height
                        color: "#655881"
                        radius: 2
                    }
                }
                onMoved: {
                    appCore.setSpeakerVolume(friendLoginPrm.text, value)
                    console.log(value)
                }
            }
            Text {
                id: controlMicTxt
                text: qsTr("Микрофон:")
                renderType: Text.NativeRendering;
                anchors.horizontalCenter: controlMic.horizontalCenter
                anchors.bottom: controlMic.top
                font.family: "Tahoma"
                font.pointSize: 10
                color: "#f6f6f6"
            }
            Slider {
                id: controlMic
                from: 0
                value: 1
                to:2.0
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.bottomMargin: 15
                anchors.rightMargin: 15
                handle: Rectangle {
                        x: controlMic.leftPadding + controlMic.visualPosition * (controlMic.availableWidth - width)
                        y: controlMic.topPadding + controlMic.availableHeight / 2 - height / 2
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 13
                        color: controlMic.pressed ? "#f0f0f0" : "#f6f6f6"
                        border.color: "#bdbebf"
                    }
                background: Rectangle {
                    x: controlMic.leftPadding
                    y: controlMic.topPadding + controlMic.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 4
                    width: controlMic.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: "#979ca9"

                    Rectangle {
                        width: controlMic.visualPosition * parent.width
                        height: parent.height
                        color: "#655881"
                        radius: 2
                    }
                }
                onMoved: {
                    appCore.setMicVolume(friendLoginPrm.text, value)
                    console.log(value)
                }
            }
        }
    }


    Rectangle{
        id:messagesRec
        anchors.top: callRec.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: sendMsgRec.top
        color: "white"
        anchors.topMargin: callRec.height==0?0:15
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        anchors.bottomMargin: 15
        radius: 2
        border.width: 1
        border.color: "#cfd2d8"
        clip: true
        Flickable {
            id: messagesFlick
            anchors.fill: parent
            boundsBehavior: Flickable.StopAtBounds
            maximumFlickVelocity: 10000
            pixelAligned: true
            contentY:messagesArea.height-height
            TextArea.flickable: TextArea{
                id:messagesArea
                width: parent.width
                renderType: Text.NativeRendering;
                font.family: "Tahoma"
                font.pointSize: 10
                wrapMode: TextArea.Wrap
                selectByMouse: true
                textFormat: Text.RichText
                verticalAlignment: TextArea.AlignBottom
                readOnly: true
                selectionColor: "#d8e1ee"
                MouseArea{
                    anchors.fill: parent
                    enabled: false
                    cursorShape: Qt.IBeamCursor
                }
            }
            ScrollBar.vertical: ScrollBar {
            id:messagesAreaScrollBar
            interactive: false
            }
        }
    }

    Rectangle{
        id:sendMsgRec
        height: 50
        color: "white"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.right: sendMsgBtn.left
        anchors.rightMargin: 10
        radius: 2
        border.width: 1

        border.color: sendMsgBodyArea.activeFocus?"#9f97ae":"#cfd2d8"
        Flickable {
            id: sendMsgBodyAreaFlick
            anchors.fill: parent

            boundsBehavior: Flickable.StopAtBounds
            maximumFlickVelocity: 500
            TextArea.flickable: TextArea{
                id:sendMsgBodyArea
                width: parent.width
                renderType: Text.NativeRendering;
                font.family: "Tahoma"
                font.pointSize: 10
                wrapMode: TextArea.Wrap
                selectByMouse: true
                placeholderText: "Написать сообщение..."
                selectionColor: "#d8e1ee"
                Keys.onReturnPressed: {
                    appCore.sendMsg(friendLoginPrm.text, sendMsgBodyArea.text)
                }
                Shortcut {
                    id:myShortCut
                    enabled: false
                    sequence: "Ctrl+Return"
                    onActivated: {
                        if(sendMsgBodyArea.activeFocus) {
                            sendMsgBodyArea.insert(sendMsgBodyArea.length, "\r\n")
                        }
                    }
                }
            }
            ScrollBar.vertical: ScrollBar { interactive: false}
        }
    }
    Rectangle{
        id:sendMsgBtn
        width: 50
        height: 50
        radius: 2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 15
        color: sendMsgArea.containsMouse?"#eff2f7":"white"
        border.width: 1
        border.color:"#cfd2d8"
        MouseArea{
            id:sendMsgArea
            width: parent.width
            height: parent.height
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                appCore.sendMsg(friendLoginPrm.text, sendMsgBodyArea.text)
            }
            ToolTip{
                delay: 1000
                visible:sendMsgArea.containsMouse?true:false
                background: Rectangle{
                    border.width: 0
                    color: "#5f000000"
                    radius: 2
                }
                Text {
                    text: qsTr("Отправить сообщение")
                    renderType: Text.NativeRendering;
                    font.family: "Tahoma"
                    font.pointSize: 8
                    color: "#e9ebee"
                }
            }
        }

        Image {
            id: image2
            width: 30
            height: 30
            source: "qrc:icons/send-msg.png"
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
