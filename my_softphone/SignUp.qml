import QtQuick 2.0
import QtQuick.Controls 2.12

Rectangle{
    id:content
    width:parent.width
    height: parent.height
    color: "#e9ebee"

    signal logInForm

    Connections{
        target: appCore
        onNewAccInfo:{
            signInfo.visible=true
            signInfo.text=str
            signupTxt.text="Зарегистрироваться"
            signupBtnArea.enabled=true
            signupBtnArea.cursorShape=Qt.PointingHandCursor
            backToLoginArea.enabled=true
            backToLoginArea.cursorShape=Qt.PointingHandCursor
            name.text=""
            login.text=""
            password.text=""
            confirmPwd.text=""
        }
    }

    MouseArea{
        width: parent.width
        height: parent.height
        onClicked: {
            password.focus=false
            login.focus=false
            name.focus=false
            confirmPwd.focus=false
        }
    }
    Rectangle{
        id:authArea
        width: 350
        height: 340
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        radius: 2
        Text {
            id: textSignUp
            text: qsTr("Регистрация:")
            font.family: "Tahoma"
            font.pointSize: 12
            renderType: Text.NativeRendering;
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 15
        }
        TextField{
            id:name
            width:316
            height: 30
            selectByMouse: true
            selectionColor: "#d8e1ee"
            color: "black"
            validator: RegExpValidator { regExp: /[A-z0-9_]+$/ }
            font.family: "Tahoma"
            font.pointSize: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: textSignUp.bottom
            anchors.topMargin: 15
            renderType: Text.NativeRendering;
            placeholderText: "Введите имя"
            placeholderTextColor: "#bdbdbd"
            background: Rectangle{
                border.color: name.focus? "#9f97ae":"#bdbdbd"
                radius: 2
            }

        }
        TextField{
            id:login
            width:316
            height: 30
            selectByMouse: true
            selectionColor: "#d8e1ee"
            color: "black"
            validator: RegExpValidator { regExp: /[A-z0-9_]+$/ }
            font.family: "Tahoma"
            font.pointSize: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: name.bottom
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
            selectByMouse: true
            selectionColor: "#d8e1ee"
            color: "black"
            validator: RegExpValidator { regExp: /[A-z0-9_]+$/ }
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
        TextField{
            id:confirmPwd
            width:316
            height: 30
            validator: RegExpValidator { regExp: /[A-z0-9_]+$/ }
            selectByMouse: true
            selectionColor: "#d8e1ee"
            color: "black"
            font.family: "Tahoma"
            font.pointSize: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: password.bottom
            anchors.topMargin: 15
            placeholderText: "Подтвердите пароль"
            placeholderTextColor: "#bdbdbd"
            renderType: Text.NativeRendering;
            echoMode: TextInput.Password
            background: Rectangle{
                border.color: confirmPwd.focus? "#9f97ae":"#bdbdbd"
                radius: 2
            }
        }
        Rectangle{
            id:signupBtn
            width:316
            height: 30
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: confirmPwd.bottom
            anchors.topMargin: 15
            color: signupBtnArea.containsMouse?"#726293":"#655881"
            radius: 2
            Text {
                id: signupTxt
                text: qsTr("Зарегистрироваться")
                color: "white"
                renderType: Text.NativeRendering;
                font.family: "Tahoma"
                font.pointSize: 10
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea{
                id:signupBtnArea
                width: parent.width
                height: parent.height
                hoverEnabled: true

                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    signInfo.visible=false
                    signupTxt.text="Подождите..."
                    enabled = false
                    cursorShape=Qt.ArrowCursor
                    backToLoginArea.enabled=false
                    backToLoginArea.cursorShape=Qt.ArrowCursor
                    appCore.addNewAcc(name.text, login.text, password.text, confirmPwd.text)

                }
            }
        }
        Rectangle{
            width: 316
            height: 30
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:signupBtn.bottom
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
                        signInfo.visible=false
                        content.logInForm()
                    }
                }
            }
            Text {
                width: parent.width
                id: signInfo
                horizontalAlignment: Text.AlignHCenter
                visible: false
                wrapMode: Text.WordWrap
                color: signInfo.text=="Пользователь зарегистрирован!"?"green":"red";
                text: qsTr("text")
                renderType: Text.NativeRendering;
                font.family: "Tahoma"
                font.pointSize: 10
                anchors.top: backToLogin.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

    }
}
