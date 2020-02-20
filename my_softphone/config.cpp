#include "config.h"

Config::Config()
{
    cfg=new QSettings("settings.conf",QSettings::IniFormat);

}

void Config::initDefaultCfg()
{
    cfg->setValue("main_config/ip","176.197.36.4");
    cfg->setValue("main_config/main_port","5006");
    cfg->setValue("main_config/sip_port","5005");
    cfg->setValue("main_config/codec","opus/48000/2");
    cfg->setValue("main_config/turn_enabled","0");
    cfg->setValue("main_config/turn_user_name","");
    cfg->setValue("main_config/turn_password","");
    cfg->setValue("main_config/turn_server","");

    cfg->setValue("main_config/database_server_ip","176.197.36.4,1433");
    cfg->setValue("main_config/database_name","master");
    cfg->setValue("main_config/database_username","sa");
    cfg->setValue("main_config/database_password","srEgtknj34f");
    cfg->sync();
    QString srvArr[]={
        "stun.sipgate.net:3478",
        "stun.l.google.com:19302",
        "stun1.l.google.com:19302",
        "stun2.l.google.com:19302"
    };
    for(int i=0;i<4;i++)
    {
        int nextIndex = cfg->beginReadArray("stun_srv_list");
        cfg->endArray();
        cfg->beginWriteArray("stun_srv_list");
        cfg->setArrayIndex(nextIndex);
        cfg->setValue("srv_name", srvArr[i]);
        cfg->endArray();
    }
}

void Config::updateStunSrvList(QVector<QString> stunSrvList)
{
    int size=cfg->beginReadArray("stun_srv_list");
    cfg->endArray();
    for(int i=0;i<size;++i)
    {
        cfg->beginWriteArray("stun_srv_list");
        cfg->setArrayIndex(i);
        cfg->remove("");
        cfg->endArray();
    }
    cfg->beginWriteArray("stun_srv_list");
    cfg->remove("stun_srv_list");
    cfg->endArray();

    for(auto srv:stunSrvList)
    {
        if(srv!="")
        {
            int nextIndex = cfg->beginReadArray("stun_srv_list");
            cfg->endArray();
            cfg->beginWriteArray("stun_srv_list");
            cfg->setArrayIndex(nextIndex);
            cfg->setValue("srv_name", srv);
            cfg->endArray();
        }
    }
}

void Config::updateOtherSettings(QVector<QString> otherSettings)
{
    cfg->setValue("main_config/ip",otherSettings[0]);
    cfg->setValue("main_config/main_port",otherSettings[1]);
    cfg->setValue("main_config/sip_port",otherSettings[2]);
    cfg->setValue("main_config/codec",otherSettings[3]);
    cfg->setValue("main_config/turn_enabled",otherSettings[4]);
    cfg->setValue("main_config/turn_user_name",otherSettings[5]);
    cfg->setValue("main_config/turn_password",otherSettings[6]);
    cfg->setValue("main_config/turn_server",otherSettings[7]);

    cfg->sync();
}

QVector<QString> Config::getStunSrvList()
{
    QVector <QString> stunServers;
    int size = cfg->beginReadArray("stun_srv_list");
    for(int i = 0; i < size; ++i)
    {
        cfg->setArrayIndex(i);
        stunServers.append(cfg->value("srv_name").toString());
    }
    cfg->endArray();
    return stunServers;
}

QVector<QString> Config::getOtherSettings()
{
    QVector <QString> otherSettings;
    otherSettings.append("Введите адрес sip-сервера");
    otherSettings.append(cfg->value("main_config/ip").toString());
    otherSettings.append("Введите main-порт");
    otherSettings.append(cfg->value("main_config/main_port").toString());
    otherSettings.append("Введите sip-порт");
    otherSettings.append(cfg->value("main_config/sip_port").toString());
    otherSettings.append("Введите кодек");
    otherSettings.append(cfg->value("main_config/codec").toString());
    otherSettings.append("Включить TURN");
    otherSettings.append(cfg->value("main_config/turn_enabled").toString());
    otherSettings.append("Введите логин TURN");
    otherSettings.append(cfg->value("main_config/turn_user_name").toString());
    otherSettings.append("Введите пароль TURN");
    otherSettings.append(cfg->value("main_config/turn_password").toString());
    otherSettings.append("Введите адрес TURN-сервера");
    otherSettings.append(cfg->value("main_config/turn_server").toString());

    return otherSettings;
}
