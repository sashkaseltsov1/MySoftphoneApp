#include "sqlqueries.h"

SqlQueries::SqlQueries(QString dbSrvIp, QString dbName, QString dbUserName, QString dbPwd)
{
    QSqlDatabase db=QSqlDatabase::addDatabase("QODBC", "SqlConnect");
    QString connectString = "Driver={SQL Server};";
    connectString.append("Server="+dbSrvIp+";");
    connectString.append("Database="+dbName+";");
    connectString.append("Uid="+dbUserName+";");
    connectString.append("Pwd="+dbPwd+";");
    db.setDatabaseName(connectString);
}

QString SqlQueries::AddNewUser(QString name, QString login, QString pwd, QString cpwd)
{
    if(pwd!=cpwd | pwd=="")
        return "Ошибка: Неверный пароль!"; else
    if(pwd.size()<6)
        return "Ошибка: Пароль слишком легкий!"; else
    if(name=="")
        return "Ошибка: Заполните пустое поле!"; else
    if(name.size()<4)
        return "Ошибка: Имя слишком короткое!"; else
    if(login=="")
        return "Ошибка: Заполните пустое поле!"; else
    if(login.size()<4)
        return "Ошибка: Логин слишком короткий!"; else
    {
        QSqlDatabase db=QSqlDatabase::database("SqlConnect");

        if(db.open())
        {

            QSqlQuery query(db);

            if(!query.exec("SELECT Username FROM tb_users WHERE Username='"+login+"'"))
            {
                db.close();
                return "Ошибка: Ошибка запроса!";
            }
            if(!query.first())
            {
                query.prepare("INSERT INTO tb_users ( Type, Name, Username, Password) VALUES (0, :name, :username, :pwd)");
                query.bindValue(":name", name);
                query.bindValue(":username", login);
                query.bindValue(":pwd", pwd);

                if(query.exec())
                {
                    db.close();
                    return "Пользователь зарегистрирован!";
                }
                else
                {
                    db.close();
                    return "Ошибка: Ошибка запроса!";
                }
            }
            else
            {
                db.close();
                return "Ошибка: Пользователь с таким логином уже существует!";
            }
        } else
        {
            return "Ошибка: Не удается открыть базу данных!";
        }
    }
}

QString SqlQueries::getName(QString login)
{
    QSqlDatabase db=QSqlDatabase::database("SqlConnect");

    if(db.open())
    {
        QSqlQuery query(db);
        query.exec("SELECT Name FROM tb_users WHERE Username='"+login+"'");

        query.next();
        QString result=query.value(0).toString();
        db.close();
        return result;

    } else
    {
        return "";
    }
}

int SqlQueries::getStatus(QString login)
{
    QSqlDatabase db=QSqlDatabase::database("SqlConnect");

    if(db.open())
    {
        QSqlQuery query(db);
        query.exec("SELECT Status FROM tb_users WHERE Username='"+login+"'");

        query.next();
        int result=query.value(0).toInt();
        db.close();
        return result;

    } else
    {
        return 0;
    }
}

QVector<QString> SqlQueries::getFriendsList(QString login)
{
    QSqlDatabase db=QSqlDatabase::database("SqlConnect");
    QVector <QString> friendsList;
    if(db.open())
    {
        QSqlQuery query(db);
        query.exec("SELECT Username FROM tb_friends_"+login);

        while(query.next())
            friendsList.append(query.value(0).toString());
        db.close();
    }
    return friendsList;
}

QVector<QString> SqlQueries::getSubscribersList(QString login)
{
    QSqlDatabase db=QSqlDatabase::database("SqlConnect");
    QVector <QString> subscribersList;
    if(db.open())
    {
        QSqlQuery query(db);
        query.exec("SELECT Username FROM tb_subscribers_"+login);

        while(query.next())
            subscribersList.append(query.value(0).toString());
        db.close();
    }

    return subscribersList;
}

