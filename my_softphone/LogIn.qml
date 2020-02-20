import QtQuick 2.0
import QtQuick.Controls 2.12


    Rectangle{
        id:content
        width:parent.width
        height: parent.height
        color: "#e9ebee"
        signal userWindow
        signal signUpForm
        signal configForm
        Connections{
            target: appCore

            onLoginInfo:{
                if(regState==true)
                {
                    loginTxt.text="Авторизация:"
                    loginInfo.text="Авторизация прошла успешно!"
                    loginInfo.color="green"
                    loginInfo.visible=true

                    loginBtnArea.enabled=true
                    loginBtnArea.cursorShape=Qt.PointingHandCursor
                    configureArea.enabled=true
                    configureArea.cursorShape=Qt.PointingHandCursor
                    signUpArea.enabled=true
                    signUpArea.cursorShape=Qt.PointingHandCursor
                    content.userWindow()
                }
                else
                {
                    console.log("hahaha")
                    appCore.stopPjsuaLib()
                }
            }
            onPjsuaLibDestroyed:{
                loginTxt.text="Войти"
                loginInfo.text="Ошибка авторизации!"
                loginInfo.color="red"
                loginInfo.visible=true

                loginBtnArea.enabled=true
                loginBtnArea.cursorShape=Qt.PointingHandCursor
                configureArea.enabled=true
                configureArea.cursorShape=Qt.PointingHandCursor
                signUpArea.enabled=true
                signUpArea.cursorShape=Qt.PointingHandCursor

                console.log("bbbbbb")

            }
        }
        MouseArea{
            width: parent.width
            height: parent.height
            onClicked: {
                password.focus=false
                login.focus=false
            }
        }
        Rectangle{
            id:authArea
            width: 350
            height: 252
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            radius: 2
            Text {
                id: textLogIn
                text: qsTr("Авторизация:")
                font.family: "Tahoma"
                font.pointSize: 12
                renderType: Text.NativeRendering;
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 15
            }
            TextField{
                id:login
                width:316
                height: 30
                validator: RegExpValidator { regExp: /[A-z0-9_]+$/ }
                selectByMouse: true
                selectionColor: "#d8e1ee"
                color: "black"
                font.family: "Tahoma"
                font.pointSize: 10
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: textLogIn.bottom
                anchors.topMargin: 15
                renderType: Text.NativeRendering;
                placeholderText: "Введите логин"
                placeholderTextColor: "#bdbdbd"
                background: Rectangle{
                    border.color: login.focus? "#9f97ae":"#bdbdbd"
                    radius: 2
                }

            }
            TextField{
                id:password
                width:316
                height: 30
                validator: RegExpValidator { regExp: /[A-z0-9_]+$/ }
                selectByMouse: true
                selectionColor: "#d8e1ee"
                color: "black"
                font.family: "Tahoma"
                font.pointSize: 10
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: login.bottom
                anchors.topMargin: 15
                placeholderText: "Введите пароль"
                placeholderTextColor: "#bdbdbd"
                renderType: Text.NativeRendering;
                echoMode: TextInput.Password
                background: Rectangle{
                    border.color: password.focus? "#9f97ae":"#bdbdbd"
                    radius: 2
                }
            }
            Rectangle{
                id:loginBtn
                width:316
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: password.bottom
                anchors.topMargin: 15
                color: loginBtnArea.containsMouse?"#726293":"#655881"
                radius: 2
                Text {
                    id: loginTxt
                    text: qsTr("Войти")
                    color: "white"
                    renderType: Text.NativeRendering;
                    font.family: "Tahoma"
                    font.pointSize: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                }
                MouseArea{
                    id:loginBtnArea
                    width: parent.width
                    height: parent.height
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if(login.text!="" | password.text!="")
                        {
                            loginTxt.text="Подождите..."
                            appCore.startPjsuaLib(login.text, password.text)
                            loginBtnArea.enabled=false
                            loginBtnArea.cursorShape=Qt.ArrowCursor
                            configureArea.enabled=false
                            configureArea.cursorShape=Qt.ArrowCursor
                            signUpArea.enabled=false
                            signUpArea.cursorShape=Qt.ArrowCursor
                            loginInfo.visible=false
                        }
                        else
                        {
                            loginInfo.color="red"
                            loginInfo.text="Ошибка: Пустое поле!"
                            loginInfo.visible=true
                        }


                    }
                }
            }
            Rectangle{
                id:rec
                width: 316
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top:loginBtn.bottom
                Text {
                    id: configure
                    text: qsTr("Настройки")
                    color: configureArea.containsMouse? "#9f97ae":"#655881"
                    font.underline: configureArea.containsMouse? true:false
                    renderType: Text.NativeRendering;
                    font.family: "Tahoma"
                    font.pointSize: 10
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea{
                        id:configureArea
                        width: parent.width
                        height: parent.height
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            content.configForm()
                            loginInfo.visible=false
                            appCore.getSettings()
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
                    anchors.right: configure.left
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    id: signUp
                    text: qsTr("Регистрация")
                    renderType: Text.NativeRendering;
                    color: signUpArea.containsMouse? "#9f97ae":"#655881"
                    font.underline: signUpArea.containsMouse? true:false
                    font.family: "Tahoma"
                    font.pointSize: 10
                    anchors.right: point.left
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea{
                        id:signUpArea
                        width: parent.width
                        height: parent.height
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: {
                            content.signUpForm()
                            loginInfo.visible=false
                        }
                    }
                }
            }
            Text {
                id: loginInfo
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                visible: false
                wrapMode: Text.WordWrap
                text: qsTr("text")
                renderType: Text.NativeRendering;
                font.family: "Tahoma"
                font.pointSize: 10
                anchors.top: rec.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

    }


