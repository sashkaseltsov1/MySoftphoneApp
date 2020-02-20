import QtQuick 2.10
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
Rectangle {
    id:main
    width: parent.width
    height: parent.height
    color: "#00000000"
    property var conferenceCreator: ""
    property int activePartiesHeight: 0
    property int calledPartiesHeight: 0
    property int addPartiesHeight: 0
    onVisibleChanged: {
        speakerRecSlider.visible=false
        micRecSlider.visible=false
        addNewPartyRec.visible=false
        if(visible==false)
        {
            conferenceCreator=""
            confNamePrm.text=""
            myShortCut.enabled=false
        }
        else
            myShortCut.enabled=true
    }

    Connections{
        target: appCore
        onShowNewConferenceMsgInQml:{
            console.log("sasasasasa")
            if(confCreator==conferenceCreator & conName==confNamePrm.text)
            {

                if(sender=="Вы")
                {
                    messagesArea.append("<font color='green'>"+sender+":</font>")
                    sendMsgBodyArea2.text=""
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

        onShowValidPartiesInQml:{
            addPartiesHeight=0
            listModelAddParties.clear()
            for(var i=0; i<parties.length;i++)
            {
                addPartiesHeight=addPartiesHeight+30
                listModelAddParties.append({partyLoginPrm:parties[i]})
            }
        }
        onSetDefaultVolumeForConferenceInQml:{
            controlVolumeMic.value=1
            controlVolumeSpeaker.value=1
        }
        onShowIConferenceInQml:{
            confNamePrm.text=confName
            partyCountPrm.text=activePartiesSize

            listModelActiveParties.clear()
            activePartiesHeight=0
            listModelCalledParties.clear()
            calledPartiesHeight=0
            messagesArea.text=""
            sendMsgBodyArea2.text=""
            conferenceCreator=confCreator
            var t=false
            if(appCore.getLogin()===conferenceCreator)
            {
                t=true
                addPartyAreaDisable.visible=false
                addPartyArea.visible=true
                speakerRec.visible=false
            }
            else
            {
                addPartyArea.visible=false
                addPartyAreaDisable.visible=true
                speakerRec.visible=true
            }
            for(var i=0; i<activeParties.length;i++)
            {
                activePartiesHeight=activePartiesHeight+30
                if(activeParties[i]===confCreator)
                    listModelActiveParties.append({partyLoginPrm:activeParties[i], partyColor:"orange",speakerValue:volumePrms[i], visPrm:t})
                else
                    listModelActiveParties.append({partyLoginPrm:activeParties[i], partyColor:"blue",speakerValue:volumePrms[i], visPrm:t})
            }
            for(var j=0; j<calledParties.length;j++)
            {
                calledPartiesHeight=calledPartiesHeight+30
                listModelCalledParties.append({partyLoginPrm:calledParties[j]})
            }
            for(i=0;i<senders.length;i++)
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
            addNewPartyRec.visible=false
            main.visible=true
        }
    }
    Rectangle{
        id:conferenceControlRec
        width: parent.width
        height: 50
        color: "white"
        anchors.top: parent.top
        radius: 2
        border.width: 1
        border.color: "#cfd2d8"
        Rectangle{
            id:confParametrs
            height: parent.height-18
            width: parent.width/2
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10
            color: "white"
            clip: true
            Text {
                id: confName
                text: qsTr("Конференция:")
                renderType: Text.NativeRendering;
                font.family: "Tahoma"
                font.pointSize: 10
                color: "#655881"
            }
            Text {
                id: confNamePrm
                text: qsTr("sasdsfsda_AAAA")
                renderType: Text.NativeRendering;
                anchors.left: confName.right
                anchors.leftMargin: 5
                font.family: "Tahoma"
                font.pointSize: 10
                color: "purple"
            }
            Text {
                id: partyCount
                text: qsTr("Количество участников:")
                anchors.top: confName.bottom
                renderType: Text.NativeRendering;
                font.family: "Tahoma"
                font.pointSize: 10
                color: "#655881"
            }
            Text {
                id: partyCountPrm
                text: qsTr("0")
                renderType: Text.NativeRendering;
                anchors.left: partyCount.right
                anchors.leftMargin: 5
                anchors.top: confName.bottom
                font.family: "Tahoma"
                font.pointSize: 10
                color: "orange"
            }
        }
        Rectangle{
            id:hangupConferenceRec
            width: 30
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            color: hangupConferenceArea.containsMouse?"#eff2f7":"white"
            radius: 2
            MouseArea{
                id:hangupConferenceArea
                width: parent.width
                height: parent.height
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    appCore.hangUpConference(confNamePrm.text, conferenceCreator)
                }
                ToolTip{
                    delay: 1000
                    visible:hangupConferenceArea.containsMouse?true:false
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
            id:addPartyRec
            width: 30
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: hangupConferenceRec.left
            anchors.rightMargin: 10
            color: addPartyArea.containsMouse?"#eff2f7":"white"
            radius: 2
            MouseArea{
                id:addPartyArea
                width: parent.width
                height: parent.height
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if(addNewPartyRec.visible==false)
                    {
                        addNewPartyRec.visible=true
                        micRecSlider.visible=false
                        speakerRecSlider.visible=false
                        appCore.getValidParties(confNamePrm.text, conferenceCreator)
                    }
                    else
                    {
                        addNewPartyRec.visible=false
                    }
                }
                ToolTip{
                    delay: 1000
                    visible:addPartyArea.containsMouse?true:false
                    background: Rectangle{
                        border.width: 0
                        color: "#5f000000"
                        radius: 2
                    }
                    Text {
                        text: qsTr("Добавить участника")
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 8
                        color: "#e9ebee"
                    }
                }
            }
            MouseArea{
                id:addPartyAreaDisable
                width: parent.width
                height: parent.height
                hoverEnabled: true
                ToolTip{
                    delay: 1000
                    visible:addPartyAreaDisable.containsMouse?true:false
                    background: Rectangle{
                        border.width: 0
                        color: "#5f000000"
                        radius: 2
                    }
                    Text {
                        text: qsTr("Добавлять участников может только администратор")
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 8
                        color: "#e9ebee"
                    }
                }
            }
            Image {
                id: image2333
                width: 30
                height: 30
                source: "qrc:icons/plus.png"
            }
        }
        Rectangle{
            id:micRec
            width: 30
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: addPartyRec.left
            anchors.rightMargin: 10
            color: micArea.containsMouse?"#eff2f7":"white"
            radius: 2
            MouseArea{
                id:micArea
                width: parent.width
                height: parent.height
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if(micRecSlider.visible==false)
                    {
                        addNewPartyRec.visible=false
                        micRecSlider.visible=true
                        speakerRecSlider.visible=false
                    }
                    else
                        micRecSlider.visible=false
                }
                ToolTip{
                    delay: 1000
                    visible:micArea.containsMouse?true:false
                    background: Rectangle{
                        border.width: 0
                        color: "#5f000000"
                        radius: 2
                    }
                    Text {
                        text: qsTr("Громкость микрофона")
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 8
                        color: "#e9ebee"
                    }
                }
            }
            Image {
                id: image2334
                width: 30
                height: 30
                source: "qrc:icons/mic.png"
            }
        }
        Rectangle{
            id:speakerRec
            width: 30
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: micRec.left
            anchors.rightMargin: 10
            color: speakerArea.containsMouse?"#eff2f7":"white"
            radius: 2
            MouseArea{
                id:speakerArea
                width: parent.width
                height: parent.height
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if(speakerRecSlider.visible==false)
                    {
                        speakerRecSlider.visible=true
                        micRecSlider.visible=false
                        addNewPartyRec.visible=false
                    }
                    else
                    {
                        speakerRecSlider.visible=false
                    }
                }
                ToolTip{
                    delay: 1000
                    visible:speakerArea.containsMouse?true:false
                    background: Rectangle{
                        border.width: 0
                        color: "#5f000000"
                        radius: 2
                    }
                    Text {
                        text: qsTr("Громкость наушников")
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 8
                        color: "#e9ebee"
                    }
                }
            }
            Image {
                id: image2335
                width: 30
                height: 30
                source: "qrc:icons/speaker.png"
            }
        }
    }
    Rectangle{
        id:partiesRec
        width: parent.width
        height: 200
        color: "#00000000"
        anchors.top: conferenceControlRec.bottom
        anchors.topMargin: 15
        Rectangle{
            id:activePartiesRec
            width: parent.width/2-7.5
            height: parent.height
            color: "white"
            radius: 2
            border.width: 1
            border.color: "#cfd2d8"
            Text {
                id: activePartiesTxt
                text: qsTr("Участники:")
                renderType: Text.NativeRendering;
                font.family: "Tahoma"
                font.pointSize: 10
                color: "#655881"
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Flickable {
                width: parent.width
                anchors.top: activePartiesTxt.bottom
                anchors.bottom: parent.bottom
                clip: true
                contentHeight: activePartiesHeight
                ScrollBar.vertical: ScrollBar { interactive: false}
                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.VerticalFlick
                maximumFlickVelocity: 1500
                ListView {
                    id: listViewActiveParties
                    anchors.top: parent.top
                    height: parent.height
                    anchors.left: parent.left
                    anchors.right: parent.right
                    interactive: false
                    clip: true
                    delegate: Item {
                        id: item
                        width: parent.width-20
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: 30
                        Rectangle{
                            id:partyLoginRec
                            width: parent.width/2-30
                            height: parent.height
                            clip: true
                        }
                        Rectangle{
                            id:soundCtrlImageRec
                            width: 30
                            height: 30
                            anchors.left: partyLoginRec.right
                            visible: visPrm
                            Image {
                                id: soundCtrlImage
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                height:20
                                width: 20
                                source: "qrc:icons/speaker.png"
                            }
                        }
                        Rectangle{
                            id:soundControlRec
                            anchors.left: soundCtrlImageRec.right
                            anchors.right: hangupConferenceCallRec2.left
                            height: parent.height
                            visible: visPrm

                        }
                        Rectangle{
                            id:hangupConferenceCallRec2
                            width: 30
                            height: 30
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            color: hangupConferenceCallArea2.containsMouse?"#eff2f7":"white"
                            radius: 2
                            clip: true
                            visible: visPrm
                            MouseArea{
                                id:hangupConferenceCallArea2
                                width: parent.width
                                height: parent.height
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    appCore.hangUpConferenceCall(confNamePrm.text, conferenceCreator, partyLogin.text)
                                }

                            }
                            Image {
                                id: image23321
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                width: 25
                                height: 25
                                source: "qrc:icons/hangup-call.png"
                            }
                        }
                        Text {
                            id: partyLogin
                            width: partyLoginRec.width
                            clip: true
                            text: qsTr(partyLoginPrm)
                            anchors.verticalCenter: partyLoginRec.verticalCenter
                            anchors.left: partyLoginRec.left
                            renderType: Text.NativeRendering;
                            font.family: "Tahoma"
                            font.pointSize: 10
                            color: partyColor
                        }
                        Slider {
                            id: controlVolume
                            from: 0
                            value: speakerValue
                            to:2.0
                            anchors.fill: soundControlRec
                            visible: visPrm
                            handle: Rectangle {
                                    x: controlVolume.leftPadding + controlVolume.visualPosition * (controlVolume.availableWidth - width)
                                    y: controlVolume.topPadding + controlVolume.availableHeight / 2 - height / 2
                                    implicitWidth: 13
                                    implicitHeight: 13
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
                                appCore.setConferenceCallSpeakerVolume(confNamePrm.text, conferenceCreator, partyLogin.text, value )
                                console.log(value)
                            }
                        }
                    }
                    model: ListModel {
                        id: listModelActiveParties
                    }
                }
            }
        }
        Rectangle{
            width: activePartiesRec.width-4
            height: 1
            color: "#cfd2d8"
            anchors.horizontalCenter: activePartiesRec.horizontalCenter
            anchors.bottom: activePartiesRec.bottom
        }

        Rectangle{
            id:calledPartiesRec
            width: parent.width/2-7.5
            height: parent.height
            anchors.right: parent.right
            color: "white"
            radius: 2
            border.width: 1
            border.color: "#cfd2d8"
            Text {
                id: calledPartiesTxt
                text: qsTr("Вызовы:")
                renderType: Text.NativeRendering;
                font.family: "Tahoma"
                font.pointSize: 10
                color: "#655881"
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Flickable {
                width: parent.width
                anchors.top: calledPartiesTxt.bottom
                anchors.bottom: parent.bottom
                clip: true
                contentHeight: calledPartiesHeight
                ScrollBar.vertical: ScrollBar { interactive: false}
                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.VerticalFlick
                maximumFlickVelocity: 1500
                ListView {
                    id: listViewCalledParties
                    anchors.top: parent.top
                    height: parent.height
                    anchors.left: parent.left
                    anchors.right: parent.right
                    interactive: false
                    clip: true
                    delegate: Item {
                        id: item2
                        width: parent.width-20
                        anchors.horizontalCenter: parent.horizontalCenter
                        height: 30
                        Rectangle{
                            id:calledPartyLoginRec
                            width: parent.width
                            height: parent.height
                            clip: true
                        }

                        Text {
                            id: calledPartyLogin
                            width: calledPartyLoginRec.width
                            clip: true
                            text: qsTr(partyLoginPrm)
                            anchors.verticalCenter: calledPartyLoginRec.verticalCenter
                            anchors.left: calledPartyLoginRec.left
                            renderType: Text.NativeRendering;
                            font.family: "Tahoma"
                            font.pointSize: 10
                            color: "blue"
                        }
                        Rectangle{
                            id:hangupConferenceCallRec
                            width: 30
                            height: 30
                            anchors.verticalCenter: calledPartyLoginRec.verticalCenter
                            anchors.right: calledPartyLoginRec.right
                            color: hangupConferenceCallArea.containsMouse?"#eff2f7":"white"
                            radius: 2
                            MouseArea{
                                id:hangupConferenceCallArea
                                width: parent.width
                                height: parent.height
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    appCore.hangUpConferenceCall(confNamePrm.text, conferenceCreator, calledPartyLogin.text)
                                }
                            }
                            Image {
                                id: image2332
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter
                                width: 25
                                height: 25
                                source: "qrc:icons/hangup-call.png"
                            }
                        }

                    }
                    model: ListModel {
                        id: listModelCalledParties
                    }
                }
            }
        }
        Rectangle{
            width: calledPartiesRec.width-4
            height: 1
            color: "#cfd2d8"
            anchors.horizontalCenter: calledPartiesRec.horizontalCenter
            anchors.bottom: calledPartiesRec.bottom
        }
    }
    Rectangle{
        id:msgBodyRec
        width: parent.width
        anchors.bottom: sendMsgRec2.top
        anchors.bottomMargin: 15
        anchors.top: partiesRec.bottom
        anchors.topMargin: 15
        color: "white"
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
        id:sendMsgRec2
        anchors.left: parent.left
        anchors.right: sendMsgBtn.left
        anchors.rightMargin: 10
        height: 50
        color: "white"
        anchors.bottom: parent.bottom
        radius: 2
        border.width: 1
        clip: true
        border.color: sendMsgBodyArea2.activeFocus?"#9f97ae":"#cfd2d8"
        Flickable {
            id: sendMsgBodyAreaFlick2
            anchors.fill: parent

            boundsBehavior: Flickable.StopAtBounds
            maximumFlickVelocity: 500
            TextArea.flickable: TextArea{
                id:sendMsgBodyArea2
                width: parent.width
                renderType: Text.NativeRendering;
                font.family: "Tahoma"
                font.pointSize: 10
                wrapMode: TextArea.Wrap
                selectByMouse: true
                placeholderText: "Написать сообщение..."
                selectionColor: "#d8e1ee"


                Shortcut {
                    id:myShortCut
                    enabled: false
                    sequence: "Ctrl+Return"
                    onActivated: {
                        if(sendMsgBodyArea2.activeFocus) {
                            sendMsgBodyArea2.insert(sendMsgBodyArea2.length, "\r\n")
                        }
                    }
                }
                Keys.onReturnPressed: {
                    appCore.sendConferenceMsg(confNamePrm.text, conferenceCreator, sendMsgBodyArea2.text)
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
        anchors.right: parent.right
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
                appCore.sendConferenceMsg(confNamePrm.text, conferenceCreator, sendMsgBodyArea2.text)
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
    Rectangle{
        id:addNewPartyRec
        height: 400
        width: 200
        color: "#8f000000"
        anchors.right: parent.right
        anchors.top: conferenceControlRec.bottom
        radius: 2
        visible: false
        Flickable {
            width: parent.width
            anchors.fill:parent
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            clip: true
            contentHeight: addPartiesHeight
            ScrollBar.vertical: ScrollBar { interactive: false}
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick
            maximumFlickVelocity: 1500
            ListView {
                id: listViewAddParties
                anchors.top: parent.top
                height: parent.height
                anchors.left: parent.left
                anchors.right: parent.right
                interactive: false
                clip: true
                delegate: Item {
                    id: item3
                    width: parent.width-20
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 30
                    Rectangle{
                        id:addPartyLoginRec
                        anchors.left: parent.left
                        anchors.right: addPartyBtn.left
                        height: parent.height
                        clip: true
                        color: "#00000000"
                    }

                    Text {
                        id: addPartyLogin
                        width: addPartyLoginRec.width
                        clip: true
                        text: qsTr(partyLoginPrm)
                        anchors.verticalCenter: addPartyLoginRec.verticalCenter
                        anchors.left: addPartyLoginRec.left
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 10
                        color: "#e9ebee"
                    }
                    Rectangle{
                        id:addPartyBtn
                        width: 30
                        height: 30
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        color: addPartyBtnArea.containsMouse?"#35000000":"#00000000"
                        radius: 2
                        MouseArea{
                            id:addPartyBtnArea
                            width: parent.width
                            height: parent.height
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                appCore.addNewPartyInConference(confNamePrm.text, conferenceCreator, addPartyLogin.text)
                                listModelAddParties.remove(index)
                            }
                        }
                        Image {
                            id: image23322
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            width: 20
                            height: 20
                            source: "qrc:icons/plus-white.png"
                        }
                    }

                }
                model: ListModel {
                    id: listModelAddParties
                }
            }
        }
    }
    Rectangle{
        id:micRecSlider
        height: 30
        width: 100
        color: "#8f000000"
        anchors.right: parent.right
        anchors.top: conferenceControlRec.bottom
        anchors.rightMargin: 55
        radius: 2
        visible: false
        clip: true
        Slider {
            id: controlVolumeMic
            from: 0
            value: 1
            to:2.0
            anchors.fill: micRecSlider
            handle: Rectangle {
                    x: controlVolumeMic.leftPadding + controlVolumeMic.visualPosition * (controlVolumeMic.availableWidth - width)
                    y: controlVolumeMic.topPadding + controlVolumeMic.availableHeight / 2 - height / 2
                    implicitWidth: 13
                    implicitHeight: 13
                    radius: 13
                    color: controlVolumeMic.pressed ? "#f0f0f0" : "#f6f6f6"
                    border.color: "#bdbebf"
                }
            background: Rectangle {
                x: controlVolumeMic.leftPadding
                y: controlVolumeMic.topPadding + controlVolumeMic.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 4
                width: controlVolumeMic.availableWidth
                height: implicitHeight
                radius: 2
                color: "#979ca9"

                Rectangle {
                    width: controlVolumeMic.visualPosition * parent.width
                    height: parent.height
                    color: "#e9ebee"
                    radius: 2
                }
            }
            onMoved: {
                appCore.setConferenceCallMicVolume(confNamePrm.text, conferenceCreator, value)
            }
        }
    }
    Rectangle{
        id:speakerRecSlider
        height: 30
        width: 100
        color: "#8f000000"
        anchors.right: parent.right
        anchors.top: conferenceControlRec.bottom
        anchors.rightMargin: 95
        radius: 2
        visible: false
        clip: true
        Slider {
            id: controlVolumeSpeaker
            from: 0
            value: 1
            to:2.0
            anchors.fill: speakerRecSlider
            handle: Rectangle {
                    x: controlVolumeSpeaker.leftPadding + controlVolumeSpeaker.visualPosition * (controlVolumeSpeaker.availableWidth - width)
                    y: controlVolumeSpeaker.topPadding + controlVolumeSpeaker.availableHeight / 2 - height / 2
                    implicitWidth: 13
                    implicitHeight: 13
                    radius: 13
                    color: controlVolumeSpeaker.pressed ? "#f0f0f0" : "#f6f6f6"
                    border.color: "#bdbebf"
                }
            background: Rectangle {
                x: controlVolumeSpeaker.leftPadding
                y: controlVolumeSpeaker.topPadding + controlVolumeMic.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 4
                width: controlVolumeSpeaker.availableWidth
                height: implicitHeight
                radius: 2
                color: "#979ca9"

                Rectangle {
                    width: controlVolumeSpeaker.visualPosition * parent.width
                    height: parent.height
                    color: "#e9ebee"
                    radius: 2
                }
            }
            onMoved: {
                appCore.setConferenceCallSpeakerVolumeForDefaultParty(confNamePrm.text, conferenceCreator, value)
            }
        }
    }
}