QVector<QString> SqlQueries::getSubscribesList(QString login)
{
    QSqlDatabase db=QSqlDatabase::database("SqlConnect");
    QVector <QString> subscribesList;
    if(db.open())
    {
        QSqlQuery query(db);
        query.exec("SELECT Username FROM tb_subscribes_"+login);

        while(query.next())
            subscribesList.append(query.value(0).toString());
        db.close();
    }

    return subscribesList;
}

QVector<QVector<QString> > SqlQueries::findFriends(QString param)
{
    QSqlDatabase db=QSqlDatabase::database("SqlConnect");
    QVector<QVector <QString>> ResultVector;
    if(db.open())
    {
        QSqlQuery query(db);
        query.exec("SELECT Username, Name FROM tb_users WHERE (Username='"+param+"' or Name='"+param+"') and Type=0");
        while(query.next())
            ResultVector.append(QVector <QString>{query.value(0).toString(), query.value(1).toString()});
        db.close();
    }
    return ResultVector;
}

bool SqlQueries::addSubscribe(QString login, QString subLogin)
{
    bool state=false;
    QSqlDatabase db=QSqlDatabase::database("SqlConnect");
    if(db.open())
    {
        QSqlQuery query1(db);
        query1.exec("SELECT Username FROM tb_subscribes_"+subLogin+" WHERE Username='"+login+"'");
        if(!query1.first())
        {
            QSqlQuery query(db);
            query.exec("INSERT INTO tb_subscribes_"+login+" (Username) VALUES ('"+subLogin+"');"
                       "INSERT INTO tb_subscribers_"+subLogin+" (Username) VALUES ('"+login+"');");
            state=true;
        }
        else
        {
            state=false;
        }
        db.close();
    }
    return state;
}

void SqlQueries::removeSubscribe(QString login, QString subLogin)
{
    QSqlDatabase db=QSqlDatabase::database("SqlConnect");
    if(db.open())
    {
        QSqlQuery query(db);
        query.exec("DELETE FROM tb_subscribes_"+login+" WHERE Username='"+subLogin+"';"
                   "DELETE FROM tb_subscribers_"+subLogin+" WHERE Username='"+login+"';");
        db.close();
    }
}

void SqlQueries::removeSubscriber(QString login, QString subLogin)
{
    QSqlDatabase db=QSqlDatabase::database("SqlConnect");
    if(db.open())
    {
        QSqlQuery query(db);
        query.exec("DELETE FROM tb_subscribes_"+subLogin+" WHERE Username='"+login+"';"
                   "DELETE FROM tb_subscribers_"+login+" WHERE Username='"+subLogin+"';");
        db.close();
    }
}

void SqlQueries::removeFriend(QString login, QString friendLogin)
{
    QSqlDatabase db=QSqlDatabase::database("SqlConnect");
    if(db.open())
    {
        QSqlQuery query(db);
        query.exec("DELETE FROM tb_friends_"+friendLogin+" WHERE Username='"+login+"';"
                   "DELETE FROM tb_friends_"+login+" WHERE Username='"+friendLogin+"';");
        db.close();
    }
}

QVector<QString> SqlQueries::addNewFriend(QString login, QString friendLogin)
{
    QVector <QString> friendEntity;
    QSqlDatabase db=QSqlDatabase::database("SqlConnect");
    if(db.open())
    {
        QSqlQuery query(db);
        query.exec("DELETE FROM tb_subscribes_"+friendLogin+" WHERE Username='"+login+"';"
                   "DELETE FROM tb_subscribers_"+login+" WHERE Username='"+friendLogin+"';"
                   "INSERT INTO tb_friends_"+login+" (Username) VALUES ('"+friendLogin+"');"
                   "INSERT INTO tb_friends_"+friendLogin+" (Username) VALUES ('"+login+"');");
        query.exec("SELECT Name, Status FROM tb_users WHERE Username='"+friendLogin+"';");
        query.next();
        friendEntity.append(query.value(0).toString());
        friendEntity.append(query.value(1).toString());
        db.close();
    }
    return friendEntity;
}


