import QtQuick 2.0
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Rectangle {
    id:main
    width: parent.width
    height: parent.height
    color: "#00000000"
    property int listViewFindFriendsHeight: 0
    onVisibleChanged: {
        listModelFindFriends.clear()
        listViewFindFriendsHeight=0
        main.forceActiveFocus()
        emptyResultTxt.visible=false
    }

    Connections{
        target: appCore
        onFindFriendsShowInQml:{

            listModelFindFriends.clear()
            listViewFindFriendsHeight=0
            if(loginList.length===0)
            {
                console.log("aaa")
                emptyResultTxt.visible=true
            }
            else
            {
                emptyResultTxt.visible=false
                for(var i=0;i<loginList.length;i++)
                {
                    listViewFindFriendsHeight=listViewFindFriendsHeight+30
                    listModelFindFriends.append({login: loginList[i], name:nameList[i]})
                }
            }
        }
    }

    Text {
        id: findFriendsTxt
        text: qsTr("Поиск друзей:")
        renderType: Text.NativeRendering;
        font.family: "Tahoma"
        font.pointSize: 10
        anchors.top: parent.top
        anchors.horizontalCenter: findFriendsField.horizontalCenter
        color: "#655881"

    }
    TextField{
        id:findFriendsField
        width:316
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
        placeholderText: "Введите имя или логин друга"
        placeholderTextColor: "#bdbdbd"
        renderType: Text.NativeRendering;
        background: Rectangle{
            border.color: parent.activeFocus? "#9f97ae":"#bdbdbd"
            radius: 2
        }
    }
    Rectangle{
        id:findFriendsBtn
        height: 30
        width: 60
        anchors.right: findFriendsField.right
        anchors.verticalCenter: findFriendsField.verticalCenter
        color: findFriendsBtnArea.containsMouse?"#726293":"#655881"
        radius: 2

        Rectangle{
            id:findFriendsBtn2
            height: 30
            width: 2
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            color: findFriendsBtnArea.containsMouse?"#726293":"#655881"
        }

        Text {
            id: findFriendsBtnTxt
            text: qsTr("Найти")
            renderType: Text.NativeRendering;
            font.family: "Tahoma"
            font.pointSize: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
        }
        MouseArea{
            id:findFriendsBtnArea
            width: parent.width
            height: parent.height
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                appCore.findFriends(findFriendsField.text)
                findFriendsField.text=""

            }
        }
    }
    Rectangle{
        id:findFriendsContent
        width: findFriendsField.width
        anchors.bottom: parent.bottom
        anchors.top: findFriendsField.bottom
        anchors.topMargin: 15
        color: "white"
        radius: 2
        border.width: 1
        border.color: "#cfd2d8"
        clip: true
            ListView {
                id: listViewFindFriends
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.left: parent.left
                anchors.right: parent.right
                clip: true
                ScrollBar.vertical: ScrollBar {interactive: false}
                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.VerticalFlick
                contentHeight: listViewFindFriendsHeight
                maximumFlickVelocity: 1500
                delegate: Item {
                    id: item4
                    width: parent.width-20
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: 30
                    Rectangle{
                        id:recFindFriendItem
                        width: 30
                        height: 30
                        color: recFindFriendItemArea.containsMouse?"#eeeff0":"white"
                        radius: 2
                        anchors.right: parent.right
                        MouseArea{
                            id:recFindFriendItemArea
                            hoverEnabled: true
                            width: 30
                            height: parent.height
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                appCore.addSubscribe(loginPrmFind.text)
                                listModelFindFriends.remove(index)
                            }
                        }
                        ToolTip{
                            delay: 1000
                            visible:recFindFriendItemArea.containsMouse?true:false
                            background: Rectangle{
                                border.width: 0
                                color: "#5f000000"
                                radius: 2
                            }
                            Text {
                                text: qsTr("Добавить в друзья")
                                renderType: Text.NativeRendering;
                                font.family: "Tahoma"
                                font.pointSize: 8
                                color: "#e9ebee"
                            }
                        }
                    }
                    Text {
                        id: loginPrmFind
                        text: qsTr(login)
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 10
                        anchors.verticalCenter: recFindFriendItem.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        color: "#655881"
                    }
                    Text {
                        id: namePrmFind
                        anchors.left: loginPrmFind.right
                        anchors.leftMargin: 5
                        anchors.right: image5.right
                        anchors.rightMargin: 30
                        clip: true
                        text: qsTr(name)
                        color: "#655881"
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 10
                        anchors.verticalCenter: recFindFriendItem.verticalCenter

                    }
                    Image {
                        id: image5
                        width: 30
                        height: 30
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        source: "qrc:icons/find-person-icon.png"
                    }
                }
                model: ListModel {
                    id: listModelFindFriends
                }
        }
        Text {
            id: emptyResultTxt
            text: qsTr("Ничего не найдено.")
            renderType: Text.NativeRendering;
            font.family: "Tahoma"
            font.pointSize: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 15
            color: "#655881"
            visible: false
        }
        Rectangle{
            width: parent.width-4
            height: 1
            anchors.bottom: parent.bottom
            color: "#cfd2d8"
        }
    }
}
