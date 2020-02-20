#ifndef CONFIG_H
#define CONFIG_H
#include <QSettings>
#include <QVector>
class Config
{
public:
    Config();
    ~Config(){delete cfg;}
    void initDefaultCfg();
    void updateStunSrvList(QVector<QString> stunSrvList);
    void updateOtherSettings(QVector<QString> otherSettings);
    QVector<QString> getStunSrvList();
    QVector<QString> getOtherSettings();

    QString getIp(){return cfg->value("main_config/ip").toString();}
    QString getMainPort(){return cfg->value("main_config/main_port").toString();}
    QString getSipPort(){return cfg->value("main_config/sip_port").toString();}
    QString getCodec(){return cfg->value("main_config/codec").toString();}
    QString getTurnState(){return cfg->value("main_config/turn_enabled").toString();}
    QString getTurnUserName(){return cfg->value("main_config/turn_user_name").toString();}
    QString getTurnPwd(){return cfg->value("main_config/turn_password").toString();}
    QString getTurnSrv(){return cfg->value("main_config/turn_server").toString();}


    QString getDbIp(){return cfg->value("main_config/database_server_ip").toString();}
    QString getDbName(){return cfg->value("main_config/database_name").toString();}
    QString getDbUserName(){return cfg->value("main_config/database_username").toString();}
    QString getDbPwd(){return cfg->value("main_config/database_password").toString();}


private:
    QSettings *cfg;

};

#endif // CONFIG_H
