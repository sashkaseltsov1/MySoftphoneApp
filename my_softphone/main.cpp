#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <appcore.h>
#include <QQmlContext>
#include <QCoreApplication>
#include <QDebug>
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_UseSoftwareOpenGL);

    QGuiApplication app(argc, argv);
    QIcon icon(":/icons/logo.png");
    app.setWindowIcon(icon);

    QQmlApplicationEngine engine;
    AppCore appCore;
    QQmlContext *context = engine.rootContext();
    context->setContextProperty("appCore", &appCore);
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
