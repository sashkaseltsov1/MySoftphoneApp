import QtQuick 2.0
import QtQuick.Controls 2.12

Rectangle{
    id:config
    width:parent.width
    height: parent.height
    color: "#e9ebee"
    Connections{
        target: appCore
        onSettingsInfo:{
            listModel.clear()
            listViewHeight=0
            for (var i = 0; i < srv.length; ++i) {
                listViewHeight=listViewHeight+45
                listModel.append({srvName: srv[i]})
            }
            listModel2.clear()
            listViewHeight2=0
            for (i = 0; i < otherSettings.length; i+=2) {
                listViewHeight2=listViewHeight2+66
                listModel2.append({setting: otherSettings[i+1],settingName:otherSettings[i]+":"})
            }
        }
    }
    signal logInForm2
    property int listViewHeight:0
    property int listViewHeight2:0
    property int contentH: textCfg.height+
                           line.height+
                           textStunSrvLst.height+
                           listViewHeight+
                           listViewHeight2+
                           rec.height+
                           saveSettings.height+
                           backToLoginRec.height+
                           15+7+7+10+10+7+17
    MouseArea{
        width: parent.width
        height: parent.height
        onClicked: {
            forceActiveFocus()
        }
    }
    Rectangle{
        id:cfgArea
        width: 350
        height: parent.height-100
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        radius: 2
        clip: true
        Flickable {
            width: parent.width
            height: parent.height
            clip: true
            contentHeight: contentH
            ScrollBar.vertical: ScrollBar { policy: "AlwaysOn"
                interactive: false}
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick
            maximumFlickVelocity: 1500
            Text {
                id: textCfg
                text: qsTr("Конфигурация:")
                font.family: "Tahoma"
                font.pointSize: 12
                renderType: Text.NativeRendering;
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 15
            }
            Rectangle{
                id:line
                width:316
                height: 1
                color: "#bdbdbd"
                anchors.top: textCfg.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 7
            }
            Text {
                id: textStunSrvLst
                text: qsTr("STUN-серверы:")
                font.family: "Tahoma"
                font.pointSize: 10
                renderType: Text.NativeRendering;
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: line.bottom
                anchors.topMargin: 7
            }
            ListView {
                id: listView
                anchors.top: textStunSrvLst.bottom

                height: listViewHeight
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 10
                spacing: 15
                interactive: false
                delegate: Item {
                    id: item
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 30
                    TextField{
                        id:srv
                        width:316
                        height: 30
                        selectByMouse: true
                        validator: RegExpValidator { regExp: /[A-z0-9_.:-]+$/ }
                        selectionColor: "#d8e1ee"
                        color: "black"
                        onTextChanged: {
                            listModel.get(index).srvName=text
                        }
                        text: srvName
                        font.family: "Tahoma"
                        font.pointSize: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        renderType: Text.NativeRendering;
                        placeholderText: "Введите STUN-сервер"
                        placeholderTextColor: "#bdbdbd"
                        background: Rectangle{
                            border.color: parent.activeFocus? "#9f97ae":"#bdbdbd"
                            radius: 2
                        }

                    }
                }
                model: ListModel {
                    id: listModel
                }
            }
            Rectangle{
                id:rec
                width: 316
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top:listView.bottom
                Text {
                    id: deleteServer
                    text: qsTr("Удалить")
                    color: deleteServerArea.containsMouse? "#9f97ae":"#655881"
                    font.underline: deleteServerArea.containsMouse? true:false
                    renderType: Text.NativeRendering;
                    font.family: "Tahoma"
                    font.pointSize: 10
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea{
                        id:deleteServerArea
                        width: parent.width
                        height: parent.height
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            if(listModel.count>1)
                            {
                                listModel.remove(listModel.count-1)
                                listViewHeight=listViewHeight-45
                            }
                        }
                    }
                }
                Text {
                    id: point
                    text: qsTr(" | ")
                    color: "#655881"
                    renderType: Text.NativeRendering;
                    font.family: "Tahoma"
                    font.pointSize: 10
                    anchors.right: deleteServer.left
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    id: newServer
                    text: qsTr("Добавить")
                    renderType: Text.NativeRendering;
                    color: newServerArea.containsMouse? "#9f97ae":"#655881"
                    font.underline: newServerArea.containsMouse? true:false
                    font.family: "Tahoma"
                    font.pointSize: 10
                    anchors.right: point.left
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea{
                        id:newServerArea
                        width: parent.width
                        height: parent.height
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            if(listModel.count<11)
                            {
                                listModel.append({srvName: ""})
                                listViewHeight=listViewHeight+45
                            }
                        }
                    }
                }
            }
            ListView {
                id: listView2
                anchors.top: rec.bottom
                height: listViewHeight2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 10
                interactive: false
                delegate: Item {
                    id: item2
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: 46+20
                            Text {
                                id: settingText
                                text: qsTr(settingName)
                                font.family: "Tahoma"
                                font.pointSize: 10
                                renderType: Text.NativeRendering;
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                    TextField{
                        id:settingsVar
                        width:316
                        height: 30
                        selectByMouse: true
                        selectionColor: "#d8e1ee"
                        color: "black"
                        text: setting
                        font.family: "Tahoma"
                        font.pointSize: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: settingText.bottom
                        validator: RegExpValidator { regExp: /[A-z0-9_.,:-]+$/ }
                        anchors.topMargin: 10
                        renderType: Text.NativeRendering;
                        onTextChanged: {
                            listModel2.get(index).setting=text
                        }
                        placeholderText: settingName
                        placeholderTextColor: "#bdbdbd"
                        background: Rectangle{
                            border.color: parent.activeFocus? "#9f97ae":"#bdbdbd"
                            radius: 2
                        }
                    }
                }
                model: ListModel {
                    id: listModel2
                }
            }
            Rectangle{
                id:saveSettings
                width:316
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: listView2.bottom
                anchors.topMargin: 7
                color: saveSettingsArea.containsMouse?"#726293":"#655881"
                radius: 2
                Text {
                    id: saveSettingsTxt
                    text: qsTr("Сохранить настройки")
                    color: "white"
                    renderType: Text.NativeRendering;
                    font.family: "Tahoma"
                    font.pointSize: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
                MouseArea{
                    id:saveSettingsArea
                    width: parent.width
                    height: parent.height
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        var stunServerList = new Array
                        for(var i=0;i<listModel.count;i++)
                            stunServerList.push(listModel.get(i).srvName)

                        var otherSettings=new Array
                        for(i=0;i<listModel2.count;i++)
                            otherSettings.push(listModel2.get(i).setting)
                        appCore.editSettings(stunServerList, otherSettings)
                        settingsUpdatedText.visible=true
                    }
                }
            }
            Rectangle{
                id:backToLoginRec
                width:316
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: saveSettings.bottom
                Text {
                    id: settingsUpdatedText
                    text: qsTr("Настройки обновлены!")
                    color: "green"
                    renderType: Text.NativeRendering;
                    font.family: "Tahoma"
                    font.pointSize: 10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: false
                }
                Text {
                    id: backToLogin
                    text: qsTr("Назад")
                    color: backToLoginArea.containsMouse? "#9f97ae":"#655881"
                    font.underline: backToLoginArea.containsMouse? true:false
                    renderType: Text.NativeRendering;
                    font.family: "Tahoma"
                    font.pointSize: 10
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea{
                        id:backToLoginArea
                        width: parent.width
                        height: parent.height
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            settingsUpdatedText.visible=false
                            config.logInForm2()
                        }
                    }
                }
            }
        }
    }
}
