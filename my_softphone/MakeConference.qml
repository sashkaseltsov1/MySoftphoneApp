import QtQuick 2.0
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Rectangle {
    id:main
    width: parent.width
    height: parent.height
    color: "#00000000"
    onVisibleChanged: {
        main.forceActiveFocus()
    }
    property int friendContentHeight: 0
    property int partyContentHeight: 0
    property var partiesArr: []
    Connections{
        target: appCore
        onFriendListForConferenceShowInQml:{
            listModelParties.clear()
            listModelFriends.clear()
            friendContentHeight=0
            partyContentHeight=0
            conferenceNameField.text=""
            for(var i=0; i<loginList.length; i++)
            {
                friendContentHeight=friendContentHeight+30
                listModelFriends.append({login: loginList[i], name:nameList[i]})
            }
        }
    }

    Text {
        id: makeConferenceTxt
        text: qsTr("Создание конференции:")
        renderType: Text.NativeRendering;
        font.family: "Tahoma"
        font.pointSize: 10
        anchors.top: parent.top
        anchors.horizontalCenter: conferenceNameField.horizontalCenter
        color: "#655881"

    }
    TextField{
        id:conferenceNameField
        width:parent.width
        height: 30
        validator: RegExpValidator { regExp: /[A-z0-9_]+$/ }
        selectByMouse: true
        selectionColor: "#d8e1ee"
        color: "black"
        font.family: "Tahoma"
        font.pointSize: 10
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 20
        placeholderText: "Введите название конференции"
        placeholderTextColor: "#bdbdbd"
        renderType: Text.NativeRendering;
        background: Rectangle{
            border.color: parent.activeFocus? "#9f97ae":"#bdbdbd"
            radius: 2
        }
    }
    Rectangle{
        id:makeConfBtn
        height: 30
        width: 150
        anchors.right: conferenceNameField.right
        anchors.verticalCenter: conferenceNameField.verticalCenter
        color: makeConfBtnArea.containsMouse?"#726293":"#655881"
        radius: 2

        Rectangle{
            id:findFriendsBtn2
            height: 30
            width: 2
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            color: makeConfBtnArea.containsMouse?"#726293":"#655881"
        }

        Text {
            id: makeConfBtnTxt
            text: qsTr("Создать конференцию")
            renderType: Text.NativeRendering;
            font.family: "Tahoma"
            font.pointSize: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
        }
        MouseArea{
            id:makeConfBtnArea
            width: parent.width
            height: parent.height
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if((appCore.getCallSize()+appCore.getConferenceSize())>0)
                    appCore.showInfo("У вас уже есть активные звонки")
                else
                    if(conferenceNameField.text==="")
                        appCore.showInfo("Введите название конференции")
                else
                    if(listModelParties.count==0)
                        appCore.showInfo("Добавьте участников конференции")
                else
                    {
                        partiesArr=[]
                        for(var i=0;i<listModelParties.count;i++)
                            partiesArr.push(listModelParties.get(i).login)
                        appCore.makeConference(partiesArr, conferenceNameField.text)



                    }
            }
        }
    }
    Rectangle{
        id:friends
        width: 61
        height: 27
        anchors.left: parent.left
        anchors.top: conferenceNameField.bottom
        anchors.topMargin: 15
        color: "white"
        radius: 2
        border.width: 1
        border.color: "#cfd2d8"
        Text {
            id: friendsTxt
            text: qsTr("Друзья")
            anchors.horizontalCenter: parent.horizontalCenter
            renderType: Text.NativeRendering;
            font.family: "Tahoma"
            anchors.top: parent.top
            anchors.topMargin: 5
            font.pointSize: 10
            color: "#655881"
        }
    }
    Rectangle{
        id:friendsConfRec
        anchors.top: conferenceNameField.bottom
        anchors.topMargin: 40
        anchors.bottom: parent.bottom
        width: parent.width/2-7.5
        color: "white"
        radius: 2
        border.width: 1
        border.color: "#cfd2d8"
        Flickable{
            anchors.fill: parent
            contentHeight: friendContentHeight+20
            ScrollBar.vertical: ScrollBar { interactive: false}
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick
            clip: true
            ListView {
                id: listViewFriends
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 10
                anchors.bottomMargin: 10
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
                        id:recFriendItem
                        width: parent.width
                        height: parent.height
                        color: recFriendItemArea.containsMouse?"#eeeff0":"white"
                        radius: 2
                        MouseArea{
                            id:recFriendItemArea
                            hoverEnabled: true
                            width: parent.width
                            height: parent.height
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                listModelParties.append({login:listModelFriends.get(index).login, name:listModelFriends.get(index).name})
                                partyContentHeight=partyContentHeight+30
                                friendContentHeight=friendContentHeight-30
                                listModelFriends.remove(index)
                            }
                        }
                    }
                    Text {
                        id: loginPrm
                        text: qsTr(login)
                        renderType: Text.NativeRendering;

                        font.family: "Tahoma"
                        font.pointSize: 10
                        anchors.verticalCenter: recFriendItem.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        color: "#655881"
                    }
                    Text {
                        id: namePrm
                        anchors.left: loginPrm.right
                        anchors.leftMargin: 5
                        anchors.right: image2.right
                        anchors.rightMargin: 30
                        clip: true
                        text: qsTr(name)
                        color: "#655881"
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 10
                        anchors.verticalCenter: recFriendItem.verticalCenter

                    }
                    Image {
                        id: image2
                        width: 20
                        height: 20
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 5
                        source: "qrc:icons/plus.png"
                    }
                }
                model: ListModel {
                    id: listModelFriends
                }
            }
        }
    }
    Rectangle{
        height: 1
        color: "#cfd2d8"
        anchors.top: friendsConfRec.top
        anchors.right: friendsConfRec.right
        anchors.rightMargin: 3
        anchors.left: friends.left
        anchors.leftMargin: 60
    }
    Rectangle{
        height: 1
        width: friendsConfRec.width-6
        anchors.horizontalCenter: friendsConfRec.horizontalCenter
        color: "#cfd2d8"
        anchors.bottom: friendsConfRec.bottom
    }
    Rectangle{
        id:friendsRec
        width: 59
        height: 2
        anchors.horizontalCenter: friends.horizontalCenter
        anchors.top: friends.top
        anchors.topMargin: 25
        color: "white"
    }
    Rectangle{
        id:parties
        width: 160
        height: 27
        anchors.left: partiesConfRec.left
        anchors.top: conferenceNameField.bottom
        anchors.topMargin: 15
        color: "white"
        radius: 2
        border.width: 1
        border.color: "#cfd2d8"
        Text {
            id: partiesTxt
            text: qsTr("Участники конференции")
            anchors.horizontalCenter: parent.horizontalCenter
            renderType: Text.NativeRendering;
            font.family: "Tahoma"
            anchors.top: parent.top
            anchors.topMargin: 5
            font.pointSize: 10
            color: "#655881"
        }
    }
    Rectangle{
        id:partiesConfRec
        anchors.top: conferenceNameField.bottom
        anchors.topMargin: 40
        anchors.bottom: parent.bottom
        width: parent.width/2-7.5
        anchors.right: parent.right
        color: "white"
        radius: 2
        border.width: 1
        border.color: "#cfd2d8"
        Flickable{
            anchors.fill: parent
            contentHeight: partyContentHeight+20
            ScrollBar.vertical: ScrollBar { interactive: false}
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick
            clip: true
            ListView {
                id: listViewParties
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.topMargin: 10
                anchors.bottomMargin: 10
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
                        id:recPartyItem
                        width: parent.width
                        height: parent.height
                        color: recPartyItemArea.containsMouse?"#eeeff0":"white"
                        radius: 2
                        MouseArea{
                            id:recPartyItemArea
                            hoverEnabled: true
                            width: parent.width
                            height: parent.height
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                listModelFriends.append({login:listModelParties.get(index).login, name:listModelParties.get(index).name})
                                friendContentHeight=friendContentHeight+30
                                partyContentHeight=partyContentHeight-30
                                listModelParties.remove(index)
                            }
                        }
                    }
                    Text {
                        id: loginPrmP
                        text: qsTr(login)
                        renderType: Text.NativeRendering;

                        font.family: "Tahoma"
                        font.pointSize: 10
                        anchors.verticalCenter: recPartyItem.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        color: "#655881"
                    }
                    Text {
                        id: namePrmP
                        anchors.left: loginPrmP.right
                        anchors.leftMargin: 5
                        anchors.right: image2P.right
                        anchors.rightMargin: 30
                        clip: true
                        text: qsTr(name)
                        color: "#655881"
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 10
                        anchors.verticalCenter: recPartyItem.verticalCenter

                    }
                    Image {
                        id: image2P
                        width: 20
                        height: 20
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 5
                        source: "qrc:icons/minus.png"
                    }
                }
                model: ListModel {
                    id: listModelParties
                }
            }
        }
    }
    Rectangle{
        height: 1
        color: "#cfd2d8"
        anchors.top: partiesConfRec.top
        anchors.right: partiesConfRec.right
        anchors.rightMargin: 3
        anchors.left: parties.left
        anchors.leftMargin: 60
    }
    Rectangle{
        height: 1
        width: partiesConfRec.width-6
        anchors.horizontalCenter: partiesConfRec.horizontalCenter
        color: "#cfd2d8"
        anchors.bottom: partiesConfRec.bottom
    }
    Rectangle{
        id:partiesRec
        width: 158
        height: 2
        anchors.horizontalCenter: parties.horizontalCenter
        anchors.top: parties.top
        anchors.topMargin: 25
        color: "white"
    }
}
