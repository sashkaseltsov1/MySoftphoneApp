#include "mycall.h"

MyCall::~MyCall()
{

}
void MyCall::onCreateMediaTransport(pj::OnCreateMediaTransportParam &prm)
{

}
void MyCall::setAccount(MyAccount *acc)
{
    this->acc=acc;
}

void MyCall::onCallState(pj::OnCallStateParam &prm)
{


    PJ_UNUSED_ARG(prm);
    pj::CallInfo ci = getInfo();
    qDebug() << "*** Call: " <<  ci.remoteUri.c_str() << " [" << ci.stateText.c_str()
              << "]" <<acc->calls.size();
    if (ci.state == PJSIP_INV_STATE_CONFIRMED)
    {
        acc->setDefaultVolume();
        acc->confirmedCall(this);  
    }

    if (ci.state == PJSIP_INV_STATE_DISCONNECTED)
    {
        acc->removeCall(this);
    }

}

void MyCall::onCallMediaState(pj::OnCallMediaStateParam &prm)
{
    PJ_UNUSED_ARG(prm);
    pj::CallInfo ci = getInfo(); 

     for (unsigned i = 0; i < ci.media.size(); i++)
             {
                 if (ci.media[i].type==PJMEDIA_TYPE_AUDIO && getMedia(i))
                 {
                     aud_med = static_cast<pj::AudioMedia*>(getMedia(i));
                     mgr = &pj::Endpoint::instance().audDevManager();

                     aud_med->startTransmit(mgr->getPlaybackDevMedia());
                     mgr->getCaptureDevMedia().startTransmit(*aud_med);
                 }
             }
}
void MyCall::onCallTransferRequest(pj::OnCallTransferRequestParam &prm)
{
    /* Create new Call for call transfer */
    //prm.newCall = new MyCall(&myAcc);
}

void MyCall::onCallReplaced(pj::OnCallReplacedParam &prm)
{
    /* Create new Call for call replace */
   // prm.newCall = new MyCall(*myAcc, prm.newCallId);
}
