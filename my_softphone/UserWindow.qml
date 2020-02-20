import QtQuick 2.0
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0
ApplicationWindow {

    id:uWin
    width:900
    height: 600
    minimumHeight: 600
    minimumWidth: 900
    title: qsTr("Mysoftphone")
    color: "#e9ebee"
    property int contentH:0
    property int listViewFriendsHeight:0
    property int listViewConferencesHeight: 0
    property int listViewSubscribersHeight: 0
    property int friendId: -1
    property bool closeAppState: false
    MouseArea{
        width: parent.width
        height: parent.height
        onClicked: {
            findFriends.forceActiveFocus()
        }
    }

    Connections{

        target: appCore
        onLoginInfo:{
            if(regState==true)
            {
                userNameTextCustom.text=" "+appCore.getLogin()
                nameTextCustom.text=" "+appCore.getName()
                appCore.getFriendsList()
            }
        }
        onRemoveConference:{
            if(incomingConferenceRec.visible==true)
            {
                for(var i=0;i<listModelIncomingConference.count;i++)
                {
                    if(listModelIncomingConference.get(i).incomingConferenceNamePrm===confName &
                            listModelIncomingConference.get(i).incomingConferenceCreatorPrm===confCreator)
                    {
                        listModelIncomingConference.remove(i)
                        appCore.getConferencesList();
                        friendId=-1
                    }
                }
            }
            else
            {
                appCore.getConferencesList();
                conferenceInterface.visible=false
                appCore.showInfo("Конференция удалена")
                friendId=-1
            }
        }

        onChangeIConference:{
            subscribersBtn2.visible=false
            conferencesBtn2.visible=true
            friendsBtn2.visible=false
            subscribersBtn.border.width=0
            conferencesBtn.border.width=1
            friendsBtn.border.width=0
            appCore.getConferencesList()
            friendInterface.visible=false
            findFriends.visible=false
            makeConference.visible=false
            conferenceInterface.visible=true
            appCore.showIConference(confName, confCreator)
        }

        onChangeIFriendInQml:{
            subscribersBtn2.visible=false
            conferencesBtn2.visible=false
            friendsBtn2.visible=true
            subscribersBtn.border.width=0
            conferencesBtn.border.width=0
            friendsBtn.border.width=1
            appCore.getFriendsList()
            if(incomingCallRec.visible==true) incomingCallRec.visible=false
            if(friendId!=-1)
            {
                listModelFriends.get(friendId).clickVisible=false
                listModelFriends.get(friendIndex).clickVisible=true
            }
            else
            {
                listModelFriends.get(friendIndex).clickVisible=true
            }
            listModelFriends.get(friendIndex).msgState=false
            appCore.changeMsgState(friendIndex, false)
            friendId=friendIndex
            appCore.showIFriend(login, name)
            friendInterface.visible=true
            findFriends.visible=false
            makeConference.visible=false
            conferenceInterface.visible=false
        }

        onFriendsListShowInQml:{
            listModelFriends.clear()
            listModelSubscribers.clear()
            listModelConferences.clear()
            listViewFriendsHeight=0
            listViewConferencesHeight=0
            listViewSubscribersHeight=0
            for(var i=0; i<loginList.length; i++)
            {
                listViewFriendsHeight=listViewFriendsHeight+30
                listModelFriends.append({login: loginList[i],
                                            name:nameList[i],
                                            statusColor:statusList[i],
                                            msgState:msgStateList[i],
                                            clickVisible:false})
                if(i===friendId)
                    listModelFriends.get(i).clickVisible=true
            }
        }
        onSubscribersListShowInQml:{
            listModelFriends.clear()
            listModelSubscribers.clear()
            listModelConferences.clear()
            listViewFriendsHeight=0
            listViewConferencesHeight=0
            listViewSubscribersHeight=0
            for(var i=0; i<subscribersList.length; i++)
            {
                listViewSubscribersHeight=listViewSubscribersHeight+30
                listModelSubscribers.append({login: subscribersList[i]})
            }
        }
        onConferencesListShowInQml:{
            listModelFriends.clear()
            listModelSubscribers.clear()
            listModelConferences.clear()
            listViewFriendsHeight=0
            listViewConferencesHeight=0
            listViewSubscribersHeight=0
            subscribersBtn2.visible=false
            conferencesBtn2.visible=true
            friendsBtn2.visible=false
            subscribersBtn.border.width=0
            conferencesBtn.border.width=1
            friendsBtn.border.width=0
            for(var i=0; i<conferencesList.length; i++)
            {
                listViewConferencesHeight=listViewConferencesHeight+30
                listModelConferences.append({confNamePrm: conferencesList[i], confCreatorNamePrm:confCreatorsList[i]})
            }
        }
        onEntityChangeStatusInQml:{
            if(friendsBtn2.visible==true)
            {
                listModelFriends.get(index).statusColor=status
            }
        }
        onShowNewSubscriberInQml:{
            if(subscribersBtn2.visible==true)
            {
                listViewSubscribersHeight=listViewSubscribersHeight+30
                listModelSubscribers.append({login:subLogin})
            }
        }
        onShowNewFriendInQml:{
            if(friendsBtn2.visible==true)
            {
                listViewFriendsHeight=listViewFriendsHeight+30
                listModelFriends.append({login: friendLogin,
                                            name:friendName,
                                            statusColor:friendStatus,
                                            msgState:false,
                                            clickVisible:false})
            }
        }
        onRemoveSubscriberInQml:{
            if(subscribersBtn2.visible==true)
            {
                listViewSubscribersHeight=listViewSubscribersHeight-30
                listModelSubscribers.remove(subIndex)
            }
        }
        onRemoveFriendInQml:{
            if(friendsBtn2.visible==true)
            {
                listViewFriendsHeight=listViewFriendsHeight-30
                listModelFriends.remove(friendIndex)
                if(friendId==friendIndex)
                {
                    friendInterface.visible=false
                    friendId=-1
                }
            }
        }
        onShowNewMsgInQml:{
            if(friendIndex!=-1 & friendIndex!=friendId)
            {
                textInfo.text="У вас новое сообщение"
                info.visible=true
                appCore.changeMsgState(friendIndex, true)
                if(friendsBtn2.visible==true)
                    listModelFriends.get(friendIndex).msgState=true
            }
        }
        onShowInfoInQml:{
            info.visible=false
            textInfo.text=infoStr
            info.visible=true
        }
        onShowIncomingCallInQml:{
            listModelIncomingCalls.append({incomingCallRecLoginPrm:login})
        }
        onShowIncomingConferenceInQml:{

            listModelIncomingConference.append({incomingConferenceNamePrm:confName, incomingConferenceCreatorPrm:confCreator})
        }

        onRemoveIncomingCallInQml:{
            for(var i=0;i<listModelIncomingCalls.count;i++)
            {
                if(listModelIncomingCalls.get(i).incomingCallRecLoginPrm===login)
                    listModelIncomingCalls.remove(i)
            }
        }

        onClose:{
            if(closeAppState==true & appCore.getCallSize()===0 & appCore.getConferenceSize()===0)
            {
                appCore.closeApp()
                Qt.quit()
            }
        }
    }
    onClosing: {
        close.accepted=false
        if(listModelIncomingCalls.count==0 & listModelIncomingConference.count==0)
        {
        closeAppState=true
        appCore.removeAllCalls()
        }
        else
            appCore.showInfo("Завершите необработанные вызовы!")

    }


    Rectangle{
        id:leftRec
        width: 301
        height: parent.height
        anchors.left: parent.left
        color: "#e9ebee"

        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(0, 500)
            gradient: Gradient {
                GradientStop { position: 1.0; color: "#d8e1ee" }
                GradientStop { position: 0.0; color: "#e9ebee" }
            }
        }
        Rectangle{
            id:borderLeftRec
            height: parent.height-30
            width: 1
            color: "#cfd2d8"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle{
            id:userNameRec
            width: 270
            height: 50
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter
            color: "white"
            radius: 2
            Rectangle{
                id:addFriends
                width: 30
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10
                radius: 2

                color: addFriendsArea.containsMouse?"#eff2f7":"white"
                Image {
                    id: image1
                    width: 30
                    height: 30
                    source: "qrc:icons/find-person-icon.png"

                }
                MouseArea{
                    id:addFriendsArea
                    width: 30
                    height: 30
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                        ToolTip{
                            delay: 1000
                            visible:addFriendsArea.containsMouse?true:false
                            background: Rectangle{
                                border.width: 0
                                color: "#5f000000"
                                radius: 2
                            }
                            Text {
                                text: qsTr("Найти друзей")
                                renderType: Text.NativeRendering;
                                font.family: "Tahoma"
                                font.pointSize: 8
                                color: "#e9ebee"
                            }
                        }
                    onClicked: {
                        if(findFriends.visible==true)
                        {
                            findFriends.visible=false
                        }
                        else
                        {
                            findFriends.visible=true
                            friendInterface.visible=false
                            makeConference.visible=false
                            conferenceInterface.visible=false
                            if(friendId!=-1)
                            {
                                listModelFriends.get(friendId).clickVisible=false
                                friendId=-1
                            }
                        }
                    }
                }
            }
            Rectangle{
                id:makeConf
                width: 30
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: addFriends.left
                anchors.rightMargin: 10
                radius: 2

                color: makeConfArea.containsMouse?"#eff2f7":"white"
                Image {
                    id: image133
                    width: 30
                    height: 30
                    source: "qrc:icons/make-conference.png"

                }
                MouseArea{
                    id:makeConfArea
                    width: 30
                    height: 30
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                        ToolTip{
                            delay: 1000
                            visible:makeConfArea.containsMouse?true:false
                            background: Rectangle{
                                border.width: 0
                                color: "#5f000000"
                                radius: 2
                            }
                            Text {
                                text: qsTr("Создать конференцию")
                                renderType: Text.NativeRendering;
                                font.family: "Tahoma"
                                font.pointSize: 8
                                color: "#e9ebee"
                            }
                        }
                        onClicked: {
                            if(makeConference.visible==true)
                            {
                                makeConference.visible=false

                            }
                            else
                            {
                                appCore.getFriendListForConference()
                                makeConference.visible=true
                                friendInterface.visible=false
                                findFriends.visible=false
                                conferenceInterface.visible=false
                                if(friendId!=-1)
                                {
                                    listModelFriends.get(friendId).clickVisible=false
                                    friendId=-1
                                }
                            }
                        }
                }
            }
            Rectangle{
                id:userNameRecForText
                width: 180
                height: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                color: "white"
                clip: true
                Text {
                    id: userNameText
                    text: qsTr("Логин:")
                    color: "#655881"
                    anchors.left: parent.left
                    anchors.top: parent.top
                    renderType: Text.NativeRendering;
                    font.family: "Tahoma"
                    font.pointSize: 10
                }
                Text {
                    id: userNameTextCustom
                    text: qsTr("")
                    color: "green"
                    anchors.left: userNameText.right
                    anchors.top: parent.top
                    renderType: Text.NativeRendering;
                    font.family: "Tahoma"
                    font.pointSize: 10
                }
                Text {
                    id: nameText
                    text: qsTr("Имя:")
                    color: "#655881"
                    anchors.left: parent.left
                    anchors.top: userNameText.bottom
                    renderType: Text.NativeRendering;
                    font.family: "Tahoma"
                    font.pointSize: 10
                }
                Text {
                    id: nameTextCustom
                    text: qsTr("")
                    color: "green"
                    anchors.left: nameText.right
                    anchors.top: userNameText.bottom
                    renderType: Text.NativeRendering;
                    font.family: "Tahoma"
                    font.pointSize: 10
                }
            }
        }
        Rectangle{
            id:friendsBtn
            width: 61
            height: 25
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.top: userNameRec.bottom
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
                color: friendsArea.containsMouse? "#9f97ae":"#655881"

            }
        }
        Rectangle{
            id:subscribersBtn
            width: 91
            height: 35
            anchors.left: friendsBtn.right
            anchors.leftMargin: 15
            anchors.top: userNameRec.bottom
            anchors.topMargin: 15
            color: "white"
            radius: 2
            border.width: 0
            border.color: "#cfd2d8"
            Text {
                id: subscribersTxt
                text: qsTr("Подписчики")
                anchors.horizontalCenter: parent.horizontalCenter
                renderType: Text.NativeRendering;
                anchors.top: parent.top
                anchors.topMargin: 5
                font.family: "Tahoma"
                font.pointSize: 10
                color: subscribersArea.containsMouse? "#9f97ae":"#655881"
            }
        }
        Rectangle{
            id:conferencesBtn
            width: 88
            height: 35
            anchors.left: subscribersBtn.right
            anchors.leftMargin: 15
            anchors.top: userNameRec.bottom
            anchors.topMargin: 15
            color: "white"
            radius: 2
            border.width: 0

            border.color: "#cfd2d8"
            Text {
                id: conferencesTxt
                text: qsTr("Конференции")
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
                renderType: Text.NativeRendering;
                font.family: "Tahoma"
                font.pointSize: 10
                color: conferencesArea.containsMouse? "#9f97ae":"#655881"
            }
        }
        Rectangle{
            id:userContent
            width: 270
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.top: friendsBtn.top
            anchors.topMargin: 25
            color: "white"
            radius: 2
            border.width: 1
            border.color: "#cfd2d8"
            clip: true
            Flickable {
                width: parent.width
                height: parent.height
                clip: true
                contentHeight: listViewFriendsHeight+20+listViewConferencesHeight+ listViewSubscribersHeight
                ScrollBar.vertical: ScrollBar { interactive: false}
                boundsBehavior: Flickable.StopAtBounds
                flickableDirection: Flickable.VerticalFlick
                anchors.top: parent.top
                anchors.topMargin: 10
                maximumFlickVelocity: 1500
                ListView {
                    id: listViewFriends
                    anchors.top: parent.top
                    height: listViewFriendsHeight+20
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
                            Rectangle{
                                id:recFriendItem2
                                width: parent.width
                                height: parent.height
                                color: "#eeeff0"
                                radius: 2
                                visible: clickVisible
                            }
                            MouseArea{
                                id:recFriendItemArea
                                hoverEnabled: true
                                width: parent.width
                                height: parent.height
                                cursorShape: Qt.PointingHandCursor                             
                                onClicked: {
                                    if(friendId!=-1)
                                    {
                                        listModelFriends.get(friendId).clickVisible=false
                                        listModelFriends.get(index).clickVisible=true
                                    }
                                    else
                                    {
                                        listModelFriends.get(index).clickVisible=true
                                    }
                                    listModelFriends.get(index).msgState=false
                                    appCore.changeMsgState(index, false)
                                    friendId=index
                                    appCore.showIFriend(loginPrm.text, namePrm.text)
                                    friendInterface.visible=true
                                    findFriends.visible=false
                                    makeConference.visible=false
                                    conferenceInterface.visible=false
                                }
                            }
                        }
                        Rectangle{
                            id:circleStatus
                            width: 8
                            height: 8
                            radius: width/2
                            color: statusColor
                            anchors.verticalCenter: recFriendItem.verticalCenter
                            anchors.left: recFriendItem. left
                            anchors.leftMargin: 10

                        }
                        Text {
                            id: loginPrm
                            text: qsTr(login)
                            renderType: Text.NativeRendering;

                            font.family: "Tahoma"
                            font.pointSize: 10
                            anchors.verticalCenter: recFriendItem.verticalCenter
                            anchors.left: circleStatus.right
                            anchors.leftMargin: 10
                            color: "#655881"
                        }
                        Text {
                            id: namePrm
                            anchors.left: loginPrm.right
                            anchors.leftMargin: 5
                            anchors.right: image22.right
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
                            id: image22
                            width: 20
                            height: 20
                            visible: msgState
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: image2.left
                            source: "qrc:icons/notify-about-msg.png"
                        }
                        Image {
                            id: image2
                            width: 20
                            height: 20
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            source: "qrc:icons/arrow-right.png"
                        }
                    }
                    model: ListModel {
                        id: listModelFriends
                    }
                }

                ListView {
                    id: listViewSubscribers
                    anchors.top: parent.top
                    height: listViewSubscribersHeight+20
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
                            id:recSubscribersItem
                            width: parent.width
                            height: parent.height
                            radius: 2
                            Rectangle{
                                id:minusid
                                width: 30
                                height: 30
                                anchors.right: parent.right
                                color: minusArea.containsMouse?"#eeeff0":"white"
                                radius: 2
                                Image {
                                    id: image3
                                    width: 20
                                    height: 20
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    source: "qrc:icons/minus.png"
                                }
                                MouseArea{
                                    id:minusArea
                                    hoverEnabled: true
                                    width: parent.width
                                    height: parent.height
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        appCore.removeSubscriber(loginSubscriberPrm.text)
                                        listModelSubscribers.remove(index)
                                        appCore.showInfo("Заявка отклонена")
                                    }
                                }
                                ToolTip{
                                    delay: 1000
                                    visible:minusArea.containsMouse?true:false
                                    background: Rectangle{
                                        border.width: 0
                                        color: "#5f000000"
                                        radius: 2
                                    }
                                    Text {
                                        text: qsTr("Отклонить заявку")
                                        renderType: Text.NativeRendering;
                                        font.family: "Tahoma"
                                        font.pointSize: 8
                                        color: "#e9ebee"
                                    }
                                }
                            }
                            Rectangle{
                                id:plusid
                                width: 30
                                height: 30
                                anchors.right: minusid.left
                                color: plusArea.containsMouse?"#eeeff0":"white"
                                radius: 2
                                Image {
                                    id: image4
                                    width: 20
                                    height: 20
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    source: "qrc:icons/plus.png"
                                }
                                MouseArea{
                                    id:plusArea
                                    hoverEnabled: true
                                    width: parent.width
                                    height: parent.height
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        appCore.addToFriendList(loginSubscriberPrm.text)
                                        listModelSubscribers.remove(index)
                                        appCore.showInfo("Добавлен новый друг")
                                    }
                                }
                                ToolTip{
                                    delay: 1000
                                    visible:plusArea.containsMouse?true:false
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
                        }
                        Text {
                            id: loginSubscriberPrm
                            text: qsTr(login)
                            renderType: Text.NativeRendering;
                            clip: true
                            font.family: "Tahoma"
                            font.pointSize: 10
                            anchors.verticalCenter: recSubscribersItem.verticalCenter
                            anchors.left: recSubscribersItem.left
                            anchors.right: recSubscribersItem.right
                            anchors.rightMargin: 70
                            anchors.leftMargin: 10
                            color: "#655881"
                        }
                    }
                    model: ListModel {
                        id: listModelSubscribers
                    }
                }
                ListView {
                    id: listViewConferences
                    anchors.top: parent.top
                    height: listViewConferencesHeight+20
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
                            id:recConferenceItem
                            width: parent.width
                            height: parent.height
                            color: recConferenceItemArea.containsMouse?"#eeeff0":"white"
                            radius: 2
                            MouseArea{
                                id:recConferenceItemArea
                                hoverEnabled: true
                                width: parent.width
                                height: parent.height
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    friendId=-1
                                    appCore.showIConference(listModelConferences.get(index).confNamePrm,
                                                            listModelConferences.get(index).confCreatorNamePrm)
                                    friendInterface.visible=false
                                    findFriends.visible=false
                                    makeConference.visible=false
                                }
                            }
                        }

                        Text {
                            id: conferenceName
                            text: qsTr(confNamePrm)
                            renderType: Text.NativeRendering;

                            font.family: "Tahoma"
                            font.pointSize: 10
                            anchors.verticalCenter: recConferenceItem.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.rightMargin: 30
                            color: "#655881"
                        }
                        Text {
                            id: confCreatorName
                            text: qsTr(" ("+confCreatorNamePrm+")")
                            renderType: Text.NativeRendering;

                            font.family: "Tahoma"
                            font.pointSize: 10
                            anchors.verticalCenter: recConferenceItem.verticalCenter
                            anchors.left: conferenceName.right
                            anchors.right: image222.right
                            anchors.rightMargin: 30
                            color: "blue"
                        }


                        Image {
                            id: image222
                            width: 20
                            height: 20
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            source: "qrc:icons/arrow-right.png"
                        }
                    }
                    model: ListModel {
                        id: listModelConferences
                    }
                }
            }
            Rectangle{
                height: 1
                width: parent.width-6
                color: "#cfd2d8"
                anchors.bottom: parent.bottom


            }
        }
        Rectangle{
            id:friendsBtn2
            width: 59
            height: 10
            anchors.left: parent.left
            anchors.leftMargin: 17
            anchors.top: friendsBtn.top
            anchors.topMargin: 23
            color: "white"
        }
        Rectangle{
            id:subscribersBtn2
            width: 89
            height: 10
            anchors.left: friendsBtn.right
            anchors.leftMargin: 16
            anchors.top: friendsBtn.top
            anchors.topMargin: 23
            color: "white"
            visible: false
        }
        Rectangle{
            id:conferencesBtn2
            width: 86
            height: 10
            anchors.left: subscribersBtn.right
            anchors.leftMargin: 16
            anchors.top: friendsBtn.top
            anchors.topMargin: 23
            color: "white"
            visible: false
        }
        MouseArea{
            id:friendsArea
            width: 61
            height: 25
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.top: userNameRec.bottom
            anchors.topMargin: 15
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                subscribersBtn2.visible=false
                conferencesBtn2.visible=false
                friendsBtn2.visible=true
                subscribersBtn.border.width=0
                conferencesBtn.border.width=0
                friendsBtn.border.width=1
                appCore.getFriendsList()
            }
        }
        MouseArea{
            id:subscribersArea
            width: 91
            height: 25
            anchors.left: friendsBtn.right
            anchors.leftMargin: 15
            anchors.top: userNameRec.bottom
            anchors.topMargin: 15
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                subscribersBtn2.visible=true
                conferencesBtn2.visible=false
                friendsBtn2.visible=false
                subscribersBtn.border.width=1
                conferencesBtn.border.width=0
                friendsBtn.border.width=0
                appCore.getSubscribersList()
            }
        }
        MouseArea{
            id:conferencesArea
            width: 88
            height: 25
            anchors.left: subscribersBtn.right
            anchors.leftMargin: 15
            anchors.top: userNameRec.bottom
            anchors.topMargin: 15
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {

                appCore.getConferencesList()
            }
        }
    }
    Rectangle{
        id:rightRec
        height: parent.height
        anchors.left: leftRec.right
        anchors.right: parent.right
        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(0, 500)
            gradient: Gradient {
                GradientStop { position: 1.0; color: "#d8e1ee" }
                GradientStop { position: 0.0; color: "#e9ebee" }
            }
        }
        FindFriends{
            id:findFriends
            width: 316
            height: parent.height-30
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            visible: false
        }
        MakeConference{
            id:makeConference
            height: parent.height-30
            width: parent.width-30
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 15
            visible: false

        }

        IFriend{
            id:friendInterface
            visible: false

        }
        IConference{
            id:conferenceInterface
            height: parent.height-30
            width: parent.width-30
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 15
            visible: false
        }
    }
    Rectangle{
        id:disableRec
        width: parent.width
        height: parent.height
        visible: false
        color: "#60000000"
        MouseArea{
            width: parent.width
            height: parent.height
        }
        Text {
            id: load
            text: qsTr("Загрузка...")
            renderType: Text.NativeRendering;
            font.family: "Tahoma"
            font.pointSize: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
        }
    }
    Rectangle{
        id:info
        height: 15
        width: 285
        color: "#5f000000"
        anchors.bottom: parent.bottom
        visible: false
        clip: true
        Timer {
            interval: 5000; running: info.visible?true:false; repeat: false
            onTriggered: info.visible=false
        }
        Text {
            id:textInfo
            text: qsTr("")
            renderType: Text.NativeRendering;
            font.family: "Tahoma"
            font.pointSize: 8
            anchors.left: parent.left
            anchors.leftMargin: 10
            color: "#e9ebee"
        }
    }
    Rectangle{
        id:incomingCallRec
        anchors.fill: parent
        color: "#5f000000"
        clip: true
        visible: false
        MouseArea{
            anchors.fill: parent
        }
        ListView {
            id: listViewincomingCalls
            width: 400
            height: 102
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            interactive: false
            clip: true
            Rectangle{
                id:incomingCallNotNullRec
                width: parent.width
                height: 20
                color: "#e4e8ee"
                clip: true
                Text {
                    id: incomingCallNotNullTxt
                    text: qsTr("Ответ на звонок приведет к отмене предыдущего вызова.")
                    renderType: Text.NativeRendering;
                    font.family: "Tahoma"
                    font.pointSize: 8
                    color: "red"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            delegate: Item {
                id: incomingCallItem
                width: 400
                height: 102
                Rectangle{
                    id:incomingCallRecInfo
                    width: 400
                    height:102
                    color: "white"
                    radius: 2
                    border.width: 1
                    border.color: "#cfd2d8"
                    Text {
                        id: incomingCallRecTxt
                        text: qsTr("Вам звонит ")
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 8
                        color: "#655881"
                        anchors.top: parent.top
                        anchors.topMargin: 26
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        id: incomingCallRecLogin
                        text: qsTr(incomingCallRecLoginPrm)
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 8
                        color: "blue"
                        anchors.top: parent.top
                        anchors.topMargin: 26
                        anchors.left: incomingCallRecTxt.right
                    }
                    Rectangle{
                        id:answerCallRec
                        height: 30
                        width: 177
                        color: answerCallArea.containsMouse?"#03a903":"green"
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 15
                        radius: 2
                        Image {
                            height: 30
                            width: 30
                            source: "qrc:icons/call-white.png"
                        }
                        Text {
                            id: answerCallText
                            text: qsTr("Ответить")
                            renderType: Text.NativeRendering;
                            font.family: "Tahoma"
                            font.pointSize: 8
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        MouseArea{
                            id:answerCallArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                listModelIncomingCalls.remove(index)
                                appCore.answerCall(incomingCallRecLogin.text, true)
                            }
                        }
                    }
                    Rectangle{
                        id:hangupCallRec
                        height: 30
                        width: 177
                        color: hangupCallArea.containsMouse?"red":"#c30404"
                        anchors.right: parent.right
                        anchors.rightMargin: 15
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 15
                        radius: 2
                        Image {
                            height: 30
                            width: 30
                            source: "qrc:icons/call-white.png"
                        }

                        Text {
                            id: hangupCallText
                            text: qsTr("Завершить")
                            renderType: Text.NativeRendering;
                            font.family: "Tahoma"
                            font.pointSize: 8
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        MouseArea{
                            id:hangupCallArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                listModelIncomingCalls.remove(index)
                                appCore.answerCall(incomingCallRecLogin.text, false)
                            }
                        }
                    }
                }

            }
            Timer {
                interval: 3000; running: listModelIncomingCalls.count>0?true:false; repeat: false
                onTriggered: incomingCallRec.visible=true
            }
            model: ListModel {
                id: listModelIncomingCalls
                onCountChanged: {
                    if(listModelIncomingCalls.count==0)
                        incomingCallRec.visible=false
                    if(appCore.getCallSize()>1 | appCore.getConferenceSize()>1 |
                            appCore.getCallSize()===1 & appCore.getConferenceSize()===1)
                        incomingCallNotNullRec.visible=true
                    else
                        incomingCallNotNullRec.visible=false
                }
            }
        }

    }
    Rectangle{
        id:incomingConferenceRec
        anchors.fill: parent
        color: "#5f000000"
        clip: true
        visible: false
        MouseArea{
            anchors.fill: parent
        }
        ListView {
            id: listViewIncomingConference
            width: 400
            height: 107
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            interactive: false
            clip: true
            Rectangle{
                id:incomingConferenceNotNullRec
                width: parent.width
                height: 20
                color: "#e4e8ee"
                clip: true
                Text {
                    id: incomingConferenceNotNullTxt
                    text: qsTr("Ответ на звонок приведет к отмене предыдущего вызова.")
                    renderType: Text.NativeRendering;
                    font.family: "Tahoma"
                    font.pointSize: 8
                    color: "red"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            delegate: Item {
                id: incomingConferenceItem
                width: 400
                height: 107
                Rectangle{
                    id:incomingConferenceRecInfo
                    width: 400
                    height:107
                    color: "white"
                    radius: 2
                    border.width: 1
                    border.color: "#cfd2d8"
                    Text {
                        id: incomingConferenceRecTxt
                        text: qsTr("Конференция: ")
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 8
                        color: "#655881"
                        anchors.top: parent.top
                        anchors.topMargin: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        id: incomingConferenceRecLogin
                        text: qsTr(incomingConferenceNamePrm+"("+incomingConferenceCreatorPrm+")")
                        renderType: Text.NativeRendering;
                        font.family: "Tahoma"
                        font.pointSize: 8
                        color: "blue"
                        anchors.top: incomingConferenceRecTxt.bottom
                        anchors.topMargin: 5
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Rectangle{
                        id:answerConferenceRec
                        height: 30
                        width: 177
                        color: answerConferenceArea.containsMouse?"#03a903":"green"
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 15
                        radius: 2
                        Image {
                            height: 30
                            width: 30
                            source: "qrc:icons/call-white.png"
                        }
                        Text {
                            id: answerConferenceText
                            text: qsTr("Ответить")
                            renderType: Text.NativeRendering;
                            font.family: "Tahoma"
                            font.pointSize: 8
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        MouseArea{
                            id:answerConferenceArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                appCore.setDefaultVolumeForConference();
                                var icn=listModelIncomingConference.get(index).incomingConferenceNamePrm
                                var icc=listModelIncomingConference.get(index).incomingConferenceCreatorPrm
                                listModelIncomingConference.remove(index)
                                friendId=-1
                                appCore.answerConference(icn, icc,true)
                            }
                        }
                    }
                    Rectangle{
                        id:hangupConferenceRec
                        height: 30
                        width: 177
                        color: hangupConferenceArea.containsMouse?"red":"#c30404"
                        anchors.right: parent.right
                        anchors.rightMargin: 15
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 15
                        radius: 2
                        Image {
                            height: 30
                            width: 30
                            source: "qrc:icons/call-white.png"
                        }

                        Text {
                            id: hangupConferenceText
                            text: qsTr("Завершить")
                            renderType: Text.NativeRendering;
                            font.family: "Tahoma"
                            font.pointSize: 8
                            color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        MouseArea{
                            id:hangupConferenceArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                var icn=listModelIncomingConference.get(index).incomingConferenceNamePrm
                                var icc=listModelIncomingConference.get(index).incomingConferenceCreatorPrm
                                listModelIncomingConference.remove(index)
                                appCore.answerConference(icn,icc,false)
                            }
                        }
                    }
                }

            }
            Timer {
                interval: 3000; running: listModelIncomingConference.count>0?true:false; repeat: false
                onTriggered: {
                    appCore.getConferencesList()
                    incomingConferenceRec.visible=true
                }


            }
            model: ListModel {
                id: listModelIncomingConference
                onCountChanged: {

                    if(listModelIncomingConference.count==0)
                        incomingConferenceRec.visible=false
                    if(appCore.getCallSize()>1 | appCore.getConferenceSize()>1 |
                            appCore.getCallSize()===1 & appCore.getConferenceSize()===1)
                        incomingConferenceNotNullRec.visible=true
                    else
                        incomingConferenceNotNullRec.visible=false
                }
            }
        }

    }
}
