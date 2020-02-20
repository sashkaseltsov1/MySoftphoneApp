import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0
Window{
    visible: true
    id:beginWindow
    width: 450
    height: 600
    minimumWidth: 450
    minimumHeight: 600
    title: qsTr("Mysoftphone")


    LinearGradient {
        anchors.fill: parent
        start: Qt.point(0, 0)
        end: Qt.point(0, 500)
        gradient: Gradient {
            GradientStop { position: 1.0; color: "#d8e1ee" }
            GradientStop { position: 0.0; color: "#e9ebee" }
        }
    }
    Connections{
        target: appCore
        onNewAccInfo:{

            console.log(str)
        }

    }
    UserWindow{
        id:uWin
    }
    LogIn{
        id:logIn
        visible: true
        onSignUpForm:{
            logIn.visible=false
            signUp.visible=true
        }
        onConfigForm: {
            logIn.visible=false
            config.visible=true

        }
        onUserWindow: {
            beginWindow.close()
            uWin.show()
        }
    }

    SignUp{
        id:signUp
        visible: false
        onLogInForm: {
            logIn.visible=true
            signUp.visible=false

        }
    }
    Config{
        id:config
        visible: false
        onLogInForm2: {
            logIn.visible=true
            config.visible=false

        }
    }
}



