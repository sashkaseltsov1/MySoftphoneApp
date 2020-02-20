#include "conferencecall.h"

ConferenceCall::~ConferenceCall()
{

}

void ConferenceCall::setConference(Conference *conf)
{
    this->conf=conf;
}



void ConferenceCall::onCallState(pj::OnCallStateParam &prm)
{


    PJ_UNUSED_ARG(prm);
    pj::CallInfo ci = getInfo();
    qDebug() << "*** Call: " <<  ci.remoteUri.c_str() << " [" << ci.stateText.c_str()
              << "]";
    if (ci.state == PJSIP_INV_STATE_CONFIRMED)
    {
        conf->confirmConferenceCall(this);
    }
    if (ci.state == PJSIP_INV_STATE_DISCONNECTED)
    {
        conf->removeConferenceCall(this);
    }
    if(ci.state == PJSIP_INV_STATE_CALLING)
    {
        conf->connectingConferenceCall(this);
    }

}

void ConferenceCall::onCallMediaState(pj::OnCallMediaStateParam &prm)
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



